import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io'; 
import 'dart:ui' as ui;
import '../widgets/vaporwave_background.dart';
import '../widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

enum WidgetType {
  totalCars,
  favorites,
  favoriteCar,
  level,
  memberSince,
  customText
}

class ProfileWidgetItem {
  String id;
  WidgetType type;
  bool visible;

  ProfileWidgetItem({
    required this.id,
    required this.type,
    required this.visible,
  });
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String customFont = 'IBM Plex Mono';
  String profileName = "Colecionador";
  String customText = "Bem-vindo ao meu perfil!";
  String? mainFavoriteCar;
  String? profileImagePath; 
  int totalCars = 0;

  List<String?> favoriteCars = [null, null, null];

  List<ProfileWidgetItem> widgets = [
    ProfileWidgetItem(id: "w1", type: WidgetType.totalCars, visible: true),
    ProfileWidgetItem(id: "w2", type: WidgetType.favorites, visible: true),
    ProfileWidgetItem(id: "w3", type: WidgetType.favoriteCar, visible: true),
    ProfileWidgetItem(id: "w4", type: WidgetType.level, visible: true),
    ProfileWidgetItem(id: "w5", type: WidgetType.memberSince, visible: true),
    ProfileWidgetItem(id: "w6", type: WidgetType.customText, visible: true),
  ];

  int get level => (totalCars ~/ 5) + 1;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // PERSISTENCIA 

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileName = prefs.getString("profileName") ?? "Colecionador";
      customText = prefs.getString("customText") ?? "Bem-vindo ao meu perfil!";
      mainFavoriteCar = prefs.getString("mainFavoriteCar");
      profileImagePath = prefs.getString("profileImage"); 

      List<String>? savedFavs = prefs.getStringList("favoriteCars");
      if (savedFavs != null) {
        favoriteCars = savedFavs.map((e) => e.isEmpty ? null : e).toList();
      }

      if (favoriteCars.length > 3) {
        favoriteCars = favoriteCars.sublist(0, 3);
      } else {
        while (favoriteCars.length < 3) {
          favoriteCars.add(null);
        }
      }
    });
  }

  Future<void> saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profileName", profileName);
    await prefs.setString("customText", customText);
    if (mainFavoriteCar != null) {
      await prefs.setString("mainFavoriteCar", mainFavoriteCar!);
    }
    if (profileImagePath != null) {
      await prefs.setString("profileImage", profileImagePath!);
    }
    await prefs.setStringList(
        "favoriteCars", favoriteCars.map((e) => e ?? "").toList());
  }

  // FUNCAO PARA PEGAR FOTO 

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImagePath = image.path;
      });
      saveProfileData();
    }
  }

  // MODAL DE BUSCA 

  void _openSearchModal({int? slotIndex, bool isMainFavorite = false}) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        isMainFavorite
                            ? "CARRO FAVORITO"
                            : "FAVORITOS ${(slotIndex ?? 0) + 1}/3",
                        style: GoogleFonts.getFont(customFont,
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                TextField(
                  style: GoogleFonts.getFont(customFont, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "BUSCAR POR NOME...",
                    prefixIcon: const Icon(Icons.search, size: 18),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.05),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 40),
                Opacity(
                  opacity: 0.4,
                  child: Text("NENHUM CARRO NA COLEÇÃO AINDA",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(customFont,
                          fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("SALVAR",
                        style: GoogleFonts.getFont(customFont,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // SLOTS DE FAVORITOS 

  Widget _buildFavoriteSlot(int index, bool isDark) {
    final hasCar =
        favoriteCars[index] != null && favoriteCars[index]!.isNotEmpty;
    final textColor = isDark ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => _openSearchModal(slotIndex: index),
      child: CustomPaint(
        painter: DashPainter(color: textColor.withOpacity(0.15)),
        child: Container(
          width: 90,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.03),
          ),
          child: hasCar
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car, color: textColor, size: 24),
                    const SizedBox(height: 6),
                    Text(favoriteCars[index]!.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(customFont,
                            fontSize: 8, color: textColor)),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20, color: textColor.withOpacity(0.2)),
                    const SizedBox(height: 4),
                    Text("ADICIONAR",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(customFont,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: textColor.withOpacity(0.2))),
                  ],
                ),
        ),
      ),
    );
  }

  // HEADER 

  Widget _buildHeader(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.05),
                backgroundImage: profileImagePath != null
                    ? FileImage(File(profileImagePath!))
                    : null,
                child: profileImagePath == null
                    ? Icon(Icons.person_outline,
                        size: 45, color: textColor.withOpacity(0.4))
                    : null,
              ),
              CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  child: Icon(Icons.camera_alt_outlined,
                      size: 16, color: textColor)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(profileName.toUpperCase(),
            style: GoogleFonts.getFont(customFont,
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5)),
        const SizedBox(height: 4),
        Text("NÍVEL $level  •  $totalCars CARROS",
            style: GoogleFonts.getFont(customFont,
                color: isDark ? Colors.white60 : Colors.black54,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0)),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: openEditModal,
          icon: Icon(Icons.tune, size: 16, color: textColor),
          label: Text("PERSONALIZAR PERFIL",
              style: GoogleFonts.getFont(customFont,
                  color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: textColor.withOpacity(0.15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        ),
      ],
    );
  }

  // RENDERIZADOR DE WIDGETS 

  Widget renderWidget(ProfileWidgetItem w, bool isDark) {
    if (!w.visible) return const SizedBox();
    return Card(
      color: isDark ? const Color(0xFF1A1A1A) : Colors.white.withOpacity(0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05))),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
          padding: const EdgeInsets.all(20), child: _getWidgetContent(w, isDark)),
    );
  }

  Widget _getWidgetContent(ProfileWidgetItem w, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white60 : Colors.black54;
    final headerStyle = GoogleFonts.getFont(customFont,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: subColor,
        letterSpacing: 0.5);

    switch (w.type) {
      case WidgetType.totalCars:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.directions_car_filled, size: 14, color: subColor),
            const SizedBox(width: 8),
            Text("TOTAL DE CARROS", style: headerStyle)
          ]),
          const SizedBox(height: 8),
          Text("$totalCars",
              style: GoogleFonts.getFont(customFont,
                  fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
        ]);

      case WidgetType.favorites:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.star, size: 14, color: subColor),
              const SizedBox(width: 8),
              Text("FAVORITOS (0/3)", style: headerStyle)
            ]),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildFavoriteSlot(0, isDark)),
                const SizedBox(width: 12),
                Expanded(child: _buildFavoriteSlot(1, isDark)),
                const SizedBox(width: 12),
                Expanded(child: _buildFavoriteSlot(2, isDark)),
              ],
            ),
          ],
        );

      case WidgetType.favoriteCar:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.emoji_events, size: 14, color: subColor),
            const SizedBox(width: 8),
            Text("CARRO FAVORITO", style: headerStyle)
          ]),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _openSearchModal(isMainFavorite: true),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark
                    ? Colors.white.withOpacity(0.03)
                    : Colors.black.withOpacity(0.02),
              ),
              child: mainFavoriteCar != null
                  ? Center(
                      child: Text(mainFavoriteCar!.toUpperCase(),
                          style: GoogleFonts.getFont(customFont,
                              fontWeight: FontWeight.bold, color: textColor)))
                  : CustomPaint(
                      painter: DashPainter(color: textColor.withOpacity(0.1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add,
                              size: 16, color: textColor.withOpacity(0.3)),
                          const SizedBox(width: 8),
                          Text("ADICIONAR CARRO FAVORITO",
                              style: GoogleFonts.getFont(customFont,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: textColor.withOpacity(0.3))),
                        ],
                      ),
                    ),
            ),
          ),
        ]);

      case WidgetType.level:
        return Row(children: [
          Icon(Icons.tag, size: 14, color: subColor),
          const SizedBox(width: 8),
          Text("NÍVEL DA COLEÇÃO", style: headerStyle),
          const Spacer(),
          Text("LVL $level",
              style: GoogleFonts.getFont(customFont,
                  fontWeight: FontWeight.bold, color: textColor)),
        ]);

      case WidgetType.customText:
        return Text(customText,
            style:
                GoogleFonts.getFont(customFont, color: textColor, fontSize: 13));

      case WidgetType.memberSince:
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(Icons.calendar_today, size: 14, color: subColor),
                const SizedBox(width: 8),
                Text("MEMBRO DESDE", style: headerStyle)
              ]),
              Text("MAR 2026",
                  style: GoogleFonts.getFont(customFont,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 10)),
            ]);
      default:
        return const SizedBox();
    }
  }

  // MODAL DE PERSONALIZACAO 

  void openEditModal() {
    final nameController = TextEditingController(text: profileName);
    final textController = TextEditingController(text: customText);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<ProfileWidgetItem> editWidgets = widgets
        .map((w) =>
            ProfileWidgetItem(id: w.id, type: w.type, visible: w.visible))
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final modalBg = isDark ? const Color(0xFF121212) : Colors.white;
            final inputBg =
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100];
            final textColor = isDark ? Colors.white : Colors.black;
            final switchColor = isDark ? Colors.white : Colors.black;

            return Dialog(
              backgroundColor: modalBg,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "PERSONALIZAR",
                            style: GoogleFonts.getFont(customFont,
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close,
                                color: textColor.withOpacity(0.5)),
                          )
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text("NOME",
                          style: GoogleFonts.getFont(customFont,
                              fontSize: 10, color: textColor.withOpacity(0.6))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        style: GoogleFonts.getFont(customFont,
                            color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("TEXTO PERSONALIZADO",
                          style: GoogleFonts.getFont(customFont,
                              fontSize: 10, color: textColor.withOpacity(0.6))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: textController,
                        maxLines: 2,
                        maxLength: 120,
                        style: GoogleFonts.getFont(customFont,
                            color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      Text("ORDEM DOS WIDGETS",
                          style: GoogleFonts.getFont(customFont,
                              fontSize: 10, color: textColor.withOpacity(0.6))),
                      const SizedBox(height: 8),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.35,
                        ),
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: ReorderableListView(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            proxyDecorator: (Widget child, int index,
                                Animation<double> animation) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (BuildContext context, Widget? child) {
                                  return Material(
                                    elevation: 0,
                                    color: isDark
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.black.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    child: child,
                                  );
                                },
                                child: child,
                              );
                            },
                            onReorder: (oldIndex, newIndex) {
                              setModalState(() {
                                if (newIndex > oldIndex) newIndex--;
                                final item = editWidgets.removeAt(oldIndex);
                                editWidgets.insert(newIndex, item);
                              });
                            },
                            children: [
                              for (final w in editWidgets)
                                Material(
                                  key: ValueKey(w.id),
                                  color: Colors.transparent,
                                  child: ListTile(
                                    dense: true,
                                    leading: Icon(Icons.unfold_more,
                                        size: 18,
                                        color: textColor.withOpacity(0.3)),
                                    title: Text(widgetLabel(w.type).toUpperCase(),
                                        style: GoogleFonts.getFont(customFont,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: textColor)),
                                    trailing: Transform.scale(
                                      scale: 0.7,
                                      child: Switch(
                                        activeTrackColor:
                                            switchColor.withOpacity(0.5),
                                        activeColor: switchColor,
                                        value: w.visible,
                                        onChanged: (v) =>
                                            setModalState(() => w.visible = v),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
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
                          onPressed: () {
                            setState(() {
                              widgets = editWidgets;
                              profileName = nameController.text;
                              customText = textController.text;
                            });

                            saveProfileData();
                            Navigator.pop(context);
                          },
                          child: Text("SALVAR",
                              style: GoogleFonts.getFont(customFont,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String widgetLabel(WidgetType type) {
    switch (type) {
      case WidgetType.totalCars:
        return "Total de Carros";
      case WidgetType.favorites:
        return "Favoritos";
      case WidgetType.favoriteCar:
        return "Carro Favorito";
      case WidgetType.level:
        return "Nível da Coleção";
      case WidgetType.memberSince:
        return "Membro desde";
      case WidgetType.customText:
        return "Caixa de Texto";
    }
  }

  @override
  Widget build(BuildContext context) {
    return VaporwaveBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: const BottomNav(isProfile: true),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
            children: [
              _buildHeader(Theme.of(context).brightness == Brightness.dark),
              const SizedBox(height: 32),
              ...widgets
                  .where((w) => w.visible)
                  .map((w) => renderWidget(w, Theme.of(context).brightness == Brightness.dark)),
            ],
          ),
        ),
      ),
    );
  }
}

class DashPainter extends CustomPainter {
  final Color color;
  DashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(12)));

    for (ui.PathMetric measure in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < measure.length) {
        canvas.drawPath(measure.extractPath(distance, distance + 4), paint);
        distance += 8;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}