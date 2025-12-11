class Subject {
  final String name; // Dersin adı (Örn: Matematik)
  final List<Topic> topics; // Konular listesi

  Subject({required this.name, required this.topics});
}

class Topic {
  final String name; // Konu adı (Örn: Üslü Sayılar)
  bool isCompleted; // Bitti mi?

  Topic({required this.name, this.isCompleted = false});
}