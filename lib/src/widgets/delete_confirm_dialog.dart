import 'package:flutter/material.dart';

Future<bool?> showDeleteConfirmDialog(BuildContext context) {

  return showDialog<bool>(

    context: context,

    barrierDismissible: true,

    builder: (context) {

      return AlertDialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Ícone de alerta
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 28,
              ),
            ),

            const SizedBox(height: 16),

            /// Título
            const Text(
              "Excluir Card",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// Texto
            const Text(
              "Deseja mesmo excluir este card?\nEssa ação não pode ser desfeita.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            /// Botões
            Row(
              children: [

                /// CANCELAR
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text("Cancelar"),
                  ),
                ),

                const SizedBox(width: 8),

                /// EXCLUIR
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text("Excluir"),
                  ),
                ),

              ],
            )

          ],
        ),
      );
    },
  );
}