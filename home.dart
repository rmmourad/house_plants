import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:permission_handler/permission_handler.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late File _image;
  bool _loading = true;
  String label = '';
  double confidence = 0.0;
  final picker = ImagePicker();
  late List _output;

  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.photos].request();
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadModel();
  }

  Future<void> _loadModel() async {
    String? response = await Tflite.loadModel(
      model: "assets/plant_recognition.tflite",
      labels: "assets/plant_labels.txt",
    );
  }

  Future<void> runModel(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 47,
      threshold: 0.5,
      asynch: true,
    );

    if (output == null) {
      return ;
    }

    setState(() {
      _output = output;
      _loading = false;
      confidence = (output[0]['confidence'] * 100);
      label = output[0]['label'].toString();
    });
  }

  Future<void> _pickGalImg() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    runModel(_image);
  }

  Future<void>_pickCamImg() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    runModel(_image);
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green[700],
      centerTitle: true,
      title: Text(
        'CPlant - Classificador de Plantas',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 25,
        ),
      ),
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[200]!, Colors.green[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset('assets/logo.png', height: 300),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Text(
                'Nosso Classificador de Plantas foi desenvolvido para ajudar você a identificar plantas com facilidade, utilizando apenas uma foto. A motivação por trás desse projeto é proporcionar uma forma simples e rápida de aprender mais sobre as plantas ao seu redor!',
                textAlign: TextAlign.justify, 
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 18, 
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (!_loading && _image != null)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.file(
                      _image,
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_output != null)
                    Text(
                      'Planta identificada: $label',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  SizedBox(height: 20),
                ],
              ),
            // botoes
            Spacer(), 
            _buildActionButton('Tire uma foto!', _pickCamImg),
            SizedBox(height: 40), 
            _buildActionButton('Selecione da galeria!', _pickGalImg),
          ],
        ),
      ),
    ),
  );
}

Widget _buildActionButton(String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: MediaQuery.of(context).size.width - 200,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}
} 