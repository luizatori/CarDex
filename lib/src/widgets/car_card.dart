import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/car_styles.dart';

// WIDGET DE EXIBICAO DE CADA CARRO NA LISTA, RESPONSAVEL POR MOSTRAR A IMAGEM, NOME E APLICAR O ESTILO VISUAL DEFINIDO PELO TEMA DO CARRO
class CarCard extends StatelessWidget {
  final String id;
  final String? imageUrl;
  final bool isEmpty;
  final String? name;
  final String style;
  final VoidCallback? onTap;

  const CarCard({
    super.key,
    required this.id,
    this.imageUrl,
    this.isEmpty = false,
    this.name,
    this.style = "default",
    this.onTap,
  });

  static const int maxNameLength = 18;

  String get displayName {
    if (name == null || name!.isEmpty) return "";
    if (name!.length > maxNameLength) {
      return "${name!.substring(0, maxNameLength - 1)}…";
    }
    return name!;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // herda o tema visual do carro de acordo com o estilo definido
    final carTheme = CarSkinTheme.getTheme(style, isDark);

// se o card estiver vazio, exibe um card de adicao, caso contrario, exibe o card com a imagem e nome do carro aplicando o tema visual definido
    if (isEmpty) {
      return GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 0.70,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(Icons.add, size: 28, color: isDark ? Colors.white12 : Colors.black12),
            ),
          ),
        ),
      );
    }

// se o card nao estiver vazio, exibe o card com a imagem e nome do carro aplicando o tema visual definido
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 0.82,
        child: Hero(
          tag: 'car_hero_$id',
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: carTheme.decoration, 
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: _buildImage(),
                      ),
                    ),
                  ),
                  if (displayName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 2),
                      child: Text(
                        displayName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 9,
                          letterSpacing: 1,
                          fontWeight: style == "ace-spades" ? FontWeight.bold : FontWeight.normal,
                          color: carTheme.textColor,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// METODO: REFACTOR - SEPARAR O BUILD DA IMAGEM EM UM METODO APARTADO PARA MELHORAR A LEITURA DO CODIGO
  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(color: Colors.grey[800]);
    }

    final imageWidget = imageUrl!.startsWith("http")
        ? Image.network(imageUrl!, fit: BoxFit.cover)
        : Image.memory(
            base64Decode(imageUrl!),
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[900],
              child: const Icon(Icons.broken_image, color: Colors.white10),
            ),
          );

    return imageWidget;
  }
}