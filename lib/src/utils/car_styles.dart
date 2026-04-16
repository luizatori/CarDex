import 'package:flutter/material.dart';

// CLASSE RESPONSAVEL POR DEFINIR OS ESTILOS VISUAIS DOS CARROS, PERMITINDO APLICAR DIFERENTES TEMAS DE ACORDO COM O ESTILO SELECIONADO PELO USUARIO
class CarSkinTheme {
  final BoxDecoration decoration;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;
  final double borderWidth;
  final List<Widget> overlayTextures; 

  CarSkinTheme({
    required this.decoration,
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
    this.borderWidth = 1.0,
    this.overlayTextures = const [], 
  });
  static CarSkinTheme getTheme(String style, bool isDark) {
    final normalizedStyle = style.toLowerCase().trim();

    switch (normalizedStyle) {

      // VINTAGE
      case "vintage":
        return CarSkinTheme(
          textColor: const Color.fromARGB(255, 255, 255, 255),
          bgColor: const Color.fromARGB(255, 37, 20, 4),
          
          borderColor: const Color.fromARGB(255, 32, 16, 2),
          borderWidth: 8.0, 
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 58, 43, 25), 
             gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(255, 53, 27, 4).withOpacity(0.4),
                      const Color.fromARGB(255, 133, 75, 22).withOpacity(0.1),
                      const Color.fromARGB(255, 31, 17, 1).withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.repeated,
            ),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Color.fromARGB(255, 32, 22, 6), width: 6),
            boxShadow: const [
              BoxShadow(color: Color.fromARGB(255, 27, 13, 0), blurRadius: 10, offset: Offset(0, 0))
            ],
          ),
        );

      // OURO 
      case "gold":
      case "ouro":
        return CarSkinTheme(
          textColor: const Color(0xFF5C4033),
          bgColor: const Color(0xFFD4AF37),
          borderColor: const Color(0xFFB8860B),
          borderWidth: 3.0,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFB8860B), Color(0xFFFFD700), Color(0xFFFFECB3), Color(0xFFD4AF37)],
              stops: [0.0, 0.4, 0.6, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFB8860B), width: 0),
            boxShadow: [
              BoxShadow(color: Colors.amber.withOpacity(0.6), blurRadius: 4, spreadRadius: 2),
            ],
          ),
        );

      // PRATA 
      case "silver":
      case "prata":
        return CarSkinTheme(
          textColor: const Color(0xFF454545),
          bgColor: const Color(0xFFC0C0C0),
          borderColor: Colors.white70,
          borderWidth: 2.0,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF808080), Color(0xFFE8E8E8), Color(0xFFC0C0C0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white70, width: 0),
            boxShadow: [
              BoxShadow(color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.6), blurRadius: 5, spreadRadius: 2),
            ],
          ),
        );

      // HOLOGRAFICO 
      case "holographic":
      case "holo":
        return CarSkinTheme(
          textColor: const Color.fromARGB(255, 255, 255, 255)!,
          bgColor: Colors.white,
          borderColor: const Color.fromARGB(255, 42, 91, 131),
          borderWidth: 2.0,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: SweepGradient(
              colors: [const Color.fromARGB(255, 93, 123, 175).withOpacity(0.2), const Color.fromARGB(255, 36, 84, 156).withOpacity(0.2), const Color.fromARGB(255, 4, 40, 73).withOpacity(0.2), const Color.fromARGB(255, 2, 31, 63).withOpacity(0.2), const Color.fromARGB(255, 1, 29, 78).withOpacity(0.2)],
              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color.fromARGB(255, 64, 144, 197).withOpacity(0.5), width: 0),
            boxShadow: [BoxShadow(color: const Color.fromARGB(255, 39, 126, 176).withOpacity(0.3), blurRadius: 25)],
          ),
        );

      // NEON
      case "neon":
        return CarSkinTheme(
          textColor: const Color.fromARGB(255, 0, 0, 0), 
          bgColor: Colors.black,
          borderColor: const Color(0xFF39FF14),
          borderWidth: 2.0,
          decoration: BoxDecoration(
            color: const Color(0xFF39FF14).withOpacity(0.8),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF39FF14), width: 2),
            boxShadow: [
              // Triplo BoxShadow para criar o efeito de luz difusa real
              BoxShadow(color: const Color(0xFF39FF14).withOpacity(0.8), blurRadius: 5),
              BoxShadow(color: const Color(0xFF39FF14).withOpacity(0.5), blurRadius: 15),
              BoxShadow(color: const Color(0xFF39FF14).withOpacity(0.3), blurRadius: 30, spreadRadius: 2),
            ],
          ),
        );

      // CARMESIM 
      case "crimson":
      case "carmesim":
        return CarSkinTheme(
          textColor: const Color(0xFFDC143C),
          bgColor: const Color(0xFF1A0505), 
          borderColor: const Color(0xFFDC143C),
          borderWidth: 4.0,
          decoration: BoxDecoration(
            color: const Color(0xFF1A0505),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFDC143C), width: 0.5),
            boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(2, 2))],
          ),
        );

      // ROSA PASTEL
      case "rosa-pastel":
        return CarSkinTheme(
          textColor: const Color(0xFFD0849B),
          bgColor: const Color(0xFFFFF0F5),
          borderColor: const Color(0xFFFFD1DC),
          borderWidth: 3.0,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F5),
            borderRadius: BorderRadius.circular(10), 
            border: Border.all(color: const Color(0xFFFFD1DC), width: 3),
            boxShadow: [BoxShadow(color: const Color(0xFFFFD1DC).withOpacity(0.4), blurRadius: 10)],
          ),
        );


      // CARBONO 
      case "carbon":
      case "carbono":
        return CarSkinTheme(
          textColor: Colors.white70,
          bgColor: const Color(0xFF121212),
          borderColor: const Color(0xFF2F2F2F),
          borderWidth: 2.0,
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            gradient: const RadialGradient(
              colors: [Color(0xFF2F2F2F), Color(0xFF121212)],
              radius: 0.8,
            ),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF2F2F2F), width: 2),
            boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 10)],
          ),
        );

      // NATUREZA 
      case "natureza":
      case "nature":
        return CarSkinTheme(
          textColor: const Color(0xFF1B5E20),
          bgColor: const Color(0xFFE8F5E9),
          borderColor: const Color(0xFF66BB6A),
          borderWidth: 4.0,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            gradient: const LinearGradient(
              colors: [Color(0xFFC8E6C9), Color(0xFFE8F5E9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10), 
            border: Border.all(color: const Color(0xFF66BB6A), width: 4),
          ),
        );

      // ÁS DE ESPADAS 
     case "ace-spades":
      case "as-espadas":
        return CarSkinTheme(
          textColor: Colors.white,
          bgColor: Colors.black,
          borderColor: const Color(0xFFE0E0E0),
          borderWidth: 2.0,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12), 
            border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.white10, blurRadius: 20, spreadRadius: 2)
            ],
          ),
          overlayTextures: [
            Positioned.fill(
              child: CustomPaint(
                painter: CardSpadesPainter(),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      // PADRAO
      default:
        return CarSkinTheme(
          textColor: isDark ? Colors.white : Colors.black,
          bgColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderColor: isDark ? Colors.white10 : Colors.black12,
          borderWidth: 1.0,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                offset: const Offset(2, 3),
                color: isDark ? Colors.black54 : Colors.black.withOpacity(0.08),
              )
            ],
          ),
        );
    }
  }
}



class CardSpadesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double margin = 10.0;

    // função auxiliar para desenhar o "A" e o naipe ♠
    void drawAce(double x, double y) {
      textPainter.text = TextSpan(
        text: 'A\n♠',
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.08,
          fontWeight: FontWeight.bold,
          height: 0.9,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }

    drawAce(margin, margin);

    canvas.save();
    canvas.translate(size.width, size.height);
    canvas.rotate(3.14159); 
    drawAce(margin, margin);
    canvas.restore();

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(5, 5, size.width - 10, size.height - 10),
        const Radius.circular(8),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}