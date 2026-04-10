import 'package:cloud_firestore/cloud_firestore.dart';

class CarItem {
  final String id;
  String name;
  String description;
  String? imageUrl;
  String style;
  bool isEmpty;
  bool isFavorite; 
  final dynamic createdAt; 
  final dynamic updatedAt;

  CarItem({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.style,
    required this.isEmpty,
    this.isFavorite = false, 
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isBase64 => imageUrl != null && imageUrl!.length > 100;

  factory CarItem.empty(String id) {
    final now = DateTime.now().toIso8601String();
    return CarItem(
      id: id,
      name: "",
      description: "",
      style: "default",
      isEmpty: true,
      isFavorite: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory CarItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return CarItem(
      id: doc.id,
      name: data['name'] ?? "",
      description: data['description'] ?? "",
      imageUrl: data['imageUrl'], 
      style: data['style'] ?? "default",
      isEmpty: false, 
      isFavorite: data['isFavorite'] ?? false, 
      createdAt: data['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
      updatedAt: data['updatedAt']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'style': style,
      'isFavorite': isFavorite, 
      'createdAt': createdAt,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}

// CONFIGURACAO DAS MOLDURAS 

class StyleOption {
  final String key;
  final String label;
  final String color;
  final bool locked;
  final String? requirement;
  final int? requiredCount;

  const StyleOption({
    required this.key,
    required this.label,
    required this.color,
    required this.locked,
    this.requirement,
    this.requiredCount,
  });
}

class StyleOptions {
  static const List<StyleOption> options = [
    StyleOption(
      key: "default",
      label: "Padrão",
      color: "#64748b", 
      locked: false,
      requiredCount: 0,
    ),
    StyleOption(
      key: "vintage",
      label: "Vintage",
      color: "#8B7355",
      locked: true,
      requiredCount: 5,
      requirement: "Tenha 5 carros na coleção para desbloquear.",
    ),
    StyleOption(
      key: "gold",
      label: "Ouro",
      color: "#C5A355",
      locked: true,
      requiredCount: 10,
      requirement: "Tenha 10 carros na coleção para desbloquear.",
    ),
    StyleOption(
      key: "silver",
      label: "Prata",
      color: "#C0C0C0",
      locked: true,
      requiredCount: 15,
      requirement: "Tenha 15 carros na coleção para desbloquear.",
    ),
    StyleOption(
      key: "holographic",
      label: "Holo",
      color: "#7B68EE",
      locked: true,
      requiredCount: 25,
      requirement: "Tenha 25 carros na coleção para desbloquear.",
    ),
    StyleOption(
      key: "crimson",
      label: "Carmesim",
      color: "#DC143C",
      locked: true,
      requiredCount: 30,
      requirement: "Tenha 30 carros na coleção para desbloquear.",
    ),
    StyleOption(
      key: "pastel-rose",
      label: "Rosa Pastel",
      color: "#FFB6C1",
      locked: true,
      requiredCount: 35,
      requirement: "Tenha 35 carros na coleção para desbloquear.",
    ),
    StyleOption(
      key: "destroyed",
      label: "Destruído",
      color: "#4A4A4A",
      locked: true,
      requiredCount: 40,
      requirement: "Tenha 40 carros na coleção para desbloquear.",
    ),
    StyleOption(
      key: "carbon",
      label: "Carbono",
      color: "#2a2a2a",
      locked: true,
      requiredCount: 50,
      requirement: "Tenha 50 carros na coleção para desbloquear.",
    ),
    StyleOption(
      key: "nature",
      label: "Natureza",
      color: "#228B22",
      locked: true,
      requiredCount: 60,
      requirement: "Tenha 60 carros na coleção para desbloquear.",
    ),
    StyleOption(
      key: "neon",
      label: "Neon",
      color: "#39ff14",
      locked: true,
      requiredCount: 100,
      requirement: "Tenha 100 carros na coleção para desbloquear.",
    ),
    StyleOption(
      key: "ace-spades",
      label: "Ás de Espadas",
      color: "#1a1a2e",
      locked: true,
      requiredCount: 150,
      requirement: "Tenha 150 carros na coleção para desbloquear.",
    ),
  ];
}