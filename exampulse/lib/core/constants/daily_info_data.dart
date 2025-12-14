import 'dart:math';
import 'package:flutter/material.dart';

class InfoItem {
  final String category;
  final String content;
  final Color color;
  final IconData icon;

  InfoItem({
    required this.category,
    required this.content,
    required this.color,
    required this.icon,
  });
}

class DailyInfoData {
  // DEVASA BİLGİ LİSTESİ
  static final List<InfoItem> _items = [
    
    // --- EDEBİYAT (Önemli İlkler & Eserler) ---
    InfoItem(
      category: "Edebiyat",
      content: "İlk yerli romanımız: Şemsettin Sami'nin 'Taaşşuk-ı Talat ve Fitnat' eseridir.",
      color: Colors.orange,
      icon: Icons.menu_book,
    ),
    InfoItem(
      category: "Edebiyat",
      content: "Batılı anlamda ilk hikaye örnekleri: Samipaşazade Sezai'nin 'Küçük Şeyler' eseridir.",
      color: Colors.orange,
      icon: Icons.menu_book,
    ),
    InfoItem(
      category: "Edebiyat",
      content: "İlk psikolojik roman: Mehmet Rauf'un 'Eylül' eseridir.",
      color: Colors.orange,
      icon: Icons.psychology,
    ),
    InfoItem(
      category: "Edebiyat",
      content: "Sahnelenen ilk tiyatro eseri: Namık Kemal'in 'Vatan yahut Silistre'sidir.",
      color: Colors.orange,
      icon: Icons.theater_comedy,
    ),
    InfoItem(
      category: "Edebiyat",
      content: "Kurtuluş Savaşı'nı konu alan ilk roman: Halide Edip Adıvar'ın 'Ateşten Gömlek' eseridir.",
      color: Colors.orange,
      icon: Icons.flag,
    ),
    InfoItem(
      category: "Edebiyat",
      content: "Edebiyatımızdaki ilk makale: Şinasi'nin 'Tercüman-ı Ahval Mukaddimesi'dir.",
      color: Colors.orange,
      icon: Icons.article,
    ),
    InfoItem(
      category: "Edebiyat",
      content: "İlk köy romanı: Nabizade Nazım'ın 'Karabibik' eseridir.",
      color: Colors.orange,
      icon: Icons.nature_people,
    ),
    InfoItem(
      category: "Edebiyat",
      content: "Divan edebiyatında hiciv (eleştiri) ustası: Nef'i'dir.",
      color: Colors.orange,
      icon: Icons.edit,
    ),

    // --- TARİH (Kritik Olaylar) ---
    InfoItem(
      category: "Tarih",
      content: "Malazgirt Savaşı (1071), Anadolu'nun kapılarını Türklere kesin olarak açmıştır.",
      color: Colors.redAccent,
      icon: Icons.history_edu,
    ),
    InfoItem(
      category: "Tarih",
      content: "İlk Osmanlı parası Osman Bey döneminde (Bakır), ilk gümüş para Orhan Bey döneminde basılmıştır.",
      color: Colors.redAccent,
      icon: Icons.monetization_on,
    ),
    InfoItem(
      category: "Tarih",
      content: "İstanbul'un Fethi (1453) ile Orta Çağ kapanmış, Yeni Çağ başlamıştır.",
      color: Colors.redAccent,
      icon: Icons.castle,
    ),
    InfoItem(
      category: "Tarih",
      content: "Osmanlı Devleti'nde ilk anayasa: 1876 yılında ilan edilen Kanun-i Esasi'dir.",
      color: Colors.redAccent,
      icon: Icons.gavel,
    ),
    InfoItem(
      category: "Tarih",
      content: "Mustafa Kemal'in Samsun'a çıkışı (19 Mayıs 1919), Milli Mücadele'nin fiilen başladığı tarihtir.",
      color: Colors.redAccent,
      icon: Icons.directions_boat,
    ),
    InfoItem(
      category: "Tarih",
      content: "Lozan Barış Antlaşması (24 Temmuz 1923), Türkiye Cumhuriyeti'nin tapu senedidir.",
      color: Colors.redAccent,
      icon: Icons.edit_document,
    ),
    InfoItem(
      category: "Tarih",
      content: "İlk Türk devletlerinde kurultay (Toy), devlet işlerinin görüşüldüğü meclistir.",
      color: Colors.redAccent,
      icon: Icons.groups,
    ),
    InfoItem(
      category: "Tarih",
      content: "Fransız İhtilali (1789) dünyaya milliyetçilik, eşitlik ve adalet kavramlarını yaymıştır.",
      color: Colors.redAccent,
      icon: Icons.public,
    ),

    // --- MATEMATİK & GEOMETRİ ---
    InfoItem(
      category: "Matematik",
      content: "Bir sayının 3 ile bölünebilmesi için rakamları toplamı 3'ün katı olmalıdır.",
      color: Colors.blue,
      icon: Icons.calculate,
    ),
    InfoItem(
      category: "Matematik",
      content: "Asal sayılar sadece 1'e ve kendisine bölünür. En küçük asal sayı 2'dir (ve tek çift asaldır).",
      color: Colors.blue,
      icon: Icons.onetwothree,
    ),
    InfoItem(
      category: "Matematik",
      content: "0 faktöriyel (0!) her zaman 1'e eşittir.",
      color: Colors.blue,
      icon: Icons.priority_high,
    ),
    InfoItem(
      category: "Geometri",
      content: "Üçgenin iç açılarının toplamı 180 derece, dış açılarının toplamı 360 derecedir.",
      color: Colors.blue,
      icon: Icons.change_history,
    ),
    InfoItem(
      category: "Matematik",
      content: "Bir sayının 0'a bölümü tanımsızdır (belirsiz değil, tanımsız).",
      color: Colors.blue,
      icon: Icons.block,
    ),
    InfoItem(
      category: "Matematik",
      content: "Pisagor teoremi: Dik üçgende a² + b² = c² (hipotenüsün karesi).",
      color: Colors.blue,
      icon: Icons.square_foot,
    ),

    // --- COĞRAFYA ---
    InfoItem(
      category: "Coğrafya",
      content: "Türkiye'nin en yüksek dağı Ağrı Dağı'dır (5137 m).",
      color: Colors.green,
      icon: Icons.landscape,
    ),
    InfoItem(
      category: "Coğrafya",
      content: "Türkiye'nin en uzun akarsuyu (sınırlarımız içindeki): Kızılırmak'tır.",
      color: Colors.green,
      icon: Icons.water,
    ),
    InfoItem(
      category: "Coğrafya",
      content: "Dünya'nın şeklinden dolayı Ekvator'dan Kutuplara gidildikçe yerçekimi artar.",
      color: Colors.green,
      icon: Icons.public,
    ),
    InfoItem(
      category: "Coğrafya",
      content: "Türkiye'de 4 mevsimin belirgin yaşanması 'Orta Kuşak'ta olduğumuzun kanıtıdır.",
      color: Colors.green,
      icon: Icons.sunny,
    ),
    InfoItem(
      category: "Coğrafya",
      content: "Başlangıç meridyeni (0°) İngiltere'nin Greenwich kasabasından geçer.",
      color: Colors.green,
      icon: Icons.watch_later,
    ),

    // --- FEN BİLİMLERİ (Fizik, Kimya, Biyoloji) ---
    InfoItem(
      category: "Biyoloji",
      content: "Mitokondri, hücrenin enerji santralidir (ATP üretir).",
      color: Colors.teal,
      icon: Icons.science,
    ),
    InfoItem(
      category: "Biyoloji",
      content: "DNA'nın yapı birimi nükleotit, görev birimi gendir.",
      color: Colors.teal,
      icon: Icons.fingerprint,
    ),
    InfoItem(
      category: "Kimya",
      content: "Asitlerin pH değeri 0-7 arası, Bazların pH değeri 7-14 arasındadır.",
      color: Colors.teal,
      icon: Icons.science_outlined,
    ),
    InfoItem(
      category: "Kimya",
      content: "Atomun çekirdeğinde Proton (+) ve Nötron (yüksüz) bulunur. Elektronlar (-) yörüngededir.",
      color: Colors.teal,
      icon: Icons.blur_on,
    ),
    InfoItem(
      category: "Fizik",
      content: "Newton'un 1. Yasası (Eylemsizlik): Bir cisim üzerine net kuvvet etki etmiyorsa durumunu korur.",
      color: Colors.teal,
      icon: Icons.fitness_center,
    ),
    InfoItem(
      category: "Fizik",
      content: "Işık hızı boşlukta yaklaşık 300.000 km/saniyedir.",
      color: Colors.teal,
      icon: Icons.speed,
    ),
     InfoItem(
      category: "Fizik",
      content: "Ses boşlukta yayılmaz, yayılmak için maddesel ortama ihtiyaç duyar.",
      color: Colors.teal,
      icon: Icons.volume_off,
    ),

    // --- GÜNCEL & GENEL KÜLTÜR ---
    InfoItem(
      category: "Genel Kültür",
      content: "Tarihin sıfır noktası olarak bilinen yer: Şanlıurfa, Göbeklitepe'dir.",
      color: Colors.purple,
      icon: Icons.place,
    ),
    InfoItem(
      category: "Genel Kültür",
      content: "Türkiye'nin başkenti Ankara'dır ve 13 Ekim 1923'te başkent olmuştur.",
      color: Colors.purple,
      icon: Icons.location_city,
    ),
    InfoItem(
      category: "Genel Kültür",
      content: "İstiklal Marşı'nın şairi Mehmet Akif Ersoy, bestecisi Osman Zeki Üngör'dür.",
      color: Colors.purple,
      icon: Icons.music_note,
    ),

    // --- MOTİVASYON & STRATEJİ ---
    InfoItem(
      category: "Motivasyon",
      content: "Başlamak için mükemmel olmak zorunda değilsin, ama mükemmel olmak için başlamak zorundasın.",
      color: Colors.indigo,
      icon: Icons.rocket_launch,
    ),
    InfoItem(
      category: "Motivasyon",
      content: "Bugün yaptıkların, yarın olmak istediğin kişiyi oluşturur. Pes etme!",
      color: Colors.indigo,
      icon: Icons.diamond,
    ),
    InfoItem(
      category: "Strateji",
      content: "Pomodoro tekniği: 25 dakika çalış, 5 dakika mola ver. Odağını korumanı sağlar.",
      color: Colors.indigo,
      icon: Icons.timer,
    ),
    InfoItem(
      category: "Strateji",
      content: "Deneme çözerken turlama tekniği kullan: Yapamadığın soruyu geç, sona bırak.",
      color: Colors.indigo,
      icon: Icons.replay,
    ),
    InfoItem(
      category: "Motivasyon",
      content: "Yorgun olduğunda durma, işin bittiğinde dur.",
      color: Colors.indigo,
      icon: Icons.battery_charging_full,
    ),
    InfoItem(
      category: "Strateji",
      content: "Uyku hafızayı güçlendirir. Sınav döneminde günde en az 7 saat uyumalısın.",
      color: Colors.indigo,
      icon: Icons.bedtime,
    ),
  ];

  // Rastgele bir bilgi getir
  static InfoItem getRandomInfo() {
    return _items[Random().nextInt(_items.length)];
  }
}