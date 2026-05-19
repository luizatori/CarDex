import 'package:flutter_test/flutter_test.dart';
import 'package:CarDex/src/models/car.dart';

void main() {
  group('CarItem - Testes de unidade', () {
    test('TC01 — CarItem.empty cria um slot vazio com valores padrão', () {
      // ARRANGE & ACT
      final car = CarItem.empty('slot_1');

      // ASSERT
      expect(car.id, 'slot_1');
      expect(car.isEmpty, isTrue);
      expect(car.name, '');
      expect(car.description, '');
      expect(car.style, 'default');
      expect(car.isFavorite, isFalse);
      expect(car.imageUrl, isNull);
    });

    test('TC02 — isBase64 retorna false para URL curta (link de imagem normal)', () {
      // ARRANGE
      final car = CarItem(
        id: '1',
        name: 'Civic',
        description: 'Honda Civic azul',
        imageUrl: 'https://foto.com/img.jpg',
        style: 'default',
        isEmpty: false,
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
      );

      // ASSERT
      expect(car.isBase64, isFalse);
    });

    test('TC03 — isBase64 retorna true para string base64 longa', () {
      // ARRANGE
      final base64String = 'data:image/jpeg;base64,' + ('A' * 200);
      final car = CarItem(
        id: '2',
        name: 'Mustang',
        description: 'Ford Mustang vermelho',
        imageUrl: base64String,
        style: 'gold',
        isEmpty: false,
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
      );

      // ASSERT
      expect(car.isBase64, isTrue);
    });

    test('TC04 — isBase64 retorna false quando imageUrl é nulo', () {
      // ARRANGE
      final car = CarItem(
        id: '3',
        name: 'Gol',
        description: 'VW Gol prata',
        imageUrl: null,
        style: 'silver',
        isEmpty: false,
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
      );

      // ASSERT
      expect(car.isBase64, isFalse);
    });

    test('TC05 — toMap serializa os campos corretamente', () {
      // ARRANGE
      final car = CarItem(
        id: '4',
        name: 'Fusca',
        description: 'VW Fusca verde',
        imageUrl: 'https://img.com/fusca.jpg',
        style: 'vintage',
        isEmpty: false,
        isFavorite: true,
        createdAt: '2024-01-01',
        updatedAt: '2024-01-02',
      );

      // ACT
      final map = car.toMap();

      // ASSERT
      expect(map['name'], 'Fusca');
      expect(map['description'], 'VW Fusca verde');
      expect(map['style'], 'vintage');
      expect(map['isFavorite'], isTrue);
      expect(map['imageUrl'], 'https://img.com/fusca.jpg');
    });

    test('TC06 — toMap não inclui o campo id', () {
      // ARRANGE
      final car = CarItem(
        id: 'id_privado',
        name: 'Uno',
        description: 'Fiat Uno branco',
        style: 'default',
        isEmpty: false,
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
      );

      // ACT
      final map = car.toMap();

      // ASSERT
      expect(map.containsKey('id'), isFalse);
    });
  });

  group('StyleOptions - Testes de unidade', () {
    test('TC07 — primeiro estilo é o padrão e não está bloqueado', () {
      // ARRANGE & ACT
      final primeiro = StyleOptions.options.first;

      // ASSERT
      expect(primeiro.key, 'default');
      expect(primeiro.locked, isFalse);
      expect(primeiro.requiredCount, 0);
    });

    test('TC08 — estilos bloqueados possuem requiredCount maior que zero', () {
      // ARRANGE & ACT
      final bloqueados = StyleOptions.options.where((s) => s.locked);

      // ASSERT
      for (final estilo in bloqueados) {
        expect(
          estilo.requiredCount,
          greaterThan(0),
          reason: 'Estilo "${estilo.label}" está bloqueado mas requiredCount é zero',
        );
      }
    });

    test('TC09 — estilo neon exige 100 carros para desbloquear', () {
      // ARRANGE & ACT
      final neon = StyleOptions.options.firstWhere((s) => s.key == 'neon');

      // ASSERT
      expect(neon.locked, isTrue);
      expect(neon.requiredCount, 100);
    });

    test('TC10 — todos os estilos bloqueados possuem mensagem de requisito', () {
      // ARRANGE & ACT
      final bloqueados = StyleOptions.options.where((s) => s.locked);

      // ASSERT
      for (final estilo in bloqueados) {
        expect(
          estilo.requirement,
          isNotNull,
          reason: 'Estilo "${estilo.label}" está bloqueado mas não tem mensagem de requisito',
        );
        expect(estilo.requirement!.isNotEmpty, isTrue);
      }
    });

    test('TC11 — estilo ace-spades exige mais carros que o neon', () {
      // ARRANGE
      final neon = StyleOptions.options.firstWhere((s) => s.key == 'neon');
      final ace = StyleOptions.options.firstWhere((s) => s.key == 'ace-spades');

      // ASSERT
      expect(ace.requiredCount! > neon.requiredCount!, isTrue);
    });
  });
}
