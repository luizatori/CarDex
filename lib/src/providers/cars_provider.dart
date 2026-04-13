import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img; 
import '../models/car.dart';
import 'dart:io';
import 'dart:convert'; 
import 'dart:async';

// PROVIDER DE CARROS, RESPONSAVEL POR GERENCIAR A LISTA DE CARROS DO USUARIO, INCLUINDO STREAM DE DADOS, ADICAO E EXCLUSAO DE CARDS DE CARROS 
class CarsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // atualiza a lista em tempo real
  StreamSubscription<List<CarItem>>? _carSubscription;
  List<CarItem> _currentCars = [];
  
  List<CarItem> get cars => _currentCars;
  int get filledCount => _currentCars.where((c) => !c.isEmpty).length;

//garantir que o provider sempre tem um userId, mesmo que seja um usuario teste para evitar erros de null e permitir que o app funcione mesmo sem login (com funcionalidades limitadas)
  String get _userId => _auth.currentUser?.uid ?? "usuario_teste";

  CarsProvider() {
    _listenToAuthChanges();
  }

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

// tratamento de stream 
    _carSubscription = carStream.listen((updatedList) {
      _currentCars = updatedList;
      notifyListeners();
    }, onError: (e) {
      debugPrint("Erro no Stream de carros: $e");
    });
  }

// stream de dados de carros que sao armazenados no Firestore 
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
          
          // garante que sempre haja um slot vazio 
          return [...fetchedCars, CarItem.empty("new_slot")];
        });
  }

// METODO PARA PROCESSAR A IMAGEM E REDIMENCIONAR PARA CONVERSAO PARA BASE64 
  Future<String> _processImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return "";

      img.Image resized = img.copyResize(image, width: 500);
      final compressedBytes = img.encodeJpg(resized, quality: 70);
      return base64Encode(compressedBytes);
    } catch (e) {
      debugPrint("Erro ao processar imagem: $e");
      return "";
    }
  }

// METODO PARA ADICIONAR UM CARRO A PARTIR DA GALERIA
  Future<void> addCarFromGallery({
    required String name, 
    required String description,
    required String style,
    required File imageFile, 
  }) async {
    debugPrint("Salvando para o usuário: $_userId");
    try {
      final base64Image = await _processImage(imageFile);
      
      // associa o carro ao usuaio logado 
      await _db.collection('users').doc(_userId).collection('cars').add({
        'name': name,
        'description': description,
        'style': style,
        'imageUrl': base64Image, 
        'createdAt': FieldValue.serverTimestamp(),
        'isFavorite': false,
      });
    } catch (e) {
      debugPrint("Erro ao salvar: $e");
    }
  }

// FUNCAO PARA DELETAR UM CARRO DO FIRESTORE
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