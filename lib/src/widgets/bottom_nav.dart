import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class BottomNav extends StatelessWidget {
  final bool isProfile;

  const BottomNav({
    super.key,
    required this.isProfile,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 460),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
                decoration: BoxDecoration(
                  color: isDark 
                      ? const Color(0xFF1E1E1E) 
                      : Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: isDark 
                        ? Colors.white.withOpacity(0.2)  
                        : Colors.black.withOpacity(0.2), 
                    width: 1.0, 
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25,
                      spreadRadius: -5,
                      color: isDark ? Colors.black54 : Colors.black12,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => themeProvider.toggle(),
                      icon: Icon(
                        isDark ? Icons.wb_sunny : Icons.nightlight_round,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Container(
                      width: 1, 
                      height: 24, 
                      color: isDark 
                          ? Colors.white.withOpacity(0.1) 
                          : Colors.black.withOpacity(0.1),
                    ),
                    IconButton(
                      onPressed: () {
                        if (isProfile) {
                          // se estamos no perfil, voltamos para a home
                          Navigator.of(context).pop();
                        } else {
                          // se estamos na home, voltamos pro perfil
                          Navigator.pushNamed(context, '/profile');
                        }
                      },
                      icon: Icon(
                        isProfile ? Icons.grid_view : Icons.person,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}