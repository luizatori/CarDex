import 'dart:math';
import 'package:flutter_test/flutter_test.dart';


String generateRandomCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return String.fromCharCodes(
    Iterable.generate(7, (_) => chars.codeUnitAt(Random().nextInt(chars.length))),
  );
}

void main() {
  group('RegisterScreen — lógica de código de verificação', () {
    test('TC01 — Código gerado tem exatamente 7 caracteres', () {
      // ACT
      final code = generateRandomCode();

      // ASSERT
      expect(code.length, 7);
    });

    test('TC02 — Código contém apenas letras maiúsculas e dígitos', () {
      // ACT
      final code = generateRandomCode();

      // ASSERT
      final valido = RegExp(r'^[A-Z0-9]+$');
      expect(
        valido.hasMatch(code),
        isTrue,
        reason: 'Código "$code" contém caracteres inválidos',
      );
    });

    test('TC03 — Dois códigos gerados em sequência são diferentes (aleatoriedade)', () {
      // ACT
      final code1 = generateRandomCode();
      final code2 = generateRandomCode();

      
      expect(code1, isNot(equals(code2)));
    });

    test('TC04 — Código gerado não contém espaços ou caracteres especiais', () {
      // ACT 
      final codes = List.generate(50, (_) => generateRandomCode());

      // ASSERT
      for (final code in codes) {
        expect(
          code.contains(RegExp(r'[^A-Z0-9]')),
          isFalse,
          reason: 'Código "$code" contém caractere inválido',
        );
      }
    });

    test('TC05 — Validação de código correto (case-insensitive, como na tela)', () {
      // ARRANGE
      final generatedCode = generateRandomCode();
      final digitadoPeloUsuario = generatedCode.toLowerCase();

      // ACT 
      final isValid = digitadoPeloUsuario.toUpperCase() == generatedCode;

      // ASSERT
      expect(isValid, isTrue);
    });

    test('TC06 — Validação falha com código incorreto', () {
      // ARRANGE
      const generatedCode = 'ABC1234';
      const codigoErrado = 'XYZ9999';

      // ACT
      final isValid = codigoErrado.toUpperCase() == generatedCode;

      // ASSERT
      expect(isValid, isFalse);
    });
  });

  group('LoginScreen — validação de campos (lógica isolada)', () {
    // Simulação da validação 
    String? validateLoginFields(String email, String password) {
      if (email.isEmpty || password.isEmpty) {
        return 'POR FAVOR, PREENCHA TODOS OS CAMPOS.';
      }
      return null;
    }

    test('TC07 — Campos preenchidos não retornam erro de validação', () {
      // ACT
      final error = validateLoginFields('user@email.com', 'senha123');

      // ASSERT
      expect(error, isNull);
    });

    test('TC08 — Email vazio retorna mensagem de erro', () {
      // ACT
      final error = validateLoginFields('', 'senha123');

      // ASSERT
      expect(error, 'POR FAVOR, PREENCHA TODOS OS CAMPOS.');
    });

    test('TC09 — Senha vazia retorna mensagem de erro', () {
      // ACT
      final error = validateLoginFields('user@email.com', '');

      // ASSERT
      expect(error, 'POR FAVOR, PREENCHA TODOS OS CAMPOS.');
    });

    test('TC10 — Ambos os campos vazios retornam mensagem de erro', () {
      // ACT
      final error = validateLoginFields('', '');

      // ASSERT
      expect(error, isNotNull);
    });
  });

  group('RegisterScreen — validação de campos (lógica isolada)', () {
    
    String? validateRegisterFields(String username, String email, String password) {
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        return 'POR FAVOR, PREENCHA TODOS OS CAMPOS.';
      }
      return null;
    }

    test('TC11 — Todos os campos preenchidos não retornam erro', () {
      // ACT
      final error = validateRegisterFields('Joao', 'joao@email.com', 'senha123');

      // ASSERT
      expect(error, isNull);
    });

    test('TC12 — Username vazio retorna mensagem de erro', () {
      // ACT
      final error = validateRegisterFields('', 'joao@email.com', 'senha123');

      // ASSERT
      expect(error, isNotNull);
    });

    test('TC13 — Qualquer campo vazio no cadastro retorna mensagem de erro', () {
      // ARRANGE
      final casos = [
        ['', 'email@email.com', 'senha'],
        ['nome', '', 'senha'],
        ['nome', 'email@email.com', ''],
      ];

      // ACT & ASSERT
      for (final caso in casos) {
        final error = validateRegisterFields(caso[0], caso[1], caso[2]);
        expect(
          error,
          isNotNull,
          reason: 'Esperava erro para: username="${caso[0]}", email="${caso[1]}", senha="${caso[2]}"',
        );
      }
    });
  });
}
