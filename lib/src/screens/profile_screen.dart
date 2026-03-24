import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/vaporwave_background.dart';

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

    List<ProfileWidgetItem> editWidgets =
        widgets.map((w) => ProfileWidgetItem(id: w.id, type: w.type, visible: w.visible)).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Personalizar Perfil",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      maxLength: 20,
                      decoration: const InputDecoration(labelText: "Nome"),
                    ),
                    TextField(
                      controller: textController,
                      maxLength: 120,
                      decoration: const InputDecoration(labelText: "Texto personalizado"),
                    ),
                    const SizedBox(height: 20),
                    const Text("Ordem dos Widgets"),
                    SizedBox(
                      height: 200,
                      child: ReorderableListView(
                        onReorder: (oldIndex, newIndex) {
                          setModalState(() {
                            if (newIndex > oldIndex) newIndex--;
                            final item = editWidgets.removeAt(oldIndex);
                            editWidgets.insert(newIndex, item);
                          });
                        },
                        children: [
                          for (final w in editWidgets)
                            ListTile(
                              key: ValueKey(w.id),
                              title: Text(widgetLabel(w.type)),
                              trailing: Switch(
                                value: w.visible,
                                onChanged: (v) {
                                  setModalState(() {
                                    w.visible = v;
                                  });
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widgets = editWidgets;
                        });
                        saveProfile(nameController.text, textController.text);
                        Navigator.pop(context);
                      },
                      child: const Text("Salvar"),
                    ),
                  ],
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
      case WidgetType.totalCars: return "Total de Carros";
      case WidgetType.favorites: return "Favoritos";
      case WidgetType.favoriteCar: return "Carro Favorito";
      case WidgetType.level: return "Nível";
      case WidgetType.memberSince: return "Membro desde";
      case WidgetType.customText: return "Texto Personalizado";
    }
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 15),
        Text(
          profileName.toUpperCase(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          "NÍVEL $level  •  $totalCars CARROS",
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget renderWidget(ProfileWidgetItem w, bool isDark) {
    if (!w.visible) return const SizedBox();

    // Estilo padrão dos cards para combinar com o Vaporwave
    final cardTheme = Card(
      color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 15),
      child: _getWidgetContent(w),
    );

    return cardTheme;
  }

  Widget _getWidgetContent(ProfileWidgetItem w) {
    switch (w.type) {
      case WidgetType.totalCars:
        return ListTile(
          leading: const Icon(Icons.directions_car),
          title: const Text("Total de carros"),
          subtitle: Text("$totalCars"),
        );
      case WidgetType.level:
        return ListTile(
          leading: const Icon(Icons.trending_up),
          title: const Text("Nível da coleção"),
          subtitle: Text("Level $level"),
        );
      case WidgetType.memberSince:
        return const ListTile(
          leading: const Icon(Icons.calendar_today),
          title: Text("Membro desde"),
          subtitle: Text("Mar 2026"),
        );
      case WidgetType.customText:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(customText),
        );
      case WidgetType.favorites:
      case WidgetType.favoriteCar:
        return const ListTile(
          title: Text("Em breve"),
          subtitle: Text("Funcionalidade em desenvolvimento"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final visibleWidgets = widgets.where((w) => w.visible).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: openEditModal,
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        child: Icon(
          Icons.settings,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: VaporwaveBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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