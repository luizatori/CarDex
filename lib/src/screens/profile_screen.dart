import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:intl/intl.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:ui' as ui;

import '../widgets/vaporwave_background.dart';
import '../widgets/bottom_nav.dart';
import '../providers/cars_provider.dart';
import '../models/car.dart';
import '../widgets/favorites_modal.dart';

// TELA DE PERFIL, RESPONSAVEL POR EXIBIR AS INFORMACOES DO USUARIO, PERMITINDO PERSONALIZACAO DO PERFIL, GERENCIAMENTO DE FAVORITOS E ACESSO AS CONFIGURACOES DE CONTA
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// enum para identificar os tipos de widgets que o usuario pode escolher exibir no perfil
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
  String? mainFavoriteCarId;
  String? profileImagePath;
  List<String> favoriteCarIds = [];
 // lista de widgets disponiveis para personalizacao do perfil, o usuario pode escolher quais exibir e em qual ordem
  List<ProfileWidgetItem> widgets = [
    ProfileWidgetItem(id: "w1", type: WidgetType.totalCars, visible: true),
    ProfileWidgetItem(id: "w2", type: WidgetType.favorites, visible: true),
    ProfileWidgetItem(id: "w3", type: WidgetType.favoriteCar, visible: true),
    ProfileWidgetItem(id: "w4", type: WidgetType.level, visible: true),
    ProfileWidgetItem(id: "w5", type: WidgetType.memberSince, visible: true),
    ProfileWidgetItem(id: "w6", type: WidgetType.customText, visible: true),
  ];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }
 // chave unica com preferencias do usuario
  String _userKey(String key) {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? "${user.uid}_$key" : key;
  }

// widget para exibir a data de cadastro do usuario, em pt-br
  String _getMemberSinceDate() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.metadata.creationTime != null) {
      return DateFormat('MMM yyyy', 'pt_BR').format(user.metadata.creationTime!).toUpperCase();
    }
    return "MAR 2026";
  }

// METODO PARA CARREGAR AS INFORMACOES DO PERFIL DO USUARIO
  Future<void> loadProfile() async {
    setState(() {
      // valores padrao caso nao haja dados salvos
      profileName = "Colecionador";
      customText = "Bem-vindo ao meu perfil!";
      mainFavoriteCarId = null;
      profileImagePath = null;
      favoriteCarIds = [];
      widgets = [
        ProfileWidgetItem(id: "w1", type: WidgetType.totalCars, visible: true),
        ProfileWidgetItem(id: "w2", type: WidgetType.favorites, visible: true),
        ProfileWidgetItem(id: "w3", type: WidgetType.favoriteCar, visible: true),
        ProfileWidgetItem(id: "w4", type: WidgetType.level, visible: true),
        ProfileWidgetItem(id: "w5", type: WidgetType.memberSince, visible: true),
        ProfileWidgetItem(id: "w6", type: WidgetType.customText, visible: true),
      ];
    });

    final prefs = await SharedPreferences.getInstance();
    final savedOrder = prefs.getStringList(_userKey("widgetsOrder"));

// carrega os dados salvos nas preferencias do usuario, caso haja, e atualiza o estado para exibir as informacoes no perfil, caso haja uma ordem salva de widgets, ordena a lista de widgets de acordo com a ordem salva, caso contrario, mantem a ordem padrao
    if (mounted) {
      setState(() {
        profileName = prefs.getString(_userKey("profileName")) ?? "Colecionador";
        customText = prefs.getString(_userKey("customText")) ?? "Bem-vindo ao meu perfil!";
        mainFavoriteCarId = prefs.getString(_userKey("mainFavoriteCarId"));
        profileImagePath = prefs.getString(_userKey("profileImage"));
        favoriteCarIds = prefs.getStringList(_userKey("favoriteCarIds")) ?? [];

        if (savedOrder != null && savedOrder.isNotEmpty) {
          List<ProfileWidgetItem> ordered = [];
          for (String id in savedOrder) {
            final isVisible = prefs.getBool(_userKey("widgetVisible_$id")) ?? true;
            try {
              int val = int.parse(id.replaceAll(RegExp(r'[^0-9]'), ''));
              if (val > 0 && val <= WidgetType.values.length) {
                ordered.add(ProfileWidgetItem(
                  id: id,
                  type: WidgetType.values[val - 1],
                  visible: isVisible,
                ));
              }
            } catch (e) {
              debugPrint("Erro ao processar widget $id: $e");
            }
          }
          if (ordered.isNotEmpty) {
            widgets = ordered;
          }
        }
      });
    }
  }

// METODO PARA SALVAR AS INFORMACOES DO PERFIL DO USUARIO NAS PREFERENCIAS
  Future<void> saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey("profileName"), profileName);
    await prefs.setString(_userKey("customText"), customText);
    if (mainFavoriteCarId != null) await prefs.setString(_userKey("mainFavoriteCarId"), mainFavoriteCarId!);
    if (profileImagePath != null) await prefs.setString(_userKey("profileImage"), profileImagePath!);
    await prefs.setStringList(_userKey("favoriteCarIds"), favoriteCarIds);

    List<String> orderIds = widgets.map((w) => w.id).toList();
    await prefs.setStringList(_userKey("widgetsOrder"), orderIds);
    for (var w in widgets) {
      await prefs.setBool(_userKey("widgetVisible_${w.id}"), w.visible);
    }
  }

// METODO PARA PERMITIR AO USUARIO ESCOLHER UMA IMAGEM DE PERFIL DA GALERIA
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => profileImagePath = image.path);
      saveProfileData();
    }
  }

// METODO PARA EXIBIR MODAL DE LOGOUT
  void _confirmLogout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final modalBg = isDark ? const Color(0xFF121212) : Colors.white;

// exibe um dialog de confirmacao de logout, caso o usuario confirme, chama o metodo de logout do FirebaseAuth e redireciona para a tela de login, caso contrario, fecha o dialog e mantem o usuario logado
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: modalBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: textColor.withOpacity(0.1))),
        title: Text("LOGOUT", style: GoogleFonts.getFont(customFont, fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        content: Text("Deseja mesmo sair da sua conta?", style: GoogleFonts.getFont(customFont, fontSize: 13, color: textColor.withOpacity(0.7))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCELAR", style: GoogleFonts.getFont(customFont, fontSize: 11, color: textColor.withOpacity(0.5))),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text("SIM, SAIR", style: GoogleFonts.getFont(customFont, fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

// METODO PARA EXIBIR MODAL DE CONFIRMACAO DE EXCLUSAO DE CONTA
void _confirmDeleteAccount() {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final textColor = isDark ? Colors.white : Colors.black;
  final modalBg = isDark ? const Color(0xFF121212) : Colors.white;
  final passwordController = TextEditingController();

// exibe um dialog de confirmacao de exclusao de conta, solicita a senha do usuario para confirmar a exclusao, caso o usuario confirme e a senha esteja correta, exclui a conta do FirebaseAuth e os dados do Firestore, redireciona para a tela de login, caso contrario, exibe uma mensagem de erro e mantem a conta ativa
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: modalBg,
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      actionsOverflowButtonSpacing: 8,
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), 
        side: BorderSide(color: textColor.withOpacity(0.1))
      ),
      title: Text(
        "EXCLUIR CONTA", 
        style: GoogleFonts.getFont(customFont, fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Esta ação é irreversível. Digite sua senha para confirmar:", 
              style: GoogleFonts.getFont(customFont, fontSize: 13, color: textColor.withOpacity(0.7))
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: GoogleFonts.getFont(customFont, color: textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Sua senha",
                hintStyle: GoogleFonts.getFont(customFont, color: textColor.withOpacity(0.3), fontSize: 12),
                filled: true,
                fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "CANCELAR", 
            style: GoogleFonts.getFont(customFont, fontSize: 11, color: textColor.withOpacity(0.5))
          ),
        ),
        // botao de confirmacao de exclusao, chama a funcao de exclusao de conta, trata erros e exibe mensagens para o usuario
          TextButton(
            onPressed: () async {
              try {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null && user.email != null) {
                  AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: passwordController.text);
                  await user.reauthenticateWithCredential(credential);
                  await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
                  await user.delete();
                  if (mounted) Navigator.pushReplacementNamed(context, '/login');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao excluir: Senha incorreta ou falha no servidor.")));
              }
            },
            child: Text("EXCLUIR TUDO", style: GoogleFonts.getFont(customFont, fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

// METODO PARA EXIBIR O MODAL DE GERENCIAMENTO DE FAVORITOS
  void _openFavoritesManager() async {
    final carsProvider = Provider.of<CarsProvider>(context, listen: false);
    final List<String>? result = await showFavoritesModal(
      context,
      cars: carsProvider.cars,
      currentFavoriteIds: favoriteCarIds,
    );

    if (result != null) {
      setState(() => favoriteCarIds = result);
      saveProfileData();
    }
  }

  void _openMainFavoriteManager() {
    final carsProvider = Provider.of<CarsProvider>(context, listen: false);
    final availableCars = carsProvider.cars.where((c) => !c.isEmpty).toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1A1A1A) : Colors.white,
        title: Text("SELECIONAR DESTAQUE", style: GoogleFonts.getFont(customFont, fontSize: 14, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: availableCars.isEmpty 
            ? const Padding(padding: EdgeInsets.all(20), child: Text("Nenhum carro na coleção"))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: availableCars.length,
                itemBuilder: (context, index) {
                  final car = availableCars[index];
                  return ListTile(
                    title: Text(car.name.toUpperCase(), style: GoogleFonts.getFont(customFont, fontSize: 12)),
                    onTap: () {
                      setState(() => mainFavoriteCarId = car.id);
                      saveProfileData();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
        ),
      ),
    );
  }
 // METODO DE CONSTRUCAO DO SLOT DE FAVORITOS
  Widget _buildFavoriteSlot(int index, bool isDark, List<CarItem> allCars) {
    final textColor = isDark ? Colors.white : Colors.black;
    CarItem? car;

    if (index < favoriteCarIds.length) {
      final id = favoriteCarIds[index];
      try {
        car = allCars.firstWhere((c) => c.id == id && !c.isEmpty);
      } catch (_) { car = null; }
    }

    return GestureDetector(
      onTap: _openFavoritesManager,
      child: CustomPaint(
        painter: DashPainter(color: textColor.withOpacity(0.15)),
        child: Container(
          width: 90,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
          ),
          child: car != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car, color: textColor, size: 24),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(car.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.getFont(customFont, fontSize: 7, color: textColor)),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20, color: textColor.withOpacity(0.2)),
                    const SizedBox(height: 4),
                    Text("ADICIONAR",
                        style: GoogleFonts.getFont(customFont,
                            fontSize: 7, fontWeight: FontWeight.bold, color: textColor.withOpacity(0.2))),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, int totalCars) {
    final textColor = isDark ? Colors.white : Colors.black;
    final level = (totalCars ~/ 5) + 1;

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
                backgroundImage: (profileImagePath != null && File(profileImagePath!).existsSync()) 
                    ? FileImage(File(profileImagePath!)) 
                    : null,
                child: (profileImagePath == null || !File(profileImagePath!).existsSync())
                    ? Icon(Icons.person_outline, size: 45, color: textColor.withOpacity(0.4))
                    : null,
              ),
              CircleAvatar(
                  radius: 16,
                  backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  child: Icon(Icons.camera_alt_outlined, size: 16, color: textColor)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(profileName.toUpperCase(),
            style: GoogleFonts.getFont(customFont,
                color: textColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 4),
        Text("NÍVEL $level  •  $totalCars CARROS",
            style: GoogleFonts.getFont(customFont,
                color: isDark ? Colors.white60 : Colors.black54,
                fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,      
          runSpacing: 12, 
          children: [
            OutlinedButton.icon(
              onPressed: openEditModal,
              icon: Icon(Icons.tune, size: 16, color: textColor),
              label: Text(
                "PERSONALIZAR PERFIL",
                style: GoogleFonts.getFont(customFont, 
                  color: textColor, 
                  fontSize: 10, 
                  fontWeight: FontWeight.bold
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: textColor.withOpacity(0.15)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            OutlinedButton(
              onPressed: _confirmLogout,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: textColor.withOpacity(0.15)),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: Icon(Icons.logout, size: 16, color: textColor),
            ),
            OutlinedButton(
              onPressed: _confirmDeleteAccount,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.redAccent.withOpacity(0.15)),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
            ),
          ],
        ),
      ],
    );
  }
 // METODO PARA RENDERIZAR OS WIDGETS DE PERSONALIZACAO DO PERFIL, RECEBE O TIPO DO WIDGET E EXIBE O CONTEUDO CORRESPONDENTE, COMO TOTAL DE CARROS, FAVORITOS, CARRO DESTAQUE, NÍVEL DA COLECAO, DATA DE MEMBRO E TEXTO PERSONALIZADO
  Widget renderWidget(ProfileWidgetItem w, bool isDark, int totalCars, List<CarItem> allCars) {
    return Card(
      color: isDark ? const Color(0xFF1A1A1A) : Colors.white.withOpacity(0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05))),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: _getWidgetContent(w, isDark, totalCars, allCars)
      ),
    );
  }
// metodo auxiliar para obter o conteudo do widget de personalizacao, baseado no tipo do widget, retorna o conteudo correspondente
  Widget _getWidgetContent(ProfileWidgetItem w, bool isDark, int totalCars, List<CarItem> allCars) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white60 : Colors.black54;
    final level = (totalCars ~/ 5) + 1;
    final headerStyle = GoogleFonts.getFont(customFont,
        fontSize: 10, fontWeight: FontWeight.bold, color: subColor, letterSpacing: 0.5);

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
              style: GoogleFonts.getFont(customFont, fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
        ]);

      case WidgetType.favorites:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.star, size: 14, color: subColor),
              const SizedBox(width: 8),
              Text("FAVORITOS (${favoriteCarIds.length}/3)", style: headerStyle)
            ]),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildFavoriteSlot(0, isDark, allCars)),
                const SizedBox(width: 12),
                Expanded(child: _buildFavoriteSlot(1, isDark, allCars)),
                const SizedBox(width: 12),
                Expanded(child: _buildFavoriteSlot(2, isDark, allCars)),
              ],
            ),
          ],
        );

// METODO PARA RENDERIZAR O SLOT DE CARRO FAVORITO, EXIBE O CARRO DESTAQUE SE HOUVER, CASO CONTRARIO, EXIBE UM BOTAO PARA SELECIONAR O CARRO DESTAQUE, PERMITE AO USUARIO GERENCIAR O CARRO DESTAQUE ATRAVES DE UM MODAL COM A LISTA DE CARROS DA COLECAO
      case WidgetType.favoriteCar:
        CarItem? mainCar;
        if (mainFavoriteCarId != null) {
          try {
            mainCar = allCars.firstWhere((c) => c.id == mainFavoriteCarId && !c.isEmpty);
          } catch (_) {}
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.emoji_events, size: 14, color: subColor),
            const SizedBox(width: 8),
            Text("CARRO FAVORITO", style: headerStyle)
          ]),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _openMainFavoriteManager,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
              ),
              child: mainCar != null
                  ? Center(
                      child: Text(mainCar.name.toUpperCase(),
                          style: GoogleFonts.getFont(customFont, fontWeight: FontWeight.bold, color: textColor)))
                  : CustomPaint(
                      painter: DashPainter(color: textColor.withOpacity(0.1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 16, color: textColor.withOpacity(0.3)),
                          const SizedBox(width: 8),
                          Text("SELECIONAR CARRO DESTAQUE",
                              style: GoogleFonts.getFont(customFont,
                                  fontSize: 9, fontWeight: FontWeight.bold, color: textColor.withOpacity(0.3))),
                        ],
                      ),
                    ),
            ),
          ),
        ]);

// METODO PARA RENDERIZAR O SLOT DE NÍVEL DA COLECAO, CALCULA O NIVEL BASEADO NO TOTAL DE CARROS E EXIBE O NIVEL ATUAL DO USUÁRIO, O NIVEL AUMENTA A CADA 5 CARROS ADICIONADOS NA COLECAO
      case WidgetType.level:
        return Row(children: [
          Icon(Icons.tag, size: 14, color: subColor),
          const SizedBox(width: 8),
          Text("NÍVEL DA COLEÇÃO", style: headerStyle),
          const Spacer(),
          Text("LVL $level", style: GoogleFonts.getFont(customFont, fontWeight: FontWeight.bold, color: textColor)),
        ]);

// METODO PARA RENDERIZAR O SLOT DE TEXTO PERSONALIZADO, EXIBE O TEXTO PERSONALIZADO DEFINIDO PELO USUARIO
      case WidgetType.customText:
        return Text(customText, style: GoogleFonts.getFont(customFont, color: textColor, fontSize: 13));

// METODO PARA RENDERIZAR O SLOT DE DATA DE CADASTRO
      case WidgetType.memberSince:
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(Icons.calendar_today, size: 14, color: subColor),
                const SizedBox(width: 8),
                Text("MEMBRO DESDE", style: headerStyle)
              ]),
              Text(_getMemberSinceDate(),
                  style: GoogleFonts.getFont(customFont, fontWeight: FontWeight.bold, color: textColor, fontSize: 10)),
            ]);
      default:
        return const SizedBox();
    }
  }

// METODO PARA EXIBIR O MODAL DE PERSONALIZACAO DO PERFIL
  void openEditModal() {
    final nameController = TextEditingController(text: profileName);
    final textController = TextEditingController(text: customText);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<ProfileWidgetItem> editWidgets = widgets
        .map((w) => ProfileWidgetItem(id: w.id, type: w.type, visible: w.visible))
        .toList();

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
                          Text("PERSONALIZAR",
                            style: GoogleFonts.getFont(customFont, fontSize: 16, fontWeight: FontWeight.bold)),
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
                        ),
                      ),
                      Text("ORDEM E VISIBILIDADE", style: GoogleFonts.getFont(customFont, fontSize: 10, color: textColor.withOpacity(0.6))),
                      const SizedBox(height: 8),
                      Container(
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.35),
                        decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(12)),
                        child: Theme(
                          data: Theme.of(context).copyWith(canvasColor: Colors.transparent, shadowColor: Colors.transparent),
                          child: ReorderableListView(
                            shrinkWrap: true,
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
                                  dense: true,
                                  leading: Icon(Icons.unfold_more, size: 18, color: textColor.withOpacity(0.3)),
                                  title: Text(widgetLabel(w.type).toUpperCase(),
                                      style: GoogleFonts.getFont(customFont, fontSize: 10, fontWeight: FontWeight.w600, color: textColor)),
                                  trailing: Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      activeThumbColor: switchColor,
                                      value: w.visible,
                                      onChanged: (v) => setModalState(() => w.visible = v),
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
                            setState(() {
                              widgets = editWidgets;
                              profileName = nameController.text;
                              customText = textController.text;
                            });
                            saveProfileData();
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

  @override
  Widget build(BuildContext context) {
    final carsProvider = Provider.of<CarsProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return VaporwaveBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const BottomNav(isProfile: true),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
            children: [
              _buildHeader(isDark, carsProvider.filledCount),
              const SizedBox(height: 32),
              ...widgets
                  .where((w) => w.visible)
                  .map((w) => renderWidget(w, isDark, carsProvider.filledCount, carsProvider.cars)),
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
    final paint = Paint()..color = color..strokeWidth = 1..style = PaintingStyle.stroke;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(12)));
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