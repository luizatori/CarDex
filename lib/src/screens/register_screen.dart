import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/vaporwave_background.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final String customFont = 'IBM Plex Mono';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userController = TextEditingController();

  String _generatedCode = "";

  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(Iterable.generate(
        7, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
  }

  Future<void> _sendEmail(String email, String code) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': 'service_vtmpebg',
          'template_id': 'template_e4cxq8s',
          'user_id': 'ftn1tjEd5m9e9FKDb',
          'template_params': {
            'destinatario': email.trim(),
            'codigo_acesso': code.trim(),
          },
        }),
      );

      if (response.statusCode == 200) {
        print("DEBUG: E-mail enviado com sucesso via REST!");
      } else {
        print("ERRO NA API (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      print("ERRO DE CONEXÃO: $e");
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _showVerificationModal(String email, String password, String username) {
    final TextEditingController codeController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          final auth = context.read<AuthProvider>();

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              "VERIFICAÇÃO",
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(customFont,
                  fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "DIGITE O CÓDIGO DE 7 DÍGITOS ENVIADO PARA:\n$email",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(customFont,
                      fontSize: 10, color: textColor.withOpacity(0.6)),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: codeController,
                  maxLength: 7,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: GoogleFonts.getFont(customFont,
                      fontSize: 22,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color.fromARGB(255, 255, 255, 255) : Colors.black87),
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "XXXXXXX",
                    hintStyle: TextStyle(color: textColor.withOpacity(0.2)),
                    filled: true,
                    fillColor: textColor.withOpacity(0.05),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            if (codeController.text.toUpperCase() == _generatedCode) {
                              final error = await auth.signUp(email, password, username);

                              if (error != null) {
                                Navigator.pop(context);
                                _showSnackBar(error.toUpperCase(), Colors.redAccent);
                              } else {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                _showSnackBar("CONTA CRIADA COM SUCESSO!", Colors.greenAccent);
                              }
                            } else {
                              _showSnackBar("CÓDIGO INCORRETO!", Colors.redAccent);
                            }
                          },
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.cyanAccent, strokeWidth: 2))
                        : Text("CADASTRAR",
                            style: GoogleFonts.getFont(customFont,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _handleRegister() async {
    final username = _userController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar("POR FAVOR, PREENCHA TODOS OS CAMPOS.", Colors.redAccent);
      return;
    }

    _generatedCode = _generateRandomCode();
    
    if (mounted) {
      _showVerificationModal(email, password, username);
    }

    _sendEmail(email, _generatedCode);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final authLoading = context.watch<AuthProvider>().isLoading;

    return VaporwaveBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 130),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1A1A1A).withOpacity(0.9)
                          : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: textColor.withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "CADASTRO",
                          style: GoogleFonts.getFont(customFont,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                        ),
                        const SizedBox(height: 24),
                        _buildTextField("NOME DE USUÁRIO", Icons.person_outline,
                            isDark,
                            controller: _userController),
                        const SizedBox(height: 16),
                        _buildTextField("EMAIL", Icons.email_outlined, isDark,
                            controller: _emailController),
                        const SizedBox(height: 16),
                        _buildTextField("SENHA", Icons.lock_outline, isDark,
                            isPassword: true, controller: _passwordController),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.white : Colors.black,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: authLoading ? null : _handleRegister,
                            child: authLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.cyanAccent,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text("CRIAR CONTA",
                                    style: GoogleFonts.getFont(customFont,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            "JÁ POSSUI UMA CONTA? ENTRE AQUI",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(customFont,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, bool isDark,
      {bool isPassword = false, TextEditingController? controller}) {
    final textColor = isDark ? Colors.white : Colors.black;
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.getFont(customFont, fontSize: 13, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.getFont(customFont,
            fontSize: 9, color: textColor.withOpacity(0.5)),
        prefixIcon: Icon(icon, size: 18, color: textColor.withOpacity(0.5)),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }
}