import 'package:flutter/material.dart';
import '../models/car.dart';

class CarsProvider extends ChangeNotifier {
  final List<CarItem> _cars = [
    CarItem.empty("1"),
  ];

  List<CarItem> get cars => _cars;
  int _nextId = 2;

  void addOrUpdateCar({
    required String id,
    required String name,
    required String description,
    required String style,
    required String imageUrl, 
  }) {
    final index = _cars.indexWhere((c) => c.id == id);
    if (index == -1) return;

    final car = _cars[index];

    final updatedCar = CarItem(
      id: id,
      name: name,
      description: description,
      style: style,
      imageUrl: imageUrl, 
      isEmpty: false,
      createdAt: car.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    _cars[index] = updatedCar;

    if (car.isEmpty) {
      _cars.add(CarItem.empty((_nextId++).toString()));
    }

    notifyListeners();
  }

  void deleteCar(String id) {
    _cars.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  int get filledCount {
    return _cars.where((c) => !c.isEmpty).length;
  }
}