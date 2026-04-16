import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cars_provider.dart';
import '../utils/car_styles.dart';

// WIDGET DE PREVIEW EXPANDIDA DO CARRO, RESPONSAVEL POR EXIBIR DETALHES DO CARRO SELECIONADO, INCLUINDO IMAGEM EM MAIOR RESOLUCAO, NOME, DESCRICAO E APLICAR O ESTILO VISUAL DEFINIDO PELO TEMA DO CARRO
class CarExpandedView extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String name;
  final String description;
  final String heroTag;
  final String style;

  const CarExpandedView({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.heroTag,
    required this.style,
  });

  @override
  State<CarExpandedView> createState() => _CarExpandedViewState();
}

// ESTADO DO WIDGET DE PREVIEW EXPANDIDA, RESPONSAVEL POR GERENCIAR A LOGICA DE INTERACAO COM O USUARIO, INCLUINDO EFEITOS DE ROTACAO 3D AO TOCAR E EXIBICAO DE DETALHES EM UM MODAL
class _CarExpandedViewState extends State<CarExpandedView> {
  double rotateX = 0;
  double rotateY = 0;
  double lightX = 0;
  double lightY = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.black.withOpacity(0.85)),
            ),
          ),
          Center(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  rotateY += details.delta.dx / 150;
                  rotateX -= details.delta.dy / 150;
                  rotateX = rotateX.clamp(-0.4, 0.4);
                  rotateY = rotateY.clamp(-0.4, 0.4);
                  lightX = rotateY * 1.5;
                  lightY = rotateX * 1.5;
                });
              },
              onPanEnd: (_) => setState(() {
                rotateX = 0; rotateY = 0; lightX = 0; lightY = 0;
              }),
              onTap: () => _showInfoModal(context, isDark),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX(rotateX)
                      ..rotateY(rotateY),
                    alignment: FractionalOffset.center,
                    child: Hero(
                      tag: widget.heroTag,
                      child: _buildPhysicalPolaroid(isDark),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    "TOQUE PARA DETALHES",
                    style: GoogleFonts.ibmPlexMono(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// METODO DE CONSTRUCAO DO POLAROID FISICO, RESPONSAVEL POR EXIBIR A IMAGEM DO CARRO EM MAIOR RESOLUCAO COM UM EFEITO DE BRILHO DINAMICO BASEADO NA POSICAO DO TOQUE DO USUARIO, ALÉM DE EXIBIR O NOME DO CARRO APLICANDO O ESTILO VISUAL DEFINIDO PELO TEMA
  Widget _buildPhysicalPolaroid(bool isDark) {
    final carTheme = CarSkinTheme.getTheme(widget.style, isDark);

    return Container(
      width: MediaQuery.of(context).size.width * 0.76,
      height: MediaQuery.of(context).size.height * 0.52,
      padding: const EdgeInsets.all(12),
      decoration: carTheme.decoration, 
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: widget.imageUrl.isEmpty
                          ? Container(
                              color: Colors.black45,
                              child: const Icon(Icons.directions_car, color: Colors.white24),
                            )
                          : Image.memory(
                              base64Decode(widget.imageUrl),
                              key: ValueKey(widget.id),
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.black45,
                                child: const Icon(Icons.broken_image, color: Colors.redAccent),
                              ),
                            ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(lightX - 1, lightY - 1),
                            end: Alignment(lightX + 1, lightY + 1),
                            colors: [
                              Colors.white.withOpacity(
                                widget.style.contains('holografico') || widget.style.contains('holographic') ? 0.45 : 0.2
                              ),
                              Colors.transparent,
                              Colors.black.withOpacity(0.15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                widget.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 14,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  color: carTheme.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// METODO DE EXIBICAO DO MODAL DE DETALHES, RESPONSAVEL POR MOSTRAR A DESCRICAO DO CARRO E UMA OPCAO PARA REMOVER O CARRO DA COLECAO, APLICANDO O ESTILO VISUAL DEFINIDO PELO TEMA
  void _showInfoModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111111) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.name.toUpperCase(),
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context, isDark),
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              "DESCRIÇÃO",
              style: GoogleFonts.ibmPlexMono(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white38 : Colors.black38,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description.isEmpty
                  ? "NENHUMA DESCRIÇÃO FORNECIDA."
                  : widget.description.toUpperCase(),
              style: GoogleFonts.ibmPlexMono(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

// METODO DE CONFIRMACAO DE EXCLUSAO, RESPONSAVEL POR EXIBIR UM ALERTA DE CONFIRMACAO ANTES DE REMOVER O CARRO DA COLECAO, APLICANDO O ESTILO VISUAL DEFINIDO PELO TEMA
  void _confirmDelete(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        title: Text(
          "REMOVER DA COLEÇÃO?",
          style: GoogleFonts.ibmPlexMono(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("CANCELAR", style: GoogleFonts.ibmPlexMono(color: isDark ? Colors.white38 : Colors.black38)),
          ),
          TextButton(
            onPressed: () {
              context.read<CarsProvider>().deleteCar(widget.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text("REMOVER", style: GoogleFonts.ibmPlexMono(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}