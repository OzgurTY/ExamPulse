import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/preferences_service.dart';
import 'settings_screen.dart'; // Ayarlar sayfasını import et

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Öğrenci";
  int daysLeft = 0;
  // Varsayılan hedef (Eğer kullanıcı seçmezse)
  DateTime targetDate = DateTime(2026, 6, 20); 

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Verileri çekme fonksiyonu
  Future<void> _loadUserData() async {
    final prefs = PreferencesService();
    final name = await prefs.getUserName();
    final date = await prefs.getExamDate();

    setState(() {
      if (name != null && name.isNotEmpty) userName = name;
      if (date != null) targetDate = date;
      
      // Gün Farkını Hesapla
      final today = DateTime.now();
      // Saat farkını yoksaymak için sadece tarih kısımlarını alabiliriz ama şimdilik direkt fark alalım
      daysLeft = targetDate.difference(today).inDays;
      // Eğer negatifse (sınav geçtiyse) 0 göster
      if (daysLeft < 0) daysLeft = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ÜST KISIM (Header + Ayarlar İkonu)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Merhaba, $userName! 👋", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text("Bugün hedeflerine odaklan.", style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14)),
                    ],
                  ),
                  // AYARLAR BUTONU
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.settings, color: AppColors.primary),
                      onPressed: () async {
                        // Ayarlara git ve dönünce verileri yenile
                        bool? result = await Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const SettingsScreen())
                        );
                        if (result == true) {
                          _loadUserData(); // Ekranı yenile
                        }
                      },
                    ),
                  )
                ],
              ),
              
              const SizedBox(height: 32),
              
              // GERİ SAYIM KARTI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF2B48D9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Büyük Sınava", style: GoogleFonts.poppins(color: Colors.white70, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("$daysLeft", style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, height: 1, color: Colors.white)),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("Gün Kaldı", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white.withOpacity(0.9))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              // İSTATİSTİK ÖZETİ (Sabit Placeholder)
              Text("Günün Özeti", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                      child: const Icon(Icons.trending_up, color: Colors.green, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("İstikrarlı Gidiyorsun!", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("Düzenli deneme çözmek başarıyı getirir.", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}