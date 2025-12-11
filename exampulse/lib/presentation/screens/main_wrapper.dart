import 'package:exampulse/presentation/screens/subject_tracker_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'home_screen.dart';
import 'exam_selection_screen.dart';
import 'history_screen.dart';
import 'timer_screen.dart'; // Yeni ekranı import et

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // Sayfalar Listesi
  final List<Widget> _pages = [
    const HomeScreen(),
    const ExamSelectionScreen(),
    const TimerScreen(),  // 3. Sıraya Kronometreyi koyduk
    const SubjectTrackerScreen(),
    const HistoryScreen(), // 4. Sıraya Geçmiş kaydı
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ÖNEMLİ DEĞİŞİKLİK: IndexedStack
      // Bu widget, sayfaları hafızada canlı tutar, sadece görünürlüğünü değiştirir.
      // Böylece kronometre arka planda çalışmaya devam eder.
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              activeIcon: Icon(Icons.calculate),
              label: 'Hesapla',
            ),
            // YENİ BUTON
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              activeIcon: Icon(Icons.timer),
              label: 'Kronometre',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              activeIcon: Icon(Icons.check_circle),
              label: 'Konular',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Geçmiş',
            ),
          ],
        ),
      ),
    );
  }
}