import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/theme_provider.dart';
import '../providers/cars_provider.dart';
import '../models/car.dart';

import '../widgets/car_card.dart';
import '../widgets/card_reveal_modal.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/filter_dropdown.dart';
import '../widgets/vaporwave_background.dart';
import '../widgets/vaporwave_logo.dart'; 
import '../widgets/car_expanded_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CarItem? selectedCar;

  void handleCardClick(CarItem car, int totalColecao) {
    setState(() {
      selectedCar = car;
    });

    if (!car.isEmpty) {
      // 1. SE O CARD ESTA POPULADO - abre a visualização expandida
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false, 
          barrierColor: Colors.transparent,
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, _, _) => CarExpandedView(
            id: car.id, 
            imageUrl: car.imageUrl ?? "",
            name: car.name,
            description: car.description,
            heroTag: 'car_hero_${car.id}', // Tag consistente com o CarCard
          ),
        ),
      );
    } else {
      // 2. SE O CARD ESTA VAZIO - abre o modal de criacao
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black87,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, anim1, anim2) {
          return CardRevealModal(
            slotId: car.id, 
            isOpen: true,
            imageUrl: car.imageUrl,
            isNewCard: car.isEmpty,
            totalCarrosColecao: totalColecao,
            onClose: () {
              Navigator.pop(context);
              setState(() => selectedCar = null);
            },
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    
    return Scaffold(
      backgroundColor: Colors.transparent, 
      extendBody: true, 
      resizeToAvoidBottomInset: false, 
      
      body: VaporwaveBackground(
        child: SafeArea(
          bottom: false, 
          child: StreamBuilder<List<CarItem>>(
            // escuta o stream do firestore atraves do provider
            stream: context.watch<CarsProvider>().carStream, 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
              }

              final cars = snapshot.data ?? [];
              final filledCount = cars.where((c) => !c.isEmpty).length;

              return Column(
                children: [
                  const SizedBox(height: 35), 
                  Column(
                    children: [
                      const VaporwaveLogo(size: 190), 
                      const SizedBox(height: 23), 
                      Text(
                        "Armazene seus carros aqui.".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 15,
                          letterSpacing: 2.5, 
                          fontWeight: FontWeight.w400,
                          color: isDark ? Colors.white70 : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 25), 
                      _buildDivider(isDark),
                    ],
                  ),

                  const SizedBox(height: 35), 

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Expanded(child: FilterDropdown(label: "Data")),
                        SizedBox(width: 12),
                        Expanded(child: FilterDropdown(label: "Favoritos")),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25), 

                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: cars.length,
                      itemBuilder: (context, index) {
                        final car = cars[index];
                        return CarCard(
                          id: car.id, // ID unico para o hero e key
                          imageUrl: car.imageUrl,
                          isEmpty: car.isEmpty,
                          name: car.name,
                          onTap: () => handleCardClick(car, filledCount),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 115, top: 15), 
                    child: Text(
                      "coleção · $filledCount / ∞".toUpperCase(),
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 11,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white38 : Colors.black26,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(isProfile: false),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50), 
      child: Container(
        height: 1.5, 
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (isDark ? Colors.white : Colors.black).withOpacity(0.0),
              (isDark ? Colors.white : Colors.black).withOpacity(0.8), 
              (isDark ? Colors.white : Colors.black).withOpacity(0.0),
            ],
            stops: const [0.0, 0.5, 1.0], 
          ),
        ),
      ),
    );
  }
}