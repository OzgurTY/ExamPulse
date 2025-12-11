import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _historyKey = 'exam_history';

  // Sonuç Kaydetme
  Future<void> saveResult(double score, double net) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Mevcut listeyi al (yoksa boş liste oluştur)
    List<String> history = prefs.getStringList(_historyKey) ?? [];

    // Yeni sonucu string olarak hazırla: "Tarih#Puan#Net"
    String newRecord = "${DateTime.now().toString()}#$score#$net";
    
    // Listeye ekle ve kaydet
    history.add(newRecord);
    await prefs.setStringList(_historyKey, history);
  }

  // Geçmişi Getirme
  Future<List<String>> getHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Listeyi ters çevir (en yeniden en eskiye)
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    return history.reversed.toList();
  }
  
  // Geçmişi Temizleme (Opsiyonel)
  Future<void> clearHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}