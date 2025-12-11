import 'dart:convert';

class ExamResult {
  final String id;           // Her sonucun benzersiz kimliği (Silme işlemi için)
  final DateTime date;       // Tarih
  final String examType;     // TYT, AYT-SAY, YKS vb.
  final double score;        // Toplam Puan
  final double totalNet;     // Toplam Net
  final Map<String, double> lessonNets; // Detaylar: {"Türkçe": 30.5, "Mat": 15.0}
  final Map<String, double>? scoreBreakdown;
  final int? estimatedRanking;

  ExamResult({
    required this.id,
    required this.date,
    required this.examType,
    required this.score,
    required this.totalNet,
    required this.lessonNets,
    this.scoreBreakdown,
    this.estimatedRanking,
  });

  // JSON'dan Nesneye Çevirme (Okuma)
  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id'],
      date: DateTime.parse(json['date']),
      examType: json['examType'],
      score: json['score'],
      totalNet: json['totalNet'],
      lessonNets: Map<String, double>.from(json['lessonNets']),
      scoreBreakdown: json['scoreBreakdown'] != null 
          ? Map<String, double>.from(json['scoreBreakdown']) 
          : null,
      estimatedRanking: json['estimatedRanking'],
    );
  }

  // Nesneden JSON'a Çevirme (Kaydetme)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'examType': examType,
      'score': score,
      'totalNet': totalNet,
      'lessonNets': lessonNets,
      'scoreBreakdown': scoreBreakdown,
      'estimatedRanking': estimatedRanking,
    };
  }
}