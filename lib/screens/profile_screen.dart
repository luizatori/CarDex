import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List<ProfileWidgetItem> widgets = [
    ProfileWidgetItem(id: "w1", type: WidgetType.totalCars, visible: true),
    ProfileWidgetItem(id: "w2", type: WidgetType.favorites, visible: true),
    ProfileWidgetItem(id: "w3", type: WidgetType.favoriteCar, visible: true),
    ProfileWidgetItem(id: "w4", type: WidgetType.level, visible: true),
    ProfileWidgetItem(id: "w5", type: WidgetType.memberSince, visible: true),
    ProfileWidgetItem(id: "w6", type: WidgetType.customText, visible: true),
  ];

  int totalCars = 0;

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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      decoration:
                          const InputDecoration(labelText: "Texto personalizado"),
                    ),

                    const SizedBox(height: 20),

                    const Text("Widgets"),

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

                        saveProfile(
                          nameController.text,
                          textController.text,
                        );

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
      case WidgetType.totalCars:
        return "Total de Carros";
      case WidgetType.favorites:
        return "Favoritos";
      case WidgetType.favoriteCar:
        return "Carro Favorito";
      case WidgetType.level:
        return "Nível";
      case WidgetType.memberSince:
        return "Membro desde";
      case WidgetType.customText:
        return "Texto Personalizado";
    }
  }

  Widget renderWidget(ProfileWidgetItem w) {
    if (!w.visible) return const SizedBox();

    switch (w.type) {
      case WidgetType.totalCars:
        return Card(
          child: ListTile(
            title: const Text("Total de carros"),
            subtitle: Text("$totalCars"),
          ),
        );

      case WidgetType.level:
        return Card(
          child: ListTile(
            title: const Text("Nível da coleção"),
            subtitle: Text("$level"),
          ),
        );

      case WidgetType.memberSince:
        return const Card(
          child: ListTile(
            title: Text("Membro desde"),
            subtitle: Text("Mar 2026"),
          ),
        );

      case WidgetType.customText:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(customText),
          ),
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleWidgets = widgets.where((w) => w.visible).toList();

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: openEditModal,
        child: const Icon(Icons.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          Column(
            children: [
              const CircleAvatar(
                radius: 45,
                child: Icon(Icons.person, size: 40),
              ),
              const SizedBox(height: 10),
              Text(
                profileName,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Nível $level • $totalCars carros"),
            ],
          ),

          const SizedBox(height: 30),

          ...visibleWidgets.map(renderWidget)
        ],
      ),
    );
  }
}