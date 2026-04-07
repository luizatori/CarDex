import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/vaporwave_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String customFont = 'IBM Plex Mono';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // validacao de campos vazios 
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("POR FAVOR, PREENCHA TODOS OS CAMPOS."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final error = await auth.signIn(email, password);

    if (error != null && mounted) {
      // exibe possibilidades de erro de login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toUpperCase()),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else if (mounted) {
      // forca a ida para a home
      Navigator.pushReplacementNamed(context, '/home');
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 130),
                  const SizedBox(height: 40),
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
                          "LOGIN",
                          style: GoogleFonts.getFont(customFont,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                        ),
                        const SizedBox(height: 32),
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
                              backgroundColor:
                                  isDark ? Colors.white : Colors.black,
                              foregroundColor:
                                  isDark ? Colors.black : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: authLoading ? null : _handleLogin,
                            child: authLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.grey),
                                  )
                                : Text("ENTRAR",
                                    style: GoogleFonts.getFont(customFont,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                                child:
                                    Divider(color: textColor.withOpacity(0.1))),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text("OU",
                                  style: GoogleFonts.getFont(customFont,
                                      fontSize: 10,
                                      color: textColor.withOpacity(0.4))),
                            ),
                            Expanded(
                                child:
                                    Divider(color: textColor.withOpacity(0.1))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSocialButton(
                            "ENTRAR COM GOOGLE", Icons.g_mobiledata, isDark),
                        const SizedBox(height: 32),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: Text(
                            "NÃO POSSUI UMA CONTA? CADASTRE-SE",
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
            fontSize: 10, color: textColor.withOpacity(0.5)),
        prefixIcon: Icon(icon, size: 18, color: textColor.withOpacity(0.5)),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, bool isDark,
      {VoidCallback? onTap}) {
    final textColor = isDark ? Colors.white : Colors.black;
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: textColor.withOpacity(0.1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, color: textColor),
      label: Text(label,
          style: GoogleFonts.getFont(customFont,
              fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
      onPressed: onTap,
    );
  }
}