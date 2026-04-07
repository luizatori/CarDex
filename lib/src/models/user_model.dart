class UserModel {
  final String uid;
  final String email;
  final String username;
  final int points;
  final List<String> capturedCars; 

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.points = 0,
    this.capturedCars = const [],
  });

  // conversao de dados para o firestore 
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'points': points,
      'capturedCars': capturedCars,
    };
  }
}