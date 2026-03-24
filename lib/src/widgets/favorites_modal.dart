import 'package:flutter/material.dart';
import '../models/car.dart';

Future<List<String>?> showFavoritesModal(
  BuildContext context, {
  required List<CarItem> cars,
  required List<String> currentFavoriteIds,
  int maxFavorites = 4,
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

  List<String> selected = [];
  List<CarItem> filtered = [];

  @override
  void initState() {
    super.initState();

    selected = List.from(widget.currentFavoriteIds);

    filtered = widget.cars
        .where((c) => !c.isEmpty && c.imageUrl != null)
        .toList();

    searchController.addListener(_filter);
  }

  void _filter() {
    final query = searchController.text.toLowerCase();

    final filled =
        widget.cars.where((c) => !c.isEmpty && c.imageUrl != null).toList();

    setState(() {
      if (query.isEmpty) {
        filtered = filled;
      } else {
        filtered = filled
            .where((c) => c.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void toggle(String id) {
    setState(() {
      if (selected.contains(id)) {
        selected.remove(id);
      } else {
        if (selected.length < widget.maxFavorites) {
          selected.add(id);
        }
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
    final filledCars =
        widget.cars.where((c) => !c.isEmpty && c.imageUrl != null).toList();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 340,
        height: 520,
        child: Column(
          children: [

            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Favoritos (${selected.length}/${widget.maxFavorites})",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Buscar por nome...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// GRID
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        filledCars.isEmpty
                            ? "Nenhum carro na coleção ainda"
                            : "Nenhum resultado",
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final car = filtered[index];

                        final isSelected = selected.contains(car.id);
                        final isFull =
                            selected.length >= widget.maxFavorites &&
                                !isSelected;

                        return GestureDetector(
                          onTap: () {
                            if (!isFull) {
                              toggle(car.id);
                            }
                          },
                          child: Opacity(
                            opacity: isFull ? 0.4 : 1,
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Image.network(
                                            car.imageUrl!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        car.name.isEmpty
                                            ? "Sem nome"
                                            : car.name,
                                        style: const TextStyle(
                                          fontSize: 9,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),

                                /// CHECKMARK
                                if (isSelected)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            /// BOTÃO SALVAR
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selected);
                  },
                  child: const Text("Salvar Favoritos"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}