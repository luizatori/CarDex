import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// PROVIDER DOS TEMAS CLARO E ESCURO, RESPONSAVEL POR GERENCIAR A ESCOLHA DO TEMA DO USUARIO E A SALVAR
class ThemeProvider extends ChangeNotifier {

  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeProvider() {
    _loadTheme();
  }

// metodo para carregar o tema salvo nas preferencias do usuario, caso haja um tema salvo, ativa ele, caso contrario, ativa o tema claro (padrao)
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme');

    if (savedTheme == 'dark') {
      _isDark = true;
    } else {
      _isDark = false;
    }

    notifyListeners();
  }

// metodo para alternar entre os temas claro e escuro, salva a escolha do usuario nas preferencias para manter a escolha mesmo apos fechar o app
  Future<void> toggle() async {
    _isDark = !_isDark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', _isDark ? 'dark' : 'light');

    notifyListeners();
  }
}