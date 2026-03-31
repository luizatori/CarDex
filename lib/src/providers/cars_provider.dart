import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img; 
import '../models/car.dart';
import 'dart:io';
import 'dart:convert'; 

class CarsProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // ID fixo para desenvolvimento sem login
  final String _tempUid = "usuario_teste"; 

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
          
          return [...fetchedCars, CarItem.empty("new_slot")];
        });
  }

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