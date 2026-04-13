
//MODELO DE DADOS PARA O USUARIO, USADO PARA GERENCIAR AS INFORMACOES DO USUARIO LOGADO
class UserModel {
  final String uid; 
  final String email;
  final String username; // nome armazenado no Firestore (pode ser diferente do nome de perfil)
  final int points; 
  final List<String> capturedCars; 

// construtor do UserModel
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