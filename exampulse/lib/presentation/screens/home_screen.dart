import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. SINAV TARİHİ AYARI (Burayı değiştirebilirsin)
    // Yıl: 2025, Ay: 6 (Haziran), Gün: 21 (Tahmini TYT)
    final DateTime examDate = DateTime(2026, 6, 20);
    
    // 2. HESAPLAMA MOTORU
    final DateTime today = DateTime.now();
    // Farkı alıp gün cinsine çeviriyoruz
    final int daysLeft = examDate.difference(today).inDays;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello, Student! 👋",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Let's check your progress.",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              
              // 3. DİNAMİK KART
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
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "YKS 2025 (TYT)",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "$daysLeft", // BURASI ARTIK OTOMATİK!
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Days Left",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 4. ALT MENÜ (Hesap Makinesi Butonları)
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMenuCard(
                      icon: Icons.calculate_outlined,
                      title: "Score\nCalculator",
                      color: AppColors.primary,
                      onTap: () {
                        // Tıklanınca ne olacak? (Birazdan yapacağız)
                        print("Hesaplayıcıya tıklandı");
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.history,
                      title: "My\nHistory",
                      color: AppColors.surface,
                      onTap: () {
                         print("Geçmişe tıklandı");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color == AppColors.primary ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: color == AppColors.surface 
              ? Border.all(color: Colors.white10) 
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              size: 40, 
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}