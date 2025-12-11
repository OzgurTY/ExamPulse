import '../models/subject_model.dart';

// Hazır YKS Konu Listesi
class TopicData {
  static List<Subject> getTytSubjects() {
    return [
      Subject(
        name: "Matematik",
        topics: [
          Topic(name: "Temel Kavramlar"),
          Topic(name: "Sayı Basamakları"),
          Topic(name: "Bölme - Bölünebilme"),
          Topic(name: "OBEB - OKEK"),
          Topic(name: "Rasyonel Sayılar"),
          Topic(name: "Basit Eşitsizlikler"),
          Topic(name: "Mutlak Değer"),
          Topic(name: "Üslü Sayılar"),
          Topic(name: "Köklü Sayılar"),
          Topic(name: "Çarpanlara Ayırma"),
          Topic(name: "Oran - Orantı"),
          Topic(name: "Denklem Çözme"),
          Topic(name: "Problemler (Sayı-Kesir)"),
          Topic(name: "Problemler (Yaş)"),
          Topic(name: "Problemler (Hareket)"),
          Topic(name: "Kümeler"),
          Topic(name: "Fonksiyonlar"),
          Topic(name: "Polinomlar"),
          Topic(name: "İstatistik"),
        ],
      ),
      Subject(
        name: "Türkçe",
        topics: [
          Topic(name: "Sözcükte Anlam"),
          Topic(name: "Cümlede Anlam"),
          Topic(name: "Paragraf"),
          Topic(name: "Ses Bilgisi"),
          Topic(name: "Yazım Kuralları"),
          Topic(name: "Noktalama İşaretleri"),
          Topic(name: "Sözcükte Yapı"),
          Topic(name: "İsimler & Tamlamalar"),
          Topic(name: "Sıfatlar & Zarflar"),
          Topic(name: "Zamirler"),
          Topic(name: "Fiiller"),
          Topic(name: "Cümlenin Ögeleri"),
        ],
      ),
      Subject(
        name: "Fizik",
        topics: [
          Topic(name: "Fizik Bilimine Giriş"),
          Topic(name: "Madde ve Özellikleri"),
          Topic(name: "Hareket ve Kuvvet"),
          Topic(name: "Enerji"),
          Topic(name: "Isı ve Sıcaklık"),
          Topic(name: "Elektrostatik"),
          Topic(name: "Optik"),
          Topic(name: "Dalgalar"),
        ],
      ),
      Subject(
        name: "Kimya",
        topics: [
          Topic(name: "Kimya Bilimi"),
          Topic(name: "Atom ve Periyodik Sistem"),
          Topic(name: "Kimyasal Türler Arası Etkileşim"),
          Topic(name: "Maddenin Halleri"),
          Topic(name: "Doğa ve Kimya"),
          Topic(name: "Kimyanın Temel Kanunları"),
          Topic(name: "Karışımlar"),
          Topic(name: "Asitler, Bazlar ve Tuzlar"),
          Topic(name: "Kimya Her Yerde"),
        ],
      ),
    ];
  }
}