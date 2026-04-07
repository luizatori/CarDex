import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img; 
import '../models/car.dart';
import 'dart:io';
import 'dart:convert'; 
import 'dart:async';

class CarsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  StreamSubscription<List<CarItem>>? _carSubscription;
  List<CarItem> _currentCars = [];
  
  List<CarItem> get cars => _currentCars;
  int get filledCount => _currentCars.where((c) => !c.isEmpty).length;

  // getter dinamico
  String get _userId => _auth.currentUser?.uid ?? "usuario_teste";

  CarsProvider() {
    _listenToAuthChanges();
  }

  // escuta mudancas de autenticacao para atuzalizar stream de carros 
  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((user) {
      _initStream();
    });
  }

  // inicializa ou reinicia a escuta do banco vinculada ao usuario atual
  void _initStream() {

    // cancela a inscricao anterior se existir para nao haver vazamento de memoria
    _carSubscription?.cancel();

    // se nao houver usuario e nao estivermos em modo teste, a lista e limpada
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
          
          // retorna a lista do banco + o slot vazio para o botao de "adicionar" na UI
          return [...fetchedCars, CarItem.empty("new_slot")];
        });
  }

  // processamento de imagem otimizado
  Future<String> _processImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return "";

      // redimensiona mantendo o aspecto se possivel, largura de 500px é boa para mobile
      img.Image resized = img.copyResize(image, width: 500);
      final compressedBytes = img.encodeJpg(resized, quality: 70);
      return base64Encode(compressedBytes);
    } catch (e) {
      debugPrint("Erro ao processar imagem: $e");
      return "";
    }
  }

  Future<void> addCarFromGallery({
    required String name, 
    required String description,
    required String style,
    required File imageFile, 
  }) async {
    debugPrint("Salvando para o usuário: $_userId");
    try {
      final base64Image = await _processImage(imageFile);
      
      await _db.collection('users').doc(_userId).collection('cars').add({
        'name': name,
        'description': description,
        'style': style,
        'imageUrl': base64Image, 
        'createdAt': FieldValue.serverTimestamp(),
        'isFavorite': false,
      });
      // notifyListeners() nao é estritamente necessario aqui pois o stream (snapshots) ja vai detectar a mudança no firebase e atualizar a lista sozinho.
    } catch (e) {
      debugPrint("Erro ao salvar: $e");
    }
  }

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