import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // funcao de cadastro
  Future<String?> signUp(String email, String password, String username) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      if (credential.user != null) {
        await _db.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': email,
          'username': username,
          'points': 0,
          'capturedCars': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return _handleAuthError(e);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Erro inesperado ao salvar dados.';
    }
  }

  // funcao de login
  Future<String?> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return null;
  } on FirebaseAuthException catch (e) {
  _isLoading = false;
  notifyListeners();
  
  if (e.code == 'user-not-found' || e.code == 'invalid-email') {
    return 'E-MAIL INVÁLIDO OU NÃO CADASTRADO.';
  }
  
  return _handleAuthError(e);
}
  }

  // funcao de recuperação de senha integrada com emailJS
  Future<String?> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      // firebase envia o link oficial
      await _auth.sendPasswordResetEmail(email: email);

// chamada para a API do emailJS 
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Origin': 'http://localhost', 
        },
        body: json.encode({
          'service_id': 'service_vtmpebg',
          'template_id': 'template_jwlfm0n',
          'user_id': 'ftn1tjEd5m9e9FKDb',
          'template_params': {
            'user_email': email,
            'project_name': 'DEX DE CARROS',
          },
        }),
      );

      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return _handleAuthError(e);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("ERRO CRÍTICO NO PROVIDER: $e"); 
      return 'ERRO AO PROCESSAR: $e';
    }
  }
  // logout 
  Future<void> signOut() async => await _auth.signOut();

  // tratamento de erros 
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'Usuário não encontrado.';
      case 'wrong-password': return 'Senha incorreta.';
      case 'email-already-in-use': return 'E-mail já cadastrado.';
      case 'invalid-email': return 'E-mail inválido.';
      case 'weak-password': return 'A senha deve ter pelo menos 6 caracteres.';
      case 'network-request-failed': return 'Erro de conexão com a rede.';
      default: return 'Erro: ${e.message}';
    }
  }
}