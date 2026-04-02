import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/car.dart';

Future<List<String>?> showFavoritesModal(
  BuildContext context, {
  required List<CarItem> cars,
  required List<String> currentFavoriteIds,
  int maxFavorites = 3,
}) {
  return showDialog<List<String>>(
    context: context,
    builder: (_) => _FavoritesModal(
      cars: cars,
      currentFavoriteIds: currentFavoriteIds,
      maxFavorites: maxFavorites,
    ),
  );
}

class _FavoritesModal extends StatefulWidget {
  final List<CarItem> cars;
  final List<String> currentFavoriteIds;
  final int maxFavorites;

  const _FavoritesModal({
    required this.cars,
    required this.currentFavoriteIds,
    required this.maxFavorites,
  });

  @override
  State<_FavoritesModal> createState() => _FavoritesModalState();
}

class _FavoritesModalState extends State<_FavoritesModal> {
  final TextEditingController searchController = TextEditingController();
  final String customFont = 'IBM Plex Mono'; // Fonte do projeto
  List<String> selected = [];
  List<CarItem> filtered = [];

  @override
  void initState() {
    super.initState();
    final existingCarIds = widget.cars.where((c) => !c.isEmpty).map((c) => c.id).toSet();
    selected = widget.currentFavoriteIds.where((id) => existingCarIds.contains(id)).toList();
    
    filtered = widget.cars.where((c) => !c.isEmpty).toList();
    searchController.addListener(_filter);
  }

  void _filter() {
    final query = searchController.text.toLowerCase();
    final filled = widget.cars.where((c) => !c.isEmpty).toList();
    setState(() {
      filtered = query.isEmpty 
          ? filled 
          : filled.where((c) => c.name.toLowerCase().contains(query)).toList();
    });
  }

  void toggle(String id) {
    setState(() {
      if (selected.contains(id)) {
        selected.remove(id);
      } else if (selected.length < widget.maxFavorites) {
        selected.add(id);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final accentColor = isDark ? Colors.white : Colors.black; // Seguindo o padrão minimalista do perfil
    
    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 340,
        height: 580,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 12, 12),
              child: Row(
                children: [
                  Icon(Icons.star, size: 16, color: textColor),
                  const SizedBox(width: 10),
                  Text(
                    "SELECIONAR (${selected.length}/${widget.maxFavorites})",
                    style: GoogleFonts.getFont(customFont, 
                      fontSize: 14, 
                      fontWeight: FontWeight.bold, 
                      color: textColor,
                      letterSpacing: 0.5
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: textColor.withOpacity(0.5)), 
                    onPressed: () => Navigator.pop(context)
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: searchController,
                style: GoogleFonts.getFont(customFont, fontSize: 13, color: textColor),
                decoration: InputDecoration(
                  hintText: "BUSCAR CARRO...",
                  hintStyle: GoogleFonts.getFont(customFont, fontSize: 11, color: textColor.withOpacity(0.3)),
                  prefixIcon: Icon(Icons.search, size: 18, color: textColor.withOpacity(0.3)),
                  filled: true,
                  fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        "NENHUM CARRO ENCONTRADO", 
                        style: GoogleFonts.getFont(customFont, fontSize: 10, color: textColor.withOpacity(0.4))
                      )
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final car = filtered[index];
                        final isSelected = selected.contains(car.id);
                        return GestureDetector(
                          onTap: () => toggle(car.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected 
                                ? (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)) 
                                : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: isSelected ? textColor : (isDark ? Colors.white10 : Colors.black), 
                                  width: 1.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.directions_car, 
                                    size: 20,
                                    color: isSelected ? textColor : textColor.withOpacity(0.2)),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    car.name.toUpperCase(), 
                                    style: GoogleFonts.getFont(customFont, 
                                      fontSize: 7, 
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? textColor : textColor.withOpacity(0.4)
                                    ), 
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textColor, 
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  onPressed: () => Navigator.pop(context, selected),
                  child: Text(
                    "SALVAR", 
                    style: GoogleFonts.getFont(customFont, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}