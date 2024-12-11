#projects
from utils.constants import Config

#built-in
import os

#third-party
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import ( Conv2D, # camada convolucional 2d, que cria um kernel convolucional para detectar padrões
                                Dropout, # camada de dropout, que desativa aleatoriamente um número de unidades de entrada 
                                        # para evitar overfitting, isto é, para que o modelo não se aproxime tanto dos dados de treinamento.
                                GlobalAveragePooling2D, # calcula a média dos valores de cada mapa de características,
                                                        # reduzindo a dimensionalidade e preparando os dados para a camada final. 
                                Dense) # cada na qual cada neurônio se conecta a todos os neurônios da camada anterior.

DATA_DIR = Config.DATA_DIR
MODEL_SAVE_PATH = Config.MODEL_SAVE_PATH
TFLITE_SAVE_PATH = Config.TFLITE_SAVE_PATH
IMG_SIZE = Config.IMG_SIZE
BATCH_SIZE = Config.BATCH_SIZE
EPOCHS = Config.EPOCHS
IMG_SHAPE = (IMG_SIZE, IMG_SIZE, 3)

# preprocessamento
datagen = ImageDataGenerator(
    rescale=1.0/255, # diminui o tamanho do arquivo, resultando em um treinamento mais rápido
    validation_split=0.2,  # 80% para treinar, 20% para validar
)

train_gen = datagen.flow_from_directory(
    DATA_DIR,
    target_size=(IMG_SIZE, IMG_SIZE),
    batch_size=BATCH_SIZE,
    subset='training'
)

val_gen = datagen.flow_from_directory(
    DATA_DIR,
    target_size=(IMG_SIZE, IMG_SIZE),
    batch_size=BATCH_SIZE,
    subset='validation'
)

base_model = MobileNetV2(
    input_shape=IMG_SHAPE,
    include_top=False,
    weights='imagenet'
)

labels = '\n'.join(sorted(train_gen.class_indices.keys()))
with open('plant_labels.txt', 'w') as f:
    f.write(labels)
    
base_model.trainable = False
model = tf.keras.Sequential([
    base_model,
    Conv2D(32, 3, activation='relu'), 
    Dropout(0.2),  # dense layer
    GlobalAveragePooling2D(),               
    Dense(train_gen.num_classes, activation='softmax') 
])
# add regularizers to dense layer
#    units=64,
#     kernel_regularizer=regularizers.L1L2(l1=1e-5, l2=1e-4),
#     bias_regularizer=regularizers.L2(1e-4),
#     activity_regularizer=regularizers.L2(1e-5)
model.compile(optimizer=tf.keras.optimizers.Adam(),
              loss='categorical_crossentropy',
              metrics=['accuracy'])

# treinamento
print("Treinando o modelo...")
history = model.fit(train_gen, 
                    validation_data=val_gen, 
                    epochs=EPOCHS)

print("Salvando o modelo...")
tf.keras.models.save_model(model, MODEL_SAVE_PATH, save_format="tf")
saved_model = tf.keras.models.load_model('plant_recognition.h5')
converter = tf.lite.TFLiteConverter.from_keras_model(saved_model)
tflite_model = converter.convert()
open(TFLITE_SAVE_PATH, "wb").write(tflite_model)

print(f"Modelo salvo em: {TFLITE_SAVE_PATH}")

# # inserção no pubspec
# pubspec_path = '../app/pubspec.yaml'
# model_asset_entry = '    - assets/ml/plant_recognition_model.tflite\n'
# with open(pubspec_path, 'r+') as f:
#     lines = f.readlines()
#     if model_asset_entry not in lines:
#         for i, line in enumerate(lines):
#             if line.strip() == 'assets:':
#                 lines.insert(i + 1, model_asset_entry)
#                 break
#         f.seek(0)
#         f.writelines(lines)

