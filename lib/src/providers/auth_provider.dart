import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // funcao de cadastro atualizada para salvar no firestore
  Future<String?> signUp(String email, String password, String username) async {
    _isLoading = true;
    notifyListeners();
    try {

      // cria a conta no firebase auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // se a conta foi criada, cria o documento do usuario no firestore
      if (credential.user != null) {
        await _db.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': email,
          'username': username,
          'points': 0, // inicia o sistema gamificado
          'capturedCars': [], // dex vazia no inicio
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      _isLoading = false;
      notifyListeners();
      return null; // sucesso
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
      return _handleAuthError(e);
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
      default: return 'Erro: ${e.message}';
    }
  }
}