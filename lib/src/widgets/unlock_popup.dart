import 'package:flutter/material.dart';

Future<String?> showUnlockPopup(
  BuildContext context, {
  required List<String> items,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return _UnlockPopup(items: items);
    },
  );
}

class _UnlockPopup extends StatefulWidget {
  final List<String> items;

  const _UnlockPopup({
    required this.items,
  });

  @override
  State<_UnlockPopup> createState() => _UnlockPopupState();
}

class _UnlockPopupState extends State<_UnlockPopup> {
  final TextEditingController searchController = TextEditingController();

  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;

    searchController.addListener(_filter);
  }

  void _filter() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 320,
        height: 420,
        child: Column(
          children: [
            /// TOPO
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Buscar moldura...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const Divider(height: 1),

            /// LISTA
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];

                  return ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text(item),
                    onTap: () {
                      Navigator.pop(context, item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}