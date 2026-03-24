import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CarCard extends StatelessWidget {
  final String? imageUrl;
  final bool isEmpty;
  final String? name;
  final VoidCallback? onTap;

  const CarCard({
    super.key,
    this.imageUrl,
    this.isEmpty = false,
    this.name,
    this.onTap,
  });

  static const int maxNameLength = 18;

  String get displayName {
    if (name == null) return "";
    if (name!.length > maxNameLength) {
      return "${name!.substring(0, maxNameLength - 1)}…";
    }
    return name!;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ESTADO VAZIO
    if (isEmpty) {
      return GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 0.70,
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.black.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.04),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                size: 28,
                color: isDark
                    ? Colors.white.withOpacity(0.12)
                    : Colors.black.withOpacity(0.12),
              ),
            ),
          ),
        ),
      );
    }

    // ESTADO POPULADO
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 0.82,
        child: Hero(
        
          tag: 'car_hero_${imageUrl ?? name}', 
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
                      child: imageUrl != null
                          ? _buildImage()
                          : Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFE0E0E0),
                                    Color(0xFFF5F5F5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                    ),
                  ),
if (displayName.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      displayName.toUpperCase(),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.ibmPlexMono( 
        fontSize: 9,
        letterSpacing: 1,
        fontWeight: FontWeight.normal,
        color: isDark 
            ? const Color(0xFFFFFFFF) 
            : const Color(0xFF000000), 
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
    if (imageUrl!.startsWith("http")) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      return Image.file(
        File(imageUrl!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }
}