import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img; 
import '../models/car.dart';
import 'dart:io';
import 'dart:convert'; 

// provider para gerenciamento de carros, inccluindo leitura de firestore
class CarsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // usuario teste para desenvolvimento, depois sera substituído pelo usuario autenticado
  final String _tempUid = "usuario_teste"; 

  // variavel interna para armazenar os carros atuais do Stream
  List<CarItem> _currentCars = [];

  // getter para a lista de carros 
  List<CarItem> get cars => _currentCars;

  // getter para a contagem 
  int get filledCount => _currentCars.where((c) => !c.isEmpty).length;

  CarsProvider() {
    // Escuta o stream e atualiza a lista interna sempre que o banco mudar
    carStream.listen((updatedList) {
      _currentCars = updatedList;
      notifyListeners(); // avisa a UI para atualizar
    });
  }

  Stream<List<CarItem>> get carStream {
    return _db
        .collection('users')
        .doc(_tempUid) 
        .collection('cars')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final List<CarItem> fetchedCars = snapshot.docs
              .map((doc) => CarItem.fromFirestore(doc))
              .toList();
          
          // mantem a logica de ter um slot vazio no final para o card de adicionar
          return [...fetchedCars, CarItem.empty("new_slot")];
        });
  }

  // metodos
  Future<String> _processImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return "";

    img.Image resized = img.copyResize(image, width: 500);
    final compressedBytes = img.encodeJpg(resized, quality: 70);

    return base64Encode(compressedBytes);
  }

  Future<void> addCarFromGallery({
    required String name, 
    required String description,
    required String style,
    required File imageFile, 
  }) async {

    debugPrint("Iniciando salvamento para o usuário: $_tempUid");

    try {
      final base64Image = await _processImage(imageFile);
      debugPrint("Imagem processada com sucesso.");

      await _db.collection('users').doc(_tempUid).collection('cars').add({
        'name': name,
        'description': description,
        'style': style,
        'imageUrl': base64Image, 
        'createdAt': FieldValue.serverTimestamp(),
        'isFavorite': false,
      });
      
      debugPrint("SUCESSO: Carro salvo no Firestore!");
      notifyListeners();
    } catch (e) {
      debugPrint("ERRO CRÍTICO ao salvar no Firestore: $e");
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      await _db.collection('users').doc(_tempUid).collection('cars').doc(carId).delete();
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao deletar: $e");
    }
  }
}