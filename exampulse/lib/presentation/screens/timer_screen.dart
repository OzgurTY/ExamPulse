import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  
  // Varsayılan: TYT (165 dakika)
  int _initialMinutes = 165; 
  late int _remainingSeconds;
  bool _isRunning = false;
  String _selectedMode = "TYT"; // TYT, AYT, ODAK

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _initialMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Mod Değiştirme
  void _changeMode(String mode, int minutes) {
    setState(() {
      _selectedMode = mode;
      _initialMinutes = minutes;
      _remainingSeconds = minutes * 60;
      _isRunning = false;
    });
    _timer?.cancel();
  }

  // Başlat / Duraklat
  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          _timer?.cancel();
          setState(() => _isRunning = false);
          // Süre bittiğinde yapılacaklar (Bildirim vs.)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Süre Doldu!  kalemleri bırakalım. ✏️")),
          );
        }
      });
    }
  }

  // Sıfırla
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _initialMinutes * 60;
    });
  }

  // Zaman Formatı (02:45:30)
  String get _timerText {
    int hours = _remainingSeconds ~/ 3600;
    int minutes = (_remainingSeconds % 3600) ~/ 60;
    int seconds = _remainingSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // İlerleme Oranı (0.0 - 1.0 arası)
  double get _progress {
    return _remainingSeconds / (_initialMinutes * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Sınav Modu", style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Mod Seçimi
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                _buildModeBtn("TYT", 165),
                _buildModeBtn("AYT", 180),
                _buildModeBtn("POMODORO", 25), // Bonus Odak Modu
              ],
            ),
          ),

          const Spacer(),

          // 2. Dairesel Sayaç
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
                child: CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _progress < 0.1 ? Colors.red : AppColors.primary,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _timerText,
                    style: GoogleFonts.chivoMono( // Monospaced font daha iyi durur (yoksa Poppins de olur)
                      fontSize: 48, 
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _isRunning ? "Odaklan" : "Hazır",
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // 3. Kontrol Butonları
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reset
              FloatingActionButton(
                heroTag: "reset",
                onPressed: _resetTimer,
                backgroundColor: Colors.white,
                foregroundColor: Colors.redAccent,
                elevation: 2,
                child: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 24),
              // Play / Pause (Büyük)
              SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  heroTag: "play",
                  onPressed: _toggleTimer,
                  backgroundColor: _isRunning ? Colors.orangeAccent : AppColors.primary,
                  elevation: 4,
                  child: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 40),
                ),
              ),
              const SizedBox(width: 24),
              // Bitir (Opsiyonel)
              FloatingActionButton(
                heroTag: "stop",
                onPressed: () {
                   _timer?.cancel();
                   setState(() => _isRunning = false);
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sınav erken bitirildi.")));
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey,
                elevation: 2,
                child: const Icon(Icons.stop),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildModeBtn(String title, int minutes) {
    bool isSelected = _selectedMode == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => _changeMode(title, minutes),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}