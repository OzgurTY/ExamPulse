import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/topic_data.dart';
import '../../core/models/subject_model.dart';
import '../../core/services/storage_service.dart'; // Servisi import et

class SubjectTrackerScreen extends StatefulWidget {
  const SubjectTrackerScreen({super.key});

  @override
  State<SubjectTrackerScreen> createState() => _SubjectTrackerScreenState();
}

class _SubjectTrackerScreenState extends State<SubjectTrackerScreen> {
  // Başlangıç verisini yükle
  final List<Subject> _subjects = TopicData.getTytSubjects();
  final StorageService _storageService = StorageService();
  bool _isLoading = true; // Yükleniyor mu?

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // 1. KAYITLI İLERLEMEYİ YÜKLE
  Future<void> _loadProgress() async {
    // Hafızadaki bitmiş konuların isimlerini al (Örn: ["Üslü Sayılar", "Optik"])
    List<String> completedTopicNames = await _storageService.getCompletedTopics();

    // Elimizdeki listeyi güncelle
    for (var subject in _subjects) {
      for (var topic in subject.topics) {
        if (completedTopicNames.contains(topic.name)) {
          topic.isCompleted = true;
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  // 2. İŞARETLEME YAPILINCA KAYDET
  Future<void> _toggleTopic(Topic topic, bool? val) async {
    setState(() {
      topic.isCompleted = val ?? false;
    });

    // Tüm derslerdeki bitmiş konuları topla
    List<String> allCompletedNames = [];
    for (var subject in _subjects) {
      for (var t in subject.topics) {
        if (t.isCompleted) {
          allCompletedNames.add(t.name);
        }
      }
    }

    // Servis ile kaydet
    await _storageService.saveCompletedTopics(allCompletedNames);
  }

  // İlerleme Oranı Hesapla
  double _calculateProgress(Subject subject) {
    if (subject.topics.isEmpty) return 0.0;
    int completedCount = subject.topics.where((t) => t.isCompleted).length;
    return completedCount / subject.topics.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Konu Takip", style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      // Yükleniyorsa dönen çember göster, bittiyse listeyi
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                final progress = _calculateProgress(subject);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ExpansionTile(
                    // Başlık Kısmı
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.menu_book, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          subject.name,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade200,
                            color: progress == 1.0 ? Colors.green : Colors.orangeAccent,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "%${(progress * 100).toInt()} Tamamlandı",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    // Konular Listesi
                    children: subject.topics.map((topic) {
                      return CheckboxListTile(
                        title: Text(
                          topic.name,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            decoration: topic.isCompleted ? TextDecoration.lineThrough : null,
                            color: topic.isCompleted ? Colors.grey : Colors.black87,
                          ),
                        ),
                        value: topic.isCompleted,
                        activeColor: Colors.green,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (val) => _toggleTopic(topic, val), // Yeni fonksiyonu çağır
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}