import 'package:flutter_test/flutter_test.dart';
import 'package:CarDex/src/models/user_model.dart';

void main() {
  group('UserModel - Testes de unidade', () {
    test('TC01 — UserModel criado com valores padrão corretos', () {
      // ARRANGE & ACT
      final user = UserModel(
        uid: 'uid_123',
        email: 'joao@email.com',
        username: 'joao',
      );

      // ASSERT
      expect(user.uid, 'uid_123');
      expect(user.email, 'joao@email.com');
      expect(user.username, 'joao');
      expect(user.points, 0);
      expect(user.capturedCars, isEmpty);
    });

    test('TC02 — UserModel criado com pontos e carros capturados', () {
      // ARRANGE & ACT
      final user = UserModel(
        uid: 'uid_456',
        email: 'maria@email.com',
        username: 'maria',
        points: 150,
        capturedCars: ['car_1', 'car_2', 'car_3'],
      );

      // ASSERT
      expect(user.points, 150);
      expect(user.capturedCars.length, 3);
      expect(user.capturedCars, contains('car_2'));
    });

    test('TC03 — toMap serializa os campos corretamente', () {
      // ARRANGE
      final user = UserModel(
        uid: 'uid_789',
        email: 'pedro@email.com',
        username: 'pedro',
        points: 50,
        capturedCars: ['car_a'],
      );

      // ACT
      final map = user.toMap();

      // ASSERT
      expect(map['uid'], 'uid_789');
      expect(map['email'], 'pedro@email.com');
      expect(map['username'], 'pedro');
      expect(map['points'], 50);
      expect(map['capturedCars'], ['car_a']);
    });

    test('TC04 — toMap de usuário novo tem lista de carros vazia', () {
      // ARRANGE
      final user = UserModel(
        uid: 'novo_uid',
        email: 'novo@email.com',
        username: 'novoUsuario',
      );

      // ACT
      final map = user.toMap();

      // ASSERT
      expect(map['capturedCars'], isEmpty);
      expect(map['points'], 0);
    });
  });
}
