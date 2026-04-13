import 'package:flutter/material.dart';
import '../models/car.dart';


// MODAL PARA SELECAO DE CARRO FAVORITO, EXIBE APENAS OS CARROS PREENCHIDOS COM IMAGEM, PERMITE BUSCA POR NOME E EXIBE UM INDICADOR VISUAL DO CARRO FAVORITO ATUAL
Future<CarItem?> showFavoriteCarModal(
  BuildContext context, {
  required List<CarItem> cars,
  String? currentFavoriteId,
}) {
  return showDialog<CarItem>(
    context: context,
    builder: (_) => _FavoriteCarModal(
      cars: cars,
      currentFavoriteId: currentFavoriteId,
    ),
  );
}

// WIDGET DE MODAL DE SELECAO DE CARRO FAVORITO, RESPONSAVEL POR EXIBIR A LISTA DE CARROS PREENCHIDOS, PERMITIR FILTRAGEM POR NOME E SELECAO DO CARRO FAVORITO, RETORNANDO O CARRO SELECIONADO PARA O CHAMADOR
class _FavoriteCarModal extends StatefulWidget {
  final List<CarItem> cars;
  final String? currentFavoriteId;

  const _FavoriteCarModal({
    required this.cars,
    this.currentFavoriteId,
  });

  @override
  State<_FavoriteCarModal> createState() => _FavoriteCarModalState();
}

class _FavoriteCarModalState extends State<_FavoriteCarModal> {
  final TextEditingController searchController = TextEditingController();

  List<CarItem> filtered = [];

  @override
  void initState() {
    super.initState();

    /// apenas carros preenchidos
    filtered = widget.cars
        .where((c) => !c.isEmpty && c.imageUrl != null)
        .toList();

    searchController.addListener(_filter);
  }

  void _filter() {
    final query = searchController.text.toLowerCase();

    final filledCars =
        widget.cars.where((c) => !c.isEmpty && c.imageUrl != null).toList();

    setState(() {
      if (query.isEmpty) {
        filtered = filledCars;
      } else {
        filtered = filledCars
            .where((c) => c.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

// metodo de dispose do estado, utilizado para liberar os recursos do controlador de texto quando o modal for fechado, evitando vazamentos de memoria
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
        height: 480,
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    "Carro Favorito",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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

            /// LISTA
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        filledCars.isEmpty
                            ? "Nenhum carro na coleção ainda"
                            : "Nenhum resultado",
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final car = filtered[index];

                        final isSelected =
                            widget.currentFavoriteId == car.id;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, car);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                              color: isSelected
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                /// FOTO
                                Container(
                                  width: 48,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: car.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Image.network(
                                            car.imageUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.image),
                                ),

                                const SizedBox(width: 12),

                                /// INFO
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        car.name.isEmpty
                                            ? "Sem nome"
                                            : car.name,
                                        style: const TextStyle(
                                            fontSize: 13),
                                      ),
                                      if (car.description.isNotEmpty)
                                        Text(
                                          car.description,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),

                                if (isSelected)
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}