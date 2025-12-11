class RankingService {
  // 2024 Yılı Referans Verileri (Puan : Sıralama)
  // Bu veriler yaklaşık değerlerdir.
  
  static final Map<int, int> _tytData = {
    500: 1,
    480: 1500,
    450: 10000,
    400: 50000,
    350: 120000,
    300: 300000,
    250: 600000,
    200: 1200000,
    150: 2500000,
    100: 3500000,
  };

  static final Map<int, int> _sayData = {
    500: 1,
    480: 2000,
    450: 15000,
    400: 55000,
    350: 110000,
    300: 200000,
    250: 350000,
    200: 600000,
    150: 1000000,
  };

  static final Map<int, int> _eaData = {
    500: 1,
    480: 500,
    450: 3000,
    400: 20000,
    350: 80000,
    300: 200000,
    250: 500000,
    200: 900000,
  };

  static final Map<int, int> _sozData = {
    500: 1,
    480: 200,
    450: 1500,
    400: 10000,
    350: 50000,
    300: 150000,
    250: 400000,
    200: 800000,
  };

  // Hesaplama Fonksiyonu
  static int calculateRanking(double score, String type) {
    Map<int, int> referenceData;

    if (type.contains("TYT")) referenceData = _tytData;
    else if (type.contains("SAY")) referenceData = _sayData;
    else if (type.contains("EA")) referenceData = _eaData;
    else if (type.contains("SÖZ")) referenceData = _sozData;
    else referenceData = _tytData; // Varsayılan

    // Puan aralığını bul
    List<int> scores = referenceData.keys.toList()..sort();
    
    // Eğer puan tablodan düşükse en kötüyü döndür
    if (score < scores.first) return referenceData[scores.first]!;
    // Eğer puan tablodan yüksekse en iyiyi döndür
    if (score > scores.last) return 1;

    // Aralığı bul (Interpolasyon)
    for (int i = 0; i < scores.length - 1; i++) {
      int lowScore = scores[i];
      int highScore = scores[i + 1];

      if (score >= lowScore && score <= highScore) {
        int lowRank = referenceData[lowScore]!;
        int highRank = referenceData[highScore]!;

        // Formül: (Puan farkı oranı) * (Sıralama farkı)
        double ratio = (score - lowScore) / (highScore - lowScore);
        double rankDiff = (lowRank - highRank).toDouble(); // Sıralama ters orantılıdır
        
        return (lowRank - (rankDiff * ratio)).toInt();
      }
    }
    
    return 0; // Hata durumu
  }
}