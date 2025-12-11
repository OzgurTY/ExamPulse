import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/exam_result.dart';
import '../../core/services/storage_service.dart';
import '../widgets/progress_chart.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storageService = StorageService();

  // YENİ: Seçili Filtre Durumu
  String _selectedFilter = "Tümü"; // Varsayılan hepsi
  final List<String> _filters = ["Tümü", "TYT", "AYT", "YKS"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Deneme Geçmişim",
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Başlığı ortaladık
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
            onPressed: () => _showClearDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. FİLTRE ÇİPLERİ (YENİ)
          _buildFilterChips(),

          // 2. LİSTE VE GRAFİK (Expanded içinde)
          Expanded(
            child: FutureBuilder<List<ExamResult>>(
              future: _storageService.getHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                // HAM VERİYİ AL
                List<ExamResult> allResults = snapshot.data!;

                // FİLTRELEME MANTIĞI
                List<ExamResult> filteredList = allResults.where((result) {
                  if (_selectedFilter == "Tümü") return true;
                  // Örn: "AYT-SAY" içinde "AYT" geçiyor mu?
                  return result.examType.contains(_selectedFilter);
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      "Bu kategoride kayıt yok.",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  );
                }

                // GRAFİK VERİSİ HAZIRLAMA (Filtrelenmiş listeden)
                List<double> chartScores = filteredList
                    .map((e) => e.score)
                    .toList()
                    .reversed
                    .toList();

                return Column(
                  children: [
                    // A. GRAFİK (Filtreye göre değişir)
                    if (chartScores.length > 1) // Tek nokta varsa grafik çizme
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$_selectedFilter Gelişim Grafiği",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ProgressChart(scores: chartScores),
                          ],
                        ),
                      ),

                    // B. LİSTE
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final result = filteredList[index];
                          return _buildHistoryCard(result);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- YENİ WIDGETLAR ---

  // Filtre Butonları
  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(filter),
              // Yazı Rengi: Seçiliyse BEYAZ, Değilse KOYU GRİ (Net görünür)
              labelStyle: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              selected: isSelected,
              // Seçili Rengi: Ana Renk (Lacivert)
              selectedColor: AppColors.primary,
              // Seçili Olmayan Rengi: Açık Gri (Beyaz zeminde belli olsun diye)
              backgroundColor: Colors.grey.shade200,
              // Kenarlık: Seçili değilse ince bir çizgi ekleyelim
              side: isSelected
                  ? BorderSide.none
                  : BorderSide(color: Colors.grey.shade300),
              onSelected: (bool selected) {
                if (selected) {
                  setState(() => _selectedFilter = filter);
                }
              },
            ),
          );
        },
      ),
    );
  }

  // Boş Durum
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "Henüz kayıtlı deneme yok.",
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Kart Tasarımı (Öncekiyle aynı ama metodlaştırıldı)
  Widget _buildHistoryCard(ExamResult result) {
    final formattedDate = DateFormat('d MMM yyyy - HH:mm').format(result.date);

    // Renk Kodlaması
    Color cardColor = Colors.white;
    if (result.examType.contains("TYT")) cardColor = Colors.indigo.shade50;
    if (result.examType.contains("SAY")) cardColor = Colors.blue.shade50;
    if (result.examType.contains("EA")) cardColor = Colors.orange.shade50;
    if (result.examType.contains("SÖZ")) cardColor = Colors.pink.shade50;

    return Dismissible(
      key: Key(result.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      onDismissed: (direction) async {
        await _storageService.deleteResult(result.id);
        setState(() {}); // Ekranı yenile
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.5)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${result.examType} Sonucu",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${result.score.toStringAsFixed(2)} Puan",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    if (result.estimatedRanking != null)
                      Text(
                        "#${result.estimatedRanking}", // Örn: #45000
                        style: GoogleFonts.poppins(
                          color: Colors.amber[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    else
                      // Eski kayıtlarda sıralama yoksa Net göster
                      Text(
                        "${result.totalNet} Net",
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            children: [
              const Divider(),
              const SizedBox(height: 8),
              result.scoreBreakdown != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailScore(
                          "SAY",
                          result.scoreBreakdown?["SAY"] ?? 0,
                          Colors.blue,
                        ),
                        _buildDetailScore(
                          "EA",
                          result.scoreBreakdown?["EA"] ?? 0,
                          Colors.orange,
                        ),
                        _buildDetailScore(
                          "SÖZ",
                          result.scoreBreakdown?["SÖZ"] ?? 0,
                          Colors.pink,
                        ),
                      ],
                    )
                  : Text(
                      "Detay yok.",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailScore(String label, double score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            score.toStringAsFixed(2),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tümünü Sil"),
        content: const Text("Tüm geçmişin silinecek. Emin misin?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              await _storageService.clearHistory();
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text("Sil", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
