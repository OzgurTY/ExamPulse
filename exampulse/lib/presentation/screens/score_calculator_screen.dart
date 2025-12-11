import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/score_input_card.dart';
import '../../core/services/storage_service.dart';

class ScoreCalculatorScreen extends StatefulWidget {
  const ScoreCalculatorScreen({super.key});

  @override
  State<ScoreCalculatorScreen> createState() => _ScoreCalculatorScreenState();
}

class _ScoreCalculatorScreenState extends State<ScoreCalculatorScreen> {
  // Controller tanımları
  final tytTurkceD = TextEditingController();
  final tytTurkceY = TextEditingController();
  final tytMatD = TextEditingController();
  final tytMatY = TextEditingController();
  final tytSosyalD = TextEditingController();
  final tytSosyalY = TextEditingController();
  final tytFenD = TextEditingController();
  final tytFenY = TextEditingController();

  double totalScore = 0.0;
  double totalNet = 0.0;

  void calculateScore() {
    FocusScope.of(context).unfocus();
    // Yardımcı net hesaplama fonksiyonu
    double calcNet(TextEditingController correct, TextEditingController wrong) {
      double d = double.tryParse(correct.text) ?? 0;
      double y = double.tryParse(wrong.text) ?? 0;
      return d - (y / 4);
    }

    double netTurkce = calcNet(tytTurkceD, tytTurkceY);
    double netMat = calcNet(tytMatD, tytMatY);
    double netSosyal = calcNet(tytSosyalD, tytSosyalY);
    double netFen = calcNet(tytFenD, tytFenY);

    // Basit TYT Formülü (Örnek katsayılar)
    setState(() {
      totalNet = netTurkce + netMat + netSosyal + netFen;
      // Taban puan 100 + (Net * Ortalama 3.3 puan)
      totalScore = 100 + (totalNet * 3.3); 

      StorageService().saveResult(totalScore, totalNet);
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sonuç geçmişe kaydedildi! 📝"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Lacivert tema
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Puan Hesapla", style: GoogleFonts.poppins(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Sonuç Kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text("TAHMİNİ TYT PUANI", style: GoogleFonts.poppins(color: Colors.white70)),
                  Text(
                    totalScore.toStringAsFixed(2),
                    style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text("Toplam Net: ${totalNet.toStringAsFixed(2)}", style: GoogleFonts.poppins(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Ders Girişleri
            ScoreInputCard(lessonName: "Türkçe (40)", correctController: tytTurkceD, wrongController: tytTurkceY),
            ScoreInputCard(lessonName: "Matematik (40)", correctController: tytMatD, wrongController: tytMatY),
            ScoreInputCard(lessonName: "Sosyal Bil. (20)", correctController: tytSosyalD, wrongController: tytSosyalY),
            ScoreInputCard(lessonName: "Fen Bil. (20)", correctController: tytFenD, wrongController: tytFenY),

            const SizedBox(height: 20),

            // Hesapla Butonu
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: calculateScore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text("HESAPLA", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}