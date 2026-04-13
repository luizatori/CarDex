import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; 
import '../providers/theme_provider.dart';

// WIDGET DE DROPDOWN DE FILTRO, RESPONSAVEL POR EXIBIR O NOME DO FILTRO ATIVO E UM ICON DE SETA PARA BAIXO, COM ESTILO COERENTE COM O RESTANTE DO APP, INDICANDO VISUALMENTE QUAL FILTRO ESTA ATIVO
class FilterDropdown extends StatelessWidget {
  final String label;
  final bool isSelected; 

  const FilterDropdown({
    super.key,
    required this.label,
    this.isSelected = false, 
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    final activeColor = isDark ? const Color.fromARGB(255, 122, 121, 121) : const Color.fromARGB(255, 119, 118, 118);
    final borderColor = isSelected 
        ? activeColor 
        : (isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.2));

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: borderColor,
          width: isSelected ? 1.5 : 1.0,
        ),
        color: isDark 
            ? const Color(0xFF1E1E1E) 
            : Colors.white.withOpacity(0.9), 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, 
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.ibmPlexMono(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 1.1,
              color: isSelected 
                  ? activeColor 
                  : (isDark ? Colors.white70 : Colors.black87),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: isSelected ? activeColor : (isDark ? Colors.white38 : Colors.black38),
          ),
        ],
      ),
    );
  }
}