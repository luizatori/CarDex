import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; 
import '../providers/theme_provider.dart';

class FilterDropdown extends StatelessWidget {
  final String label;

  const FilterDropdown({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    
    final isDark = context.watch<ThemeProvider>().isDark;

    return InkWell(
      onTap: () {
      },
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isDark 
                ? Colors.white.withOpacity(0.15) 
                : Colors.black.withOpacity(0.2), 
          ),
          color: isDark 
              ? const Color(0xFF1E1E1E) 
              : Colors.white.withOpacity(0.9), 
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          mainAxisSize: MainAxisSize.min,
          children: [

            
            /// TEXTO
            Text(
              label.toUpperCase(),
              style: GoogleFonts.ibmPlexMono(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.1,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),

            const SizedBox(width: 8),

            /// SETA
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}