import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart'; // Renk dosyanın yolu

class ScoreInputCard extends StatelessWidget {
  final String lessonName;
  final TextEditingController correctController;
  final TextEditingController wrongController;

  const ScoreInputCard({
    super.key,
    required this.lessonName,
    required this.correctController,
    required this.wrongController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), // Hafif saydam arka plan
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ders İsmi
          Expanded(
            flex: 2,
            child: Text(
              lessonName,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Doğru Sayısı Girişi
          _buildInputBox(correctController, "D", Colors.greenAccent),
          const SizedBox(width: 10),
          // Yanlış Sayısı Girişi
          _buildInputBox(wrongController, "Y", Colors.redAccent),
        ],
      ),
    );
  }

  // Küçük input kutucuğu tasarım metodu
  Widget _buildInputBox(TextEditingController controller, String hint, Color color) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(bottom: 8),
          ),
        ),
      ),
    );
  }
}