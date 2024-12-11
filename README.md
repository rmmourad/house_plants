# Classificador de Plantas - Flutter + TensorFlow

Este repositório contém o código de um aplicativo Flutter que utiliza uma rede neural treinada com TensorFlow para classificar plantas a partir de suas imagens. O modelo foi treinado para identificar diferentes espécies de plantas com base em imagens, e o aplicativo permite que o usuário capture ou selecione uma foto para ser classificada.

## Tecnologias

- **Flutter**: Framework para criar aplicativos móveis nativos.
- **TensorFlow**: Biblioteca usada para treinar e implementar modelos de aprendizado de máquina.
- **TensorFlow Lite**: Versão otimizada do TensorFlow para dispositivos móveis, usada para executar o modelo no aplicativo Flutter.

## Funcionalidades

- **Captura de Imagem**: O usuário pode tirar uma foto diretamente no aplicativo ou selecionar uma imagem da galeria.
- **Classificação de Plantas**: Após a captura da imagem, o modelo classifica a planta e retorna o nome da espécie.
- **Exibição de Resultados**: O nome da planta é exibido, junto com a probabilidade de acerto.
- **Feedback de Precisão**: O aplicativo também exibe o nível de confiança na classificação realizada.

## Requisitos

- **Flutter**: Para rodar o aplicativo, é necessário ter o [Flutter](https://flutter.dev/docs/get-started/install) instalado.
- **TensorFlow Lite**: O modelo foi treinado utilizando o [TensorFlow](https://www.tensorflow.org/) e exportado para o formato [TensorFlow Lite](https://www.tensorflow.org/lite).

## Instalação

1. **Clone o repositório**:

```bash
git clone https://github.com/seu-usuario/classificador-de-plantas.git
cd classificador-de-plantas
```

2. **Instale as dependências do Flutter**:

```bash
flutter pub get
```

3. **Execute o aplicativo**:

```bash
flutter run
```

## Treinamento do Modelo

O modelo foi treinado utilizando imagens de plantas e salvando-o em formato TensorFlow Lite. Para treinar o modelo, siga os seguintes passos:

1. Prepare um dataset com imagens das plantas.
2. Use o TensorFlow para treinar a rede neural com base nas imagens.
3. Converta o modelo treinado para o formato TensorFlow Lite utilizando o comando:

```bash
tflite_convert --saved_model_dir=/path/to/saved_model --output_file=model.tflite
```

4. Coloque o arquivo `model.tflite` na pasta `assets/` do seu projeto Flutter.

## Estrutura do Projeto

- `lib/`: Contém o código Dart do aplicativo Flutter.
  - `main.dart`: Arquivo principal do aplicativo.
  - `classifier.dart`: Contém o código responsável pela classificação usando TensorFlow Lite.
  - `camera.dart`: Implementação para captura de imagens.
- `assets/`: Contém o modelo `model.tflite`.
- `pubspec.yaml`: Arquivo de configuração do Flutter, onde as dependências estão declaradas.

## Dependências

As principais dependências do projeto são:

- `flutter_tflite`: Para integrar o modelo TensorFlow Lite ao Flutter.
- `image_picker`: Para selecionar imagens da galeria ou capturar novas fotos.
- `camera`: Para capturar imagens diretamente pela câmera do dispositivo.

Exemplo do `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^0.8.5+3
  camera: ^0.10.0
  flutter_tflite: ^1.1.2
```

## Contribuição

Se você deseja contribuir para este projeto, fique à vontade para fazer um fork e enviar pull requests. Antes de enviar contribuições significativas, por favor, abra uma *issue* para discutir os detalhes da alteração proposta.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

---

Esse é um guia básico para configurar o projeto e seu funcionamento. Caso tenha dúvidas ou problemas, sinta-se à vontade para abrir uma *issue* aqui no GitHub!

