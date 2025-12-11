import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exam_result.dart'; // Modelimizi import ettik

class StorageService {
  static const String _historyKey = 'exam_history_v2'; // Key'i değiştirdik (Eski verilerle karışmasın)

  // KAYDETME
  Future<void> saveResult(ExamResult result) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Mevcut listeyi çek
    List<String> rawList = prefs.getStringList(_historyKey) ?? [];
    
    // Yeni sonucu JSON string'e çevirip ekle
    rawList.add(jsonEncode(result.toJson()));
    
    // Kaydet
    await prefs.setStringList(_historyKey, rawList);
  }

  // LİSTELEME
  Future<List<ExamResult>> getHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> rawList = prefs.getStringList(_historyKey) ?? [];
    
    // String listesini ExamResult listesine dönüştür
    List<ExamResult> results = rawList.map((item) {
      return ExamResult.fromJson(jsonDecode(item));
    }).toList();

    // En yeniden en eskiye sırala
    return results.reversed.toList();
  }

  // SİLME (Artık ID ile nokta atışı silebiliriz!)
  Future<void> deleteResult(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> rawList = prefs.getStringList(_historyKey) ?? [];
    
    // ID'si eşleşen kaydı bul ve sil
    rawList.removeWhere((item) {
      final json = jsonDecode(item);
      return json['id'] == id;
    });

    await prefs.setStringList(_historyKey, rawList);
  }

  // TEMİZLEME
  Future<void> clearHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  static const String _keyCompletedTopics = 'completed_topics';

  // Tamamlanan Konuların İsimlerini Kaydet
  Future<void> saveCompletedTopics(List<String> topicNames) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCompletedTopics, topicNames);
  }

  // Tamamlanan Konuları Getir
  Future<List<String>> getCompletedTopics() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyCompletedTopics) ?? [];
  }
}