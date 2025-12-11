import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/exam_result.dart';
import '../../core/services/storage_service.dart';
import '../widgets/score_input_card.dart';
import '../../core/services/ranking_service.dart';

class YksCalculatorScreen extends StatefulWidget {
  const YksCalculatorScreen({super.key});

  @override
  State<YksCalculatorScreen> createState() => _YksCalculatorScreenState();
}

class _YksCalculatorScreenState extends State<YksCalculatorScreen> {
  // --- TYT CONTROLLERS ---
  final tytTurkceD = TextEditingController();
  final tytTurkceY = TextEditingController();
  final tytMatD = TextEditingController();
  final tytMatY = TextEditingController();
  final tytSosyalD = TextEditingController();
  final tytSosyalY = TextEditingController();
  final tytFenD = TextEditingController();
  final tytFenY = TextEditingController();

  // --- AYT CONTROLLERS ---
  final aytMatD = TextEditingController();
  final aytMatY = TextEditingController();
  final aytFenD = TextEditingController();
  final aytFenY = TextEditingController();
  final aytEdbSos1D = TextEditingController();
  final aytEdbSos1Y = TextEditingController();
  final aytSos2D = TextEditingController();
  final aytSos2Y = TextEditingController();

  // --- OBP (Okul Puanı) ---
  final obpController = TextEditingController();

  // Sonuçlar
  double resultSAY = 0;
  double resultEA = 0;
  double resultSOZ = 0;
  String selectedType = "SAY"; // Varsayılan gösterim

  void calculateYKS() {
    FocusScope.of(context).unfocus();

    // Yardımcı Net Hesaplayıcı
    double calcNet(TextEditingController c, TextEditingController w) {
      double d = double.tryParse(c.text) ?? 0;
      double y = double.tryParse(w.text) ?? 0;
      return d - (y / 4);
    }

    // 1. TYT Netleri
    double netTytTurkce = calcNet(tytTurkceD, tytTurkceY);
    double netTytMat = calcNet(tytMatD, tytMatY);
    double netTytSos = calcNet(tytSosyalD, tytSosyalY);
    double netTytFen = calcNet(tytFenD, tytFenY);
    double totalNetTYT = netTytTurkce + netTytMat + netTytSos + netTytFen;

    // 2. AYT Netleri
    double netAytMat = calcNet(aytMatD, aytMatY);
    double netAytFen = calcNet(aytFenD, aytFenY);
    double netAytEdbSos1 = calcNet(aytEdbSos1D, aytEdbSos1Y);
    double netAytSos2 = calcNet(aytSos2D, aytSos2Y);
    double totalNetAYT = netAytMat + netAytFen + netAytEdbSos1 + netAytSos2;

    // 3. OBP Hesapla (Varsayılan 0)
    double obp = double.tryParse(obpController.text) ?? 0;
    double obpContribution = obp * 0.6; // OBP'nin 0.6'sı eklenir

    // 4. PUAN HESAPLAMA (Temsili Formül)
    // TYT Ham Puan (Yaklaşık)
    double rawTYT = 100 + (totalNetTYT * 3.3);
    
    // AYT Ham Puanlar (Yaklaşık)
    double rawAYT_SAY = 100 + (netAytMat * 3) + (netAytFen * 2.8);
    double rawAYT_EA = 100 + (netAytMat * 3) + (netAytEdbSos1 * 2.8);
    double rawAYT_SOZ = 100 + (netAytEdbSos1 * 3) + (netAytSos2 * 2.8);

    // YERLEŞTİRME PUANI: (TYT %40) + (AYT %60) + OBP
    setState(() {
      resultSAY = (rawTYT * 0.4) + (rawAYT_SAY * 0.6) + obpContribution;
      resultEA = (rawTYT * 0.4) + (rawAYT_EA * 0.6) + obpContribution;
      resultSOZ = (rawTYT * 0.4) + (rawAYT_SOZ * 0.6) + obpContribution;
    });

    // Kayıt İçin Seçilen Puan
    double finalScore = (selectedType == "SAY") ? resultSAY : (selectedType == "EA" ? resultEA : resultSOZ);

    int ranking = RankingService.calculateRanking(finalScore, selectedType);

    // 5. KAYDETME
    final result = ExamResult(
      id: const Uuid().v4(),
      date: DateTime.now(),
      examType: "YKS-$selectedType", // Örn: YKS-SAY
      score: finalScore,
      totalNet: totalNetTYT + totalNetAYT, // Toplam Net (TYT+AYT)
      lessonNets: {
        "TYT-TR": netTytTurkce,
        "TYT-Mat": netTytMat,
        "AYT-Mat": netAytMat,
        "AYT-Fen": netAytFen,
        // Diğer dersler de eklenebilir...
      },
      scoreBreakdown: {
        "SAY": resultSAY,
        "EA": resultEA,
        "SÖZ": resultSOZ,
      },
      estimatedRanking: ranking,
    );

    StorageService().saveResult(result);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("YKS Sonucu Kaydedildi! 🏆"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // TYT ve AYT Sekmeleri
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text("YKS Simülasyonu", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "TYT Bölümü"),
              Tab(text: "AYT Bölümü"),
            ],
          ),
        ),
        body: Column(
          children: [
            // 1. SONUÇ ALANI (Sabit Üst Kısım)
            _buildResultHeader(),

            // 2. TABLAR (Ders Girişleri)
            Expanded(
              child: TabBarView(
                children: [
                  // TYT TAB
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ScoreInputCard(lessonName: "TYT Türkçe", correctController: tytTurkceD, wrongController: tytTurkceY),
                        ScoreInputCard(lessonName: "TYT Matematik", correctController: tytMatD, wrongController: tytMatY),
                        ScoreInputCard(lessonName: "TYT Sosyal", correctController: tytSosyalD, wrongController: tytSosyalY),
                        ScoreInputCard(lessonName: "TYT Fen", correctController: tytFenD, wrongController: tytFenY),
                        const SizedBox(height: 20),
                        // OBP Girişi Sadece Burada Olsun
                        _buildObpInput(),
                      ],
                    ),
                  ),

                  // AYT TAB
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ScoreInputCard(lessonName: "AYT Matematik", correctController: aytMatD, wrongController: aytMatY),
                        ScoreInputCard(lessonName: "AYT Fen Bil.", correctController: aytFenD, wrongController: aytFenY),
                        ScoreInputCard(lessonName: "AYT Edb-Sos1", correctController: aytEdbSos1D, wrongController: aytEdbSos1Y),
                        ScoreInputCard(lessonName: "AYT Sosyal-2", correctController: aytSos2D, wrongController: aytSos2Y),
                        const SizedBox(height: 20),
                        // Hesapla Butonu (AYT sekmesinde)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: calculateYKS,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text("YKS PUANI HESAPLA", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultHeader() {
    double currentScore = (selectedType == "SAY" ? resultSAY : (selectedType == "EA" ? resultEA : resultSOZ));
    int currentRank = RankingService.calculateRanking(currentScore, selectedType);
    String formattedRank = currentRank.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.indigoAccent]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ["SAY", "EA", "SÖZ"].map((type) {
              return GestureDetector(
                onTap: () => setState(() => selectedType = type),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: selectedType == type ? Colors.white : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    type,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: selectedType == type ? Colors.indigo : Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            "YERLEŞTİRME PUANI",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
          Text(
            currentScore.toStringAsFixed(3),
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Tahmini Sıralama: $formattedRank", // 12.500 gibi
              style: GoogleFonts.poppins(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),  
        ],
      ),
    );
  }

  Widget _buildObpInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(child: Text("Diploma Notu (OBP)", style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
          SizedBox(
            width: 80,
            child: TextField(
              controller: obpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: "0-100", border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }
}