import 'package:flutter/material.dart';
import 'dart:math' as math;

class VaporwaveBackground extends StatefulWidget {
  final Widget child;
  const VaporwaveBackground({super.key, required this.child});

  @override
  State<VaporwaveBackground> createState() => _VaporwaveBackgroundState();
}

class _VaporwaveBackgroundState extends State<VaporwaveBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF5F4F0);
    
    final gridColor = isDark 
        ? Colors.white.withOpacity(0.16) 
        : Colors.black.withOpacity(0.25);

    return Stack(
      children: [
        // 1. COR DE FUNDO SÓLIDA
        Positioned.fill(child: Container(color: bgColor)),

        // 2. GRID DO TETO
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.48,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: PerspectiveGridPainter(
                progress: _controller.value,
                color: gridColor.withOpacity(isDark ? 0.04 : 0.08),
                isFloor: false,
              ),
            ),
          ),
        ),

        // 3. GRID DO CHÃO (COM GLOW SUTIL)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.48,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: PerspectiveGridPainter(
                progress: _controller.value,
                color: gridColor,
                isFloor: true,
              ),
            ),
          ),
        ),

        // 4. FADE DO HORIZONTE
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    bgColor,
                    bgColor.withOpacity(0), 
                    bgColor,                
                    bgColor.withOpacity(0), 
                    bgColor,
                  ],
                  stops: const [0.0, 0.42, 0.5, 0.58, 1.0],
                ),
              ),
            ),
          ),
        ),

        // 5. EFEITO CRT SCANLINES (As linhas de TV antiga)
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: CRTScanlinePainter(
                color: isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.03)
              ),
            ),
          ),
        ),

        // 6. VINHETA CRT (
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    isDark ? Colors.black.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
        ),

        // 7. O CONTEÚDO (Logo, cards, etc)
        widget.child,
      ],
    );
  }
}

// --- PAINTER PARA AS SCANLINES (EFEITO CRT) ---
class CRTScanlinePainter extends CustomPainter {
  final Color color;
  CRTScanlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    // Desenha uma linha a cada 4 pixels
    for (double i = 0; i < size.height; i += 4) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PerspectiveGridPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isFloor;

  PerspectiveGridPainter({
    required this.progress,
    required this.color,
    required this.isFloor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.8;

    final double centerX = size.width / 2;
    final double horizonY = isFloor ? 0 : size.height;
    final double nearY = isFloor ? size.height : 0;

    // 1. VERTICAIS
    for (int i = -25; i <= 25; i++) {
      double xOffsetBase = i * 40.0; 
      double xHorizon = centerX + (xOffsetBase * 0.4); 
      double xNear = centerX + (xOffsetBase * 12.0);

      canvas.drawLine(Offset(xHorizon, horizonY), Offset(xNear, nearY), paint);
    }

    // 2. HORIZONTAIS
    final int horizontalLines = 15;
    for (int i = 0; i <= horizontalLines; i++) {
      double movingProgress = (i + progress) / horizontalLines;
      double yPos;
      if (isFloor) {
        yPos = math.pow(movingProgress, 2.8) * size.height;
      } else {
        yPos = size.height - (math.pow(movingProgress, 2.8) * size.height);
      }

      final fadePaint = Paint()
        ..color = color.withOpacity(color.opacity * math.max(0, movingProgress))
        ..strokeWidth = 0.8;

      canvas.drawLine(Offset(-size.width * 3, yPos), Offset(size.width * 4, yPos), fadePaint);
    }
  }

  @override
  bool shouldRepaint(covariant PerspectiveGridPainter oldDelegate) => true;
}

class MathUtils {
  static double pow(num base, num exponent) {
    return math.pow(base, exponent).toDouble();
  }
}