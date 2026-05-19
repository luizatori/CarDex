import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:CarDex/src/utils/car_styles.dart';

void main() {
  group('CarSkinTheme - Testes de unidade', () {
    test('TC01 — Estilo default no modo escuro retorna cores escuras', () {
      // ARRANGE & ACT
      final theme = CarSkinTheme.getTheme('default', true);

      // ASSERT
      expect(theme.textColor, Colors.white);
      expect(theme.bgColor, const Color(0xFF1A1A1A));
      expect(theme.borderWidth, 1.0);
    });

    test('TC02 — Estilo default no modo claro retorna cores claras', () {
      // ARRANGE & ACT
      final theme = CarSkinTheme.getTheme('default', false);

      // ASSERT
      expect(theme.textColor, Colors.black);
      expect(theme.bgColor, Colors.white);
    });

    test('TC03 — Estilo gold retorna cor de texto marrom escuro', () {
      // ARRANGE & ACT
      final theme = CarSkinTheme.getTheme('gold', false);

      // ASSERT
      expect(theme.textColor, const Color(0xFF5C4033));
      expect(theme.bgColor, const Color(0xFFD4AF37));
    });

    test('TC04 — Estilo "ouro" é reconhecido como alias de gold', () {
      // ARRANGE
      final themeGold = CarSkinTheme.getTheme('gold', false);
      final themeOuro = CarSkinTheme.getTheme('ouro', false);

      // ASSERT
      expect(themeOuro.bgColor, themeGold.bgColor);
      expect(themeOuro.textColor, themeGold.textColor);
    });

    test('TC05 — Estilo silver retorna cor de texto cinza escuro', () {
      // ARRANGE & ACT
      final theme = CarSkinTheme.getTheme('silver', false);

      // ASSERT
      expect(theme.textColor, const Color(0xFF454545));
      expect(theme.bgColor, const Color(0xFFC0C0C0));
    });

    test('TC06 — Estilo neon tem cor de borda verde neon', () {
      // ARRANGE & ACT
      final theme = CarSkinTheme.getTheme('neon', true);

      // ASSERT
      expect(theme.borderColor, const Color(0xFF39FF14));
      expect(theme.borderWidth, 2.0);
    });

    test('TC07 — Estilo crimson tem cor de texto vermelha', () {
      // ARRANGE & ACT
      final theme = CarSkinTheme.getTheme('crimson', true);

      // ASSERT
      expect(theme.textColor, const Color(0xFFDC143C));
      expect(theme.bgColor, const Color(0xFF1A0505));
    });

    test('TC08 — Estilo "carmesim" é reconhecido como alias de crimson', () {
      // ARRANGE
      final themeCrimson = CarSkinTheme.getTheme('crimson', false);
      final themeCarmesim = CarSkinTheme.getTheme('carmesim', false);

      // ASSERT
      expect(themeCarmesim.bgColor, themeCrimson.bgColor);
      expect(themeCarmesim.textColor, themeCrimson.textColor);
    });

    test('TC09 — Estilo carbon tem fundo escuro e texto branco acinzentado', () {
      // ARRANGE & ACT
      final theme = CarSkinTheme.getTheme('carbon', true);

      // ASSERT
      expect(theme.textColor, Colors.white70);
      expect(theme.bgColor, const Color(0xFF121212));
      expect(theme.borderWidth, 2.0);
    });

    test('TC10 — Estilo desconhecido retorna o tema padrão', () {
      // ARRANGE & ACT
      final theme = CarSkinTheme.getTheme('estilo_inexistente', true);

      // ASSERT 
      expect(theme.textColor, Colors.white);
      expect(theme.bgColor, const Color(0xFF1A1A1A));
    });

    test('TC11 — Estilo ace-spades possui overlayTextures', () {
      // ARRANGE & ACT
      final theme = CarSkinTheme.getTheme('ace-spades', true);

      // ASSERT
      expect(theme.overlayTextures, isNotEmpty);
      expect(theme.textColor, Colors.white);
      expect(theme.bgColor, Colors.black);
    });

    test('TC12 — Estilo nature tem borda verde e fundo claro', () {
      // ARRANGE & ACT
      final theme = CarSkinTheme.getTheme('nature', false);

      // ASSERT
      expect(theme.borderColor, const Color(0xFF66BB6A));
      expect(theme.bgColor, const Color(0xFFE8F5E9));
      expect(theme.borderWidth, 4.0);
    });

    test('TC13 — getTheme é case-insensitive', () {
      // ARRANGE
      final themeMinusculo = CarSkinTheme.getTheme('gold', false);
      final themeMaiusculo = CarSkinTheme.getTheme('GOLD', false);

      // ASSERT
      expect(themeMaiusculo.bgColor, themeMinusculo.bgColor);
    });

    test('TC14 — Estilo vintage tem borderWidth maior que o padrão', () {
      // ARRANGE
      final themeVintage = CarSkinTheme.getTheme('vintage', true);
      final themeDefault = CarSkinTheme.getTheme('default', true);

      // ASSERT
      expect(themeVintage.borderWidth, greaterThan(themeDefault.borderWidth));
    });
  });
}
