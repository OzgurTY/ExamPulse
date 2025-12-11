import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart'; // ID üretmek için gerekli
import '../../core/constants/app_colors.dart';
import '../../core/models/exam_result.dart'; // Model
import '../../core/services/storage_service.dart';
import '../widgets/score_input_card.dart';

class AytCalculatorScreen extends StatefulWidget {
  const AytCalculatorScreen({super.key});

  @override
  State<AytCalculatorScreen> createState() => _AytCalculatorScreenState();
}

class _AytCalculatorScreenState extends State<AytCalculatorScreen> {
  // --- Controller Tanımları ---
  final matD = TextEditingController();
  final matY = TextEditingController();
  final fenD = TextEditingController();
  final fenY = TextEditingController();
  final edbSos1D = TextEditingController();
  final edbSos1Y = TextEditingController();
  final sos2D = TextEditingController();
  final sos2Y = TextEditingController();

  // Sonuç Değişkenleri
  double scoreSAY = 0;
  double scoreEA = 0;
  double scoreSOZ = 0;
  
  // Seçili Puan Türü
  String selectedScoreType = "SAY"; 

  void calculate() {
    FocusScope.of(context).unfocus(); // Klavyeyi kapat

    // Yardımcı Net Hesaplayıcı
    double calcNet(TextEditingController c, TextEditingController w) {
      double d = double.tryParse(c.text) ?? 0;
      double y = double.tryParse(w.text) ?? 0;
      return d - (y / 4);
    }

    double netMat = calcNet(matD, matY);
    double netFen = calcNet(fenD, fenY);
    double netEdbSos1 = calcNet(edbSos1D, edbSos1Y);
    double netSos2 = calcNet(sos2D, sos2Y);

    // --- Basit Hesaplama Mantığı (Temsili Katsayılar) ---
    // Not: Gerçek formülde TYT puanının %40'ı eklenir. Şimdilik sabit +150 veriyoruz.
    setState(() {
      scoreSAY = 100 + (netMat * 3) + (netFen * 2.8) + 150;
      scoreEA = 100 + (netMat * 3) + (netEdbSos1 * 2.8) + 150;
      scoreSOZ = 100 + (netEdbSos1 * 3) + (netSos2 * 2.8) + 150;
    });
    
    // Kaydedilecek final değerleri belirle
    double finalScore = (selectedScoreType == "SAY") ? scoreSAY : (selectedScoreType == "EA" ? scoreEA : scoreSOZ);
    double finalNet = netMat + netFen + netEdbSos1 + netSos2;

    // --- YENİ KAYIT MANTIĞI (Model Kullanımı) ---
    final result = ExamResult(
      id: const Uuid().v4(), // Benzersiz ID üret
      date: DateTime.now(),
      examType: "AYT-$selectedScoreType",
      score: finalScore,
      totalNet: finalNet,
      lessonNets: {
        "Matematik": netMat,
        "Fen": netFen,
        "Edb-Sos1": netEdbSos1,
        "Sos-2": netSos2,
      },
    );

    StorageService().saveResult(result);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sonuç kaydedildi!"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    double displayScore = (selectedScoreType == "SAY") ? scoreSAY : (selectedScoreType == "EA" ? scoreEA : scoreSOZ);

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("AYT Hesapla"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. SEGMENTED CONTROL (SAY / EA / SÖZ)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: ["SAY", "EA", "SÖZ"].map((type) {
                  bool isSelected = selectedScoreType == type;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedScoreType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          type,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppColors.primary : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // 2. SONUÇ KARTI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6B8EFF), Color(0xFFFF8FB1)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text("TAHMİNİ AYT ($selectedScoreType)", style: const TextStyle(color: Colors.white70)),
                  Text(
                    displayScore.toStringAsFixed(2),
                    style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. DERS GİRİŞLERİ
            ScoreInputCard(lessonName: "Matematik", correctController: matD, wrongController: matY),
            ScoreInputCard(lessonName: "Fen Bilimleri", correctController: fenD, wrongController: fenY),
            ScoreInputCard(lessonName: "T. Dili ve Edb. - Sos1", correctController: edbSos1D, wrongController: edbSos1Y),
            ScoreInputCard(lessonName: "Sosyal Bilimler-2", correctController: sos2D, wrongController: sos2Y),

            const SizedBox(height: 20),

            // 4. HESAPLA BUTONU
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: calculate,
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