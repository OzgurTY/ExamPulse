import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Tarih formatı için
import '../../core/constants/app_colors.dart';
import '../../core/services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Deneme Geçmişim",
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          // Opsiyonel: Temizleme butonu
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () async {
              await _storageService.clearHistory();
              setState(() {}); // Ekranı yenile
            },
          )
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _storageService.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

          final historyList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              // Veri formatı: "2025-06-21... # 350.5 # 65.5"
              final parts = historyList[index].split('#');
              final dateStr = parts[0];
              final score = double.parse(parts[1]).toStringAsFixed(2);
              final net = double.parse(parts[2]).toStringAsFixed(2);

              // Tarihi güzelleştirme (Örn: 12 Oct 2025 - 14:30)
              final DateTime date = DateTime.parse(dateStr);
              final formattedDate = DateFormat('d MMM yyyy - HH:mm').format(date);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Sol Taraf: Tarih ve Etiket
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TYT Denemesi",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    // Sağ Taraf: Puan ve Net
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "$score Puan",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                        ),
                        Text(
                          "$net Net",
                          style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}