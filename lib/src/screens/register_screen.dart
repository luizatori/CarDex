import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/vaporwave_background.dart';

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

  Future<void> _handleRegister() async {
    final username = _userController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // validacao de campos vazios 
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("POR FAVOR, PREENCHA TODOS OS CAMPOS."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    
    final error = await auth.signUp(
      email,
      password,
      username,
    );

    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toUpperCase()), 
          backgroundColor: Colors.redAccent,
        ),
      );
    } else if (mounted) {
      // mensagem de sucesso e volta para a tela de login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("CONTA CRIADA COM SUCESSO! FAÇA LOGIN."),
          backgroundColor: Colors.greenAccent,
        ),
      );
      Navigator.pop(context); 
    }
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
                      color: isDark ? const Color(0xFF1A1A1A).withOpacity(0.9) : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: textColor.withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "CADASTRO",
                          style: GoogleFonts.getFont(customFont,
                              fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                        ),
                        const SizedBox(height: 24),
                        _buildTextField("NOME DE USUÁRIO", Icons.person_outline, isDark, controller: _userController),
                        const SizedBox(height: 16),
                        _buildTextField("EMAIL", Icons.email_outlined, isDark, controller: _emailController),
                        const SizedBox(height: 16),
                        _buildTextField("SENHA", Icons.lock_outline, isDark, isPassword: true, controller: _passwordController),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.white : Colors.black,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                              : Text("CRIAR CONTA", style: GoogleFonts.getFont(customFont, fontWeight: FontWeight.bold)),
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

  Widget _buildTextField(String label, IconData icon, bool isDark, {bool isPassword = false, TextEditingController? controller}) {
    final textColor = isDark ? Colors.white : Colors.black;
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.getFont(customFont, fontSize: 13, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.getFont(customFont, fontSize: 9, color: textColor.withOpacity(0.5)),
        prefixIcon: Icon(icon, size: 18, color: textColor.withOpacity(0.5)),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}