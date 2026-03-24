import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/vaporwave_background.dart';
import '../widgets/bottom_nav.dart'; 
import 'package:google_fonts/google_fonts.dart';

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
  int totalCars = 0;

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

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileName = prefs.getString("profileName") ?? "Colecionador";
      customText = prefs.getString("customText") ?? "Bem-vindo ao meu perfil!";
    });
  }

  Future<void> saveProfile(String name, String text) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profileName", name);
    await prefs.setString("customText", text);
    setState(() {
      profileName = name;
      customText = text;
    });
  }

  void openEditModal() {
    final nameController = TextEditingController(text: profileName);
    final textController = TextEditingController(text: customText);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<ProfileWidgetItem> editWidgets =
        widgets.map((w) => ProfileWidgetItem(id: w.id, type: w.type, visible: w.visible)).toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final modalBg = isDark ? const Color(0xFF121212) : Colors.white;
            final inputBg = isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100];
            final textColor = isDark ? Colors.white : Colors.black;
            
            final switchColor = isDark ? Colors.white : Colors.black;

            return Dialog(
              backgroundColor: modalBg,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                            style: GoogleFonts.getFont(customFont, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close, color: textColor.withOpacity(0.5)),
                          )
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      Text("NOME", style: GoogleFonts.getFont(customFont, fontSize: 10, color: textColor.withOpacity(0.6))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        style: GoogleFonts.getFont(customFont, color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      Text("TEXTO PERSONALIZADO", style: GoogleFonts.getFont(customFont, fontSize: 10, color: textColor.withOpacity(0.6))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: textController,
                        maxLines: 2, 
                        maxLength: 120,
                        style: GoogleFonts.getFont(customFont, color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
Text("ORDEM DOS WIDGETS", style: GoogleFonts.getFont(customFont, fontSize: 10, color: textColor.withOpacity(0.6))),
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
                            proxyDecorator: (Widget child, int index, Animation<double> animation) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (BuildContext context, Widget? child) {
                                  return Material(
                                    elevation: 0,
                                    color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
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
                                    leading: Icon(Icons.unfold_more, size: 18, color: textColor.withOpacity(0.3)),
                                    title: Text(widgetLabel(w.type).toUpperCase(), 
                                      style: GoogleFonts.getFont(customFont, fontSize: 10, fontWeight: FontWeight.w600, color: textColor)),
                                    trailing: Transform.scale(
                                      scale: 0.7,
                                      child: Switch(
                                        activeTrackColor: switchColor.withOpacity(0.5),
                                        activeColor: switchColor,
                                        value: w.visible,
                                        onChanged: (v) => setModalState(() => w.visible = v),
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
                            backgroundColor: isDark ? Colors.white : Colors.black,
                            foregroundColor: isDark ? Colors.black : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            setState(() => widgets = editWidgets);
                            saveProfile(nameController.text, textController.text);
                            Navigator.pop(context);
                          },
                          child: Text("SALVAR", style: GoogleFonts.getFont(customFont, fontWeight: FontWeight.bold)),
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

  Widget _getWidgetIcon(WidgetType type, Color color) {
    switch (type) {
      case WidgetType.totalCars: return Icon(Icons.directions_car, size: 18, color: color);
      case WidgetType.favorites: return Icon(Icons.star_border, size: 18, color: color);
      case WidgetType.favoriteCar: return Icon(Icons.emoji_events_outlined, size: 18, color: color);
      case WidgetType.level: return Icon(Icons.tag, size: 18, color: color);
      case WidgetType.memberSince: return Icon(Icons.calendar_today_outlined, size: 16, color: color);
      case WidgetType.customText: return Icon(Icons.chat_bubble_outline, size: 16, color: color);
    }
  }

  String widgetLabel(WidgetType type) {
    switch (type) {
      case WidgetType.totalCars: return "Total de Carros";
      case WidgetType.favorites: return "Favoritos";
      case WidgetType.favoriteCar: return "Carro Favorito";
      case WidgetType.level: return "Nível da Coleção";
      case WidgetType.memberSince: return "Membro desde";
      case WidgetType.customText: return "Caixa de Texto";
    }
  }

  Widget _buildHeader(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(radius: 50, backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
              child: Icon(Icons.person, size: 50, color: textColor.withOpacity(0.5))),
            CircleAvatar(radius: 18, backgroundColor: isDark ? Colors.grey[850] : Colors.white,
              child: IconButton(icon: Icon(Icons.camera_alt, size: 18, color: textColor), onPressed: () {})),
          ],
        ),
        const SizedBox(height: 15),
        Text(profileName.toUpperCase(), style: GoogleFonts.getFont(customFont, color: textColor, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        Text("NÍVEL $level  •  $totalCars CARROS", style: GoogleFonts.getFont(customFont, color: isDark ? Colors.white70 : Colors.black54, fontSize: 14)),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: openEditModal,
          icon: Icon(Icons.tune, size: 18, color: textColor),
          label: Text("PERSONALIZAR PERFIL", style: GoogleFonts.getFont(customFont, color: textColor, fontSize: 12)),
          style: OutlinedButton.styleFrom(side: BorderSide(color: textColor.withOpacity(0.2)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        ),
      ],
    );
  }

  Widget renderWidget(ProfileWidgetItem w, bool isDark) {
    if (!w.visible) return const SizedBox();
    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white.withOpacity(0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05))),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(padding: const EdgeInsets.all(16), child: _getWidgetContent(w, isDark)),
    );
  }

  Widget _getWidgetContent(ProfileWidgetItem w, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.black54;
    final headerStyle = GoogleFonts.getFont(customFont, fontSize: 12, fontWeight: FontWeight.bold, color: subColor);
    final valueStyle = GoogleFonts.getFont(customFont, fontSize: 24, fontWeight: FontWeight.bold, color: textColor);

    switch (w.type) {
      case WidgetType.totalCars:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(Icons.directions_car_outlined, size: 16, color: subColor), const SizedBox(width: 8), Text("TOTAL DE CARROS", style: headerStyle)]),
          const SizedBox(height: 8), Text("$totalCars", style: valueStyle),
        ]);
      case WidgetType.level:
        return ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.workspace_premium_outlined, color: textColor), title: Text("NÍVEL DA COLEÇÃO", style: headerStyle), subtitle: Text("Level $level", style: valueStyle.copyWith(fontSize: 18)));
      case WidgetType.customText:
        return Text(customText, style: GoogleFonts.getFont(customFont, color: textColor));
      case WidgetType.memberSince:
        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("MEMBRO DESDE", style: headerStyle), Text("MAR 2026", style: headerStyle.copyWith(color: textColor))]);
      default:
        return Text(widgetLabel(w.type).toUpperCase(), style: headerStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final visibleWidgets = widgets.where((w) => w.visible).toList();

    return VaporwaveBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        extendBodyBehindAppBar: true,
        extendBody: true, 
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: const BottomNav(isProfile: true),
        ),
        body: SafeArea(
          bottom: false, 
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 120), 
            children: [
              _buildHeader(isDark),
              const SizedBox(height: 30),
              ...visibleWidgets.map((w) => renderWidget(w, isDark)),
            ],
          ),
        ),
      ),
    );
  }
}