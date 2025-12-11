import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'score_calculator_screen.dart'; // EKLENDİ: Sayfayı tanıttık
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ... (Tarih ve sayaç kodları aynı kalacak) ...
    final DateTime examDate = DateTime(2026, 6, 20);
    final DateTime today = DateTime.now();
    final int daysLeft = examDate.difference(today).inDays;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (Başlık ve üst kısım kodları aynı) ...
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
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 32),
              
              // ... (Sayaç Kartı aynı) ...
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
                    const Text("YKS 2025 (TYT)", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("$daysLeft", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, height: 1, color: Colors.white)),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("Days Left", style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 4. ALT MENÜ - GÜNCELLENDİ
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMenuCard(
                      context, // Context'i buraya gönderiyoruz
                      icon: Icons.calculate_outlined,
                      title: "Score\nCalculator",
                      color: AppColors.primary,
                      onTap: () {
                        // DÜZELTME: Navigasyon eklendi
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScoreCalculatorScreen()),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.history,
                      title: "My\nHistory",
                      color: AppColors.surface,
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
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

  // Helper Widget'ı Context alacak şekilde güncelledik
  Widget _buildMenuCard(
    BuildContext context, {
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
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}