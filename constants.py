from dataclasses import dataclass

@dataclass(frozen=True)
class Config:
    # paths
    DATA_DIR: str = 'data'
    MODEL_SAVE_PATH: str = "plant_recognition.h5"
    TFLITE_SAVE_PATH: str = "plant_recognition.tflite"

    # params
    IMG_SIZE: int = 224  # 224x224 pixels
    BATCH_SIZE: int = 32  # número de imagens de entrada na CNN
    EPOCHS: int = 12  # número etapas de treinamento
