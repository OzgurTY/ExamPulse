import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyUserName = 'user_name';
  static const String _keyExamDate = 'exam_date';

  // İsim Kaydetme/Okuma
  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  // Tarih Kaydetme/Okuma
  Future<void> saveExamDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyExamDate, date.toIso8601String());
  }

  Future<DateTime?> getExamDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_keyExamDate);
    if (dateStr != null) {
      return DateTime.parse(dateStr);
    }
    return null;
  }
}