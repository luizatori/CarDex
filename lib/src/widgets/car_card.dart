import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// WIDGET DE EXIBICAO DE CADA CARTAO DE CARRO NA HOME, RESPONSAVEL POR EXIBIR A IMAGEM E O NOME DO CARRO, ALEM DE TRATAR O CLICK PARA ABRIR O DETALHES OU O MODAL DE ADICAO
class CarCard extends StatelessWidget {
  final String id; 
  final String? imageUrl;
  final bool isEmpty;
  final String? name;
  final VoidCallback? onTap;

// construtor de CarCard, recebe o id do carro, a URL da imagem, se o card esta vazio
  const CarCard({
    super.key,
    required this.id, 
    this.imageUrl,
    this.isEmpty = false,
    this.name,
    this.onTap,
  });

  static const int maxNameLength = 18;

// metodo para exibir o nome do carro, limitando o numero de caracteres
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

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 0.82,
        child: Hero(
          tag: 'car_hero_$id', 
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  offset: const Offset(2, 3),
                  color: isDark ? Colors.black54 : Colors.black.withOpacity(0.08),
                )
              ],
            ),
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
                          color: isDark ? Colors.white : Colors.black,
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

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(color: Colors.grey[800]);
    }

    // logica para carregar imagem 
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