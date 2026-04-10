import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:google_sign_in/google_sign_in.dart'; 

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); 
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // FUNCAO DE LOGIN COM GOOGLE COM RESTRICAO DE CADASTRO
  Future<String?> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return null; 
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // VERIFICACAO DE USUARIO EXISTENTE SEM USAR FETCH 
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        
        // se o usuario for novo, deletamos a conta criada e barramos o acesso

        await userCredential.user?.delete();
        await _googleSignIn.signOut();
        _isLoading = false;
        notifyListeners();
        return 'ESTE E-MAIL NÃO POSSUI CADASTRO. POR FAVOR, CADASTRE-SE PRIMEIRO.';
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
      return 'ERRO AO ENTRAR COM GOOGLE: $e';
    }
  }

  // FUNCAO DE CADASTRO
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

  // FUNCAO DE LOGIN COMA EMAIL E SENHA 
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

  // FUNCAO DE RESET DE SENHA COM EMAILJS E FIREBASE
  Future<String?> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.sendPasswordResetEmail(email: email);

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

  // LOGOUT 
  Future<void> signOut() async {
    await _googleSignIn.signOut(); 
    await _auth.signOut(); 
  }

  // tratamento de erros 
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'Usuário não encontrado.';
      case 'wrong-password': return 'Senha incorreta.';
      case 'email-already-in-use': return 'E-mail já cadastrado.';
      case 'invalid-email': return 'E-mail inválido.';
      case 'weak-password': return 'A senha deve ter pelo menos 6 caracteres.';
      case 'network-request-failed': return 'Erro de conexão com a rede.';
      case 'account-exists-with-different-credential': return 'Já existe uma conta com este e-mail usando outro método de login.';
      default: return 'Erro: ${e.message}';
    }
  }
}