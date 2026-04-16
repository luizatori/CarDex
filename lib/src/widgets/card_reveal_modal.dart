import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; 
import 'package:image_picker/image_picker.dart';
import '../providers/cars_provider.dart';

// MODAL DE REVELACAO DO CARD, COM TODAS AS OPCOES DE CUSTOMIZACAO E ACAO DE SALVAR O NOVO CARRO
class MolduraConfig {
  final String id;
  final String nome;
  final int req;
  final Color cor;
  MolduraConfig({required this.id, required this.nome, required this.req, required this.cor});
}

class CardRevealModal extends StatefulWidget {
  final String slotId; 
  final bool isOpen;
  final VoidCallback onClose;
  final String? imageUrl;
  final bool isNewCard;
  final int totalCarrosColecao;

  const CardRevealModal({
    super.key,
    required this.slotId,
    required this.isOpen,
    required this.onClose,
    required this.totalCarrosColecao,
    this.imageUrl,
    this.isNewCard = false,
  });

  @override
  State<CardRevealModal> createState() => _CardRevealModalState();
}

class _CardRevealModalState extends State<CardRevealModal> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  String? _tempImagePath; 

  final List<MolduraConfig> molduras = [
    MolduraConfig(id: 'padrao', nome: 'Padrão', req: 0, cor: Colors.grey),
    MolduraConfig(id: 'vintage', nome: 'Vintage', req: 5, cor: const Color(0xFFD2B48C)),
    MolduraConfig(id: 'ouro', nome: 'Ouro', req: 10, cor: const Color(0xFFFFD700)),
    MolduraConfig(id: 'prata', nome: 'Prata', req: 15, cor: const Color(0xFFC0C0C0)),
    MolduraConfig(id: 'holo', nome: 'Holo', req: 25, cor: const Color(0xFFB19CD9)),
    MolduraConfig(id: 'carmesim', nome: 'Carmesim', req: 30, cor: const Color(0xFFDC143C)),
    MolduraConfig(id: 'rosa-pastel', nome: 'Rosa Pastel', req: 35, cor: const Color(0xFFFFD1DC)),
    MolduraConfig(id: 'carbono', nome: 'Carbono', req: 50, cor: const Color(0xFF2F2F2F)),
    MolduraConfig(id: 'natureza', nome: 'Natureza', req: 60, cor: const Color(0xFF90EE90)),
    MolduraConfig(id: 'neon', nome: 'Neon', req: 100, cor: const Color(0xFF00FFFF)),
    MolduraConfig(id: 'as-espadas', nome: 'Ás', req: 150, cor: const Color(0xFF1A1A1A)),
  ];

  late MolduraConfig selectedSkin;


  @override
  void initState() {
    super.initState();
    selectedSkin = molduras.first;
    _tempImagePath = widget.imageUrl;
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> _handleImageCapture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 85, 
    );

    if (photo != null && mounted) {
      setState(() {
        _tempImagePath = photo.path;
      });
    }
  }

// Exibe um modal de erro caso o usuario tente salvar sem uma foto

  void _showErrorModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Dialog(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4B4B).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_outlined, size: 32, color: Color(0xFFFF4B4B)),
                ),
                const SizedBox(height: 24),
                Text(
                  "VOCÊ NÃO PODE SALVAR SEM UMA FOTO!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                    ),
                    child: Text("ENTENDI", style: GoogleFonts.ibmPlexMono(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// exibe um modal caso a imagem selecionada nao seja de um carro, usando o ML Kit para validar a imagem antes de salvar
  void _showNoVehicleModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Dialog(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_car, size: 32, color: Colors.red),
                ),
                const SizedBox(height: 24),
                Text(
                  "VEÍCULO NÃO DETECTADO!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "A imagem selecionada não parece ser um carro ou veículo terrestre.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11, 
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                    ),
                    child: Text("TENTAR OUTRA", style: GoogleFonts.ibmPlexMono(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// FUNCAO DE SALVAR O CARRO, COM VALIDACAO DE IMAGEM E PROCESSAMENTO PARA BLUR DE PLACA E REDIMENSIONAMENTO
  void _saveAndCreate() async {
    debugPrint("carro sendo salvo");
    if (_tempImagePath == null) {
      _showErrorModal(context); 
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    try {
      final carsProvider = Provider.of<CarsProvider>(context, listen: false);
      await carsProvider.addCarFromGallery(
        name: nameController.text.trim().isEmpty ? "Novo Spot" : nameController.text.trim(),
        description: descController.text.trim(),
        style: selectedSkin.id,
        imageFile: File(_tempImagePath!), 
      );

      if (mounted) Navigator.of(context).pop(); 
      widget.onClose(); 
    } catch (e) {
      if (mounted) Navigator.of(context).pop(); 
      
      if (e.toString().contains("Nenhum veículo detectado")) {
        if (mounted) _showNoVehicleModal(context);
      } else {
        debugPrint("Erro ao salvar: $e");
      }
    }
  }

// modal de bloqueio para molduras, exibindo os requisitos para desbloqueio
  void _showLockPopup(MolduraConfig moldura) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierColor: isDark ? Colors.black87 : Colors.black.withOpacity(0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ),
              const Icon(Icons.lock_outline, size: 40, color: Colors.grey),
              const SizedBox(height: 16),
              Text(moldura.nome.toUpperCase(), style: GoogleFonts.ibmPlexMono(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                "Tenha ${moldura.req} carros na coleção para desbloquear.", 
                textAlign: TextAlign.center, 
                style: GoogleFonts.ibmPlexMono(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // BUILD DO MODAL, COM ESTRUTURA DE HEADER, FOTO, CAMPOS DE TEXTO, SELECAO DE MOLDURA E BOTAO DE CRIAR
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Stack(
        children: [
          GestureDetector(
            onTap: widget.onClose,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {}, 
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF111111) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Center(child: _buildFloatingCard(isDark)), 
                            const SizedBox(height: 40),
                            GestureDetector(
                              onTap: _handleImageCapture,
                              child: _buildActionButton(Icons.camera_alt_outlined, "ADICIONAR FOTO", isDark),
                            ),
                            const SizedBox(height: 20),
                            _buildLabel("NOME"),
                            _buildTextField(nameController, "Ex: Fusca 68", 24),
                            const SizedBox(height: 20),
                            _buildLabel("DESCRIÇÃO"),
                            _buildTextField(descController, "Detalhes sobre o carro...", 120, maxLines: 3),
                            const SizedBox(height: 20),
                            _buildLabel("MOLDURA"),
                            _buildSmallVerticalSkinGrid(isDark), 
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildCreateButton(isDark),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCard(bool isDark) { 
    return Container(
      width: 110, height: 140,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white, 
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: isDark ? Colors.black54 : Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: isDark ? Colors.black26 : Colors.grey[100], borderRadius: BorderRadius.circular(4)),
              child: _tempImagePath != null 
                ? Image.file(File(_tempImagePath!), fit: BoxFit.cover, width: double.infinity)
                : Center(child: Icon(Icons.add, color: isDark ? Colors.white24 : Colors.black12, size: 25)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              nameController.text.isEmpty ? "SEU CARRO" : nameController.text.toUpperCase(), 
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ibmPlexMono(fontSize: 7, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSmallVerticalSkinGrid(bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 10, childAspectRatio: 1.90, 
      ),
      itemCount: molduras.length,
      itemBuilder: (context, index) {
        final m = molduras[index];
        final bool isLocked = widget.totalCarrosColecao < m.req;
        final bool isSelected = selectedSkin.id == m.id;
        return GestureDetector(
          onTap: isLocked ? () => _showLockPopup(m) : () => setState(() => selectedSkin = m),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? m.cor.withOpacity(0.05) : (isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.02)),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: isSelected ? m.cor : (isDark ? Colors.white10 : Colors.black12), width: 1.2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 10, backgroundColor: m.cor),
                    const SizedBox(height: 3,),
                    Text(m.nome, style: GoogleFonts.ibmPlexMono(fontSize: 10, fontWeight: FontWeight.bold, color: isLocked ? Colors.grey : (isDark ? Colors.white : Colors.black))),
                  ],
                ),
                if (isLocked) const Positioned(top: 4, right: 4, child: Icon(Icons.lock, size: 8, color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }

//
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Icon(Icons.edit_outlined, size: 16),
            const SizedBox(width: 8),
            Text("NOVO CARD", style: GoogleFonts.ibmPlexMono(fontWeight: FontWeight.bold, fontSize: 13)),
          ]),
          IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close, size: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: GoogleFonts.ibmPlexMono(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField(TextEditingController controller, String hint, int max, {int maxLines = 1}) => TextField(
    controller: controller, maxLength: max, maxLines: maxLines,
    onChanged: (_) => setState(() {}),
    style: GoogleFonts.ibmPlexMono(fontSize: 12),
    decoration: InputDecoration(
      filled: true, fillColor: Colors.black.withOpacity(0.04),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      hintText: hint, hintStyle: GoogleFonts.ibmPlexMono(fontSize: 12, color: Colors.black26),
    ),
  );

  Widget _buildActionButton(IconData icon, String label, bool isDark) => Container(
    width: double.infinity, height: 45,
    decoration: BoxDecoration(border: Border.all(color: isDark ? Colors.white10 : Colors.black12), borderRadius: BorderRadius.circular(8)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon, size: 16), const SizedBox(width: 8), Text(label, style: GoogleFonts.ibmPlexMono(fontSize: 11, fontWeight: FontWeight.bold))],
    ),
  );

  Widget _buildCreateButton(bool isDark) => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: () {
        debugPrint("botao pressionado com sucesso");
        _saveAndCreate();
      }, 
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.white : Colors.black,
        foregroundColor: isDark ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Text("CRIAR CARD", style: GoogleFonts.ibmPlexMono(fontWeight: FontWeight.bold, letterSpacing: 1,)),
    ),
  );
}