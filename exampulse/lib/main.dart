import 'package:exampulse/presentation/screens/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      // --- YENİ EKLENEN KISIM BAŞLANGICI ---
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'), // Sadece Türkçe destekle
      ],
      locale: const Locale('tr', 'TR'), // Varsayılanı Türkçe yap
      // --- YENİ EKLENEN KISIM BİTİŞİ ---
      
      home: const MainWrapper(),
    );
  }
}