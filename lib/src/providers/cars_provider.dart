import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img; 
import '../models/car.dart';
import 'dart:io';
import 'dart:convert'; 
import 'dart:async';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; 

// PROVIDER RESPONSAVEL POR GERENCIAR OS CARROS DO USUARIO, COM STREAM PARA ATUALIZACAO EM TEMPO REAL, FUNCOES DE ADICAO E DELECAO, E PROCESSAMENTO DE IMAGEM PARA DETECAO E BLUR DE PLACA
class CarsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  StreamSubscription<List<CarItem>>? _carSubscription;
  List<CarItem> _currentCars = [];
  
  List<CarItem> get cars => _currentCars;
  int get filledCount => _currentCars.where((c) => !c.isEmpty).length;

  String get _userId => _auth.currentUser?.uid ?? "usuario_teste";

  CarsProvider() {
    _listenToAuthChanges();
  }

// LISTENER PARA MUDANÇAS DE AUTENTICACAO, INICIANDO O STREAM DE CARROS QUANDO O USUARIO LOGA
  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((user) {
      _initStream();
    });
  }

  void _initStream() {
    _carSubscription?.cancel();
    if (_auth.currentUser == null && _userId == "usuario_teste") {
      _currentCars = [];
      notifyListeners();
    }
    _carSubscription = carStream.listen((updatedList) {
      _currentCars = updatedList;
      notifyListeners();
    }, onError: (e) {
      debugPrint("Erro no Stream de carros: $e");
    });
  }

// STREAM QUE MONITORA A COLECAO DE CARROS DO USUARIO, ORDENANDO POR DATA DE CRIACAO E ADICIONANDO UM SLOT VAZIO PARA NOVOS CARROS
  Stream<List<CarItem>> get carStream {
    return _db
        .collection('users')
        .doc(_userId) 
        .collection('cars')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final List<CarItem> fetchedCars = snapshot.docs
              .map((doc) => CarItem.fromFirestore(doc))
              .toList();
          return [...fetchedCars, CarItem.empty("new_slot")];
        });
  }

// FUNCAO PARA ADICIONAR UM CARRO, COM VERIFICACAO DE IMAGEM PARA DETECTAR SE HA UM VEICULO E PROCESSAMENTO PARA DETECTAR E BLUR DE PLACA
  Future<img.Image> _detectAndBlurPlate(File imageFile, img.Image decodedImage) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      img.Image finalImage = decodedImage;

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          String text = line.text.toUpperCase().replaceAll(' ', '');
          
          if (text.length >= 5 && text.length <= 8) {
            final rect = line.boundingBox;

            int x = rect.left.toInt();
            int y = rect.top.toInt();
            int w = rect.width.toInt();
            int h = rect.height.toInt();

            x = x.clamp(0, finalImage.width);
            y = y.clamp(0, finalImage.height);
            if (x + w > finalImage.width) w = finalImage.width - x;
            if (y + h > finalImage.height) h = finalImage.height - y;

            debugPrint("Placa detectada em: $x, $y. Texto: $text");

            img.Image plateRegion = img.copyCrop(finalImage, x: x, y: y, width: w, height: h);
            img.Image blurredPlate = img.gaussianBlur(plateRegion, radius: 20);
            img.compositeImage(finalImage, blurredPlate, dstX: x, dstY: y);
          }
        }
      }
      return finalImage;
    } catch (e) {
      debugPrint("Erro ao detectar placa: $e");
      return decodedImage;
    } finally {
      textRecognizer.close();
    }
  }

// FUNCAO PARA PROCESSAR A IMAGEM, DETECTANDO SE HA UM VEICULO E ENTÃO DETECTANDO E BLUR DE PLACA, REDIMENSIONANDO E COMPRIMINDO PARA OTIMIZAR O UPLOAD
  Future<String> _processImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? decodedImage = img.decodeImage(bytes);
      if (decodedImage == null) return "";

      img.Image imageWithBlur = await _detectAndBlurPlate(imageFile, decodedImage);

      img.Image resized = img.copyResize(imageWithBlur, width: 600);
      
      final compressedBytes = img.encodeJpg(resized, quality: 75);
      return base64Encode(compressedBytes);
    } catch (e) {
      debugPrint("Erro no processamento visual: $e");
      return "";
    }
  }

// FUNCAO PARA ADICIONAR UM CARRO
  Future<void> addCarFromGallery({
    required String name, 
    required String description,
    required String style,
    required File imageFile, 
  }) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.6));
      final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
      
      bool isVehicle = labels.any((l) => 
        ['car', 'vehicle', 'land vehicle', 'wheel', 'tire'].contains(l.label.toLowerCase())
      );
      imageLabeler.close();

      if (!isVehicle) throw Exception("Nenhum veículo detectado");

      final base64Image = await _processImage(imageFile);
      
      await _db.collection('users').doc(_userId).collection('cars').add({
        'name': name,
        'description': description,
        'style': style,
        'imageUrl': base64Image, 
        'createdAt': FieldValue.serverTimestamp(),
        'isFavorite': false,
      });
      
    } catch (e) {
      rethrow; 
    }
  }

// FUNCAO PARA DELETAR UM CARRO
  Future<void> deleteCar(String carId) async {
    try {
      await _db.collection('users').doc(_userId).collection('cars').doc(carId).delete();
    } catch (e) {
      debugPrint("Erro ao deletar: $e");
    }
  }

  @override
  void dispose() {
    _carSubscription?.cancel();
    super.dispose();
  }
}