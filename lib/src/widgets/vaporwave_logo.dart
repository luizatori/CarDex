import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

// WIDGET DA LOGO VAPORWAVE, RESPONSAVEL POR EXIBIR A LOGO DO APP COM UM EFEITO DE PULSACAO E UM SWEEP DE LUZ NEON
class VaporwaveLogo extends StatefulWidget {
  final double size;

  const VaporwaveLogo({
    super.key,
    this.size = 280, 
  });

  @override
  State<VaporwaveLogo> createState() => _VaporwaveLogoState();
}

class _VaporwaveLogoState extends State<VaporwaveLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _sweepAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _sweepAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;
    
    final logoPath = isDark ? 'assets/logo-dark.png' : 'assets/logo.png';

    return Center( 
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. GLOW PULSANTE 
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: widget.size * 0.85,
                height: widget.size * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? Colors.white : Colors.black).withOpacity(isDark ? 0.08 : 0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // A LOGO 
            Image.asset(
              logoPath,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
            ),

            // EFEITO CRT SCANLINE (O MESMO DA SPLASH)
            IgnorePointer(
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, 
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: const Alignment(0, -0.98), 
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(isDark ? 0.25 : 0.1), 
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.repeated,
                  ),
                ),
              ),
            ),

            // CRT GLASS OVERLAY 
            IgnorePointer(
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(-0.3, -0.3),
                    radius: 1.2, 
                    colors: [
                      Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                      Colors.transparent,
                      isDark ? Colors.black.withOpacity(0.15) : Colors.transparent, 
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            // NEON SWEEP LINE 
            AnimatedBuilder(
              animation: _sweepAnimation,
              builder: (context, child) {
                return ClipOval(
                  child: SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: Stack(
                      children: [
                        Positioned(
                          top: _sweepAnimation.value * widget.size,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2.0, 
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: isDark ? Colors.white24 : Colors.black12,
                                  blurRadius: 8,
                                ),
                              ],
                              color: isDark 
                                  ? Colors.white.withOpacity(0.3) 
                                  : Colors.black.withOpacity(0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}