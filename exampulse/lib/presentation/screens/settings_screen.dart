import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  final PreferencesService _prefsService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Mevcut verileri yükle
  Future<void> _loadData() async {
    final name = await _prefsService.getUserName();
    final date = await _prefsService.getExamDate();
    setState(() {
      _nameController.text = name ?? "";
      _selectedDate = date;
    });
  }

  // Kaydet
  Future<void> _save() async {
    if (_nameController.text.isNotEmpty) {
      await _prefsService.saveUserName(_nameController.text);
    }
    if (_selectedDate != null) {
      await _prefsService.saveExamDate(_selectedDate!);
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ayarlar kaydedildi! ✅"), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true); // Geri dönerken 'true' gönder (sayfayı yenilemek için)
    }
  }

  // Tarih Seçici
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 100)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      // Takvimi Türkçe Zorla (Pazartesi ile başlar)
      locale: const Locale('tr', 'TR'), 
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary, // Takvim başlık rengi
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Ayarlar", style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kişisel Bilgiler", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 20),
            
            // İsim Alanı
            TextField(
              controller: _nameController,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "Adın Nedir?", // <-- DEĞİŞTİ (labelText idi)
                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Çizgiyi kaldırdık, daha modern
                ),
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white, // Beyaz kutu
                // Hafif gölge efekti vermek istersen Container içine alabilirsin, 
                // ama şu anki haliyle temiz duracaktır.
              ),
            ),
            const SizedBox(height: 20),

            // Tarih Seçimi
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate == null 
                          ? "Sınav Tarihini Seç" 
                          : DateFormat('d MMMM yyyy').format(_selectedDate!),
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),

            // Kaydet Butonu
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text("KAYDET", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}