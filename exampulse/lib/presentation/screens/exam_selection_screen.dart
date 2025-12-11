import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'score_calculator_screen.dart'; // TYT
import 'ayt_calculator_screen.dart';   // AYT
import 'yks_calculator_screen.dart';

class ExamSelectionScreen extends StatelessWidget {
  const ExamSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Sınav Seçimi", style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Geri butonunu kaldır (Tab yapısında gerek yok)
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Hangi sınavı hesaplamak istersin?",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            // TYT Butonu
            _buildExamCard(
              context,
              title: "TYT Hesapla",
              subtitle: "Temel Yeterlilik Testi",
              icon: Icons.edit_note,
              color1: Colors.blueAccent,
              color2: Colors.lightBlueAccent,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScoreCalculatorScreen())),
            ),
            
            const SizedBox(height: 16),
            
            // AYT Butonu
            _buildExamCard(
              context,
              title: "AYT Hesapla",
              subtitle: "Alan Yeterlilik Testi (SAY/EA/SÖZ)",
              icon: Icons.functions,
              color1: Colors.indigo,
              color2: Colors.purpleAccent,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AytCalculatorScreen())),
            ),

            const SizedBox(height: 16),

            // (YKS)
            _buildExamCard(
              context,
              title: "YKS Puanı (Full)",
              subtitle: "TYT + AYT + OBP Hesapla",
              icon: Icons.school,
              color1: Colors.deepPurple,      
              color2: Colors.deepPurpleAccent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const YksCalculatorScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color1, color2], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color1.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
          ],
        ),
      ),
    );
  }
}