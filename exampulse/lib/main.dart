import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const ExamPulseApp());
}

class ExamPulseApp extends StatelessWidget {
  const ExamPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ExamPulse',
      theme: ThemeData(
        useMaterial3: true,
        // Tüm uygulamaya Google Font uyguluyoruz
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}