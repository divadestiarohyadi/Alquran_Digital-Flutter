import 'package:flutter/material.dart';
import '../models/surah.dart';
import '../models/quran_data.dart';
import '../models/api_models.dart';
import '../widgets/ayah_card.dart';
import '../services/reading_history_service.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late List<Ayah> ayahs;
  double _fontSize = 20;

  @override
  void initState() {
    super.initState();
    ayahs = QuranData.getAyahs()[widget.surah.number] ?? [];
    _saveToHistory();
  }

  Future<void> _saveToHistory() async {
    // Convert Surah to ApiSurah for history compatibility
    final apiSurah = ApiSurah(
      nomor: widget.surah.number,
      nama: widget.surah.name,
      namaLatin: widget.surah.englishName,
      jumlahAyat: widget.surah.numberOfAyahs,
      tempatTurun: widget.surah.revelationType == 'Meccan' ? 'مكة' : 'المدينة',
      arti: widget.surah.englishNameTranslation,
      deskripsi: 'Surah ${widget.surah.englishName}',
      audioFull: '',
    );

    await ReadingHistoryService.addToHistory(apiSurah);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF2E7D32),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.surah.englishName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2E7D32),
                      Color(0xFF4CAF50),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.surah.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.surah.englishNameTranslation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.surah.revelationType} • ${widget.surah.numberOfAyahs} Ayahs',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.text_decrease),
                onPressed: () {
                  setState(() {
                    if (_fontSize > 14) _fontSize -= 2;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.text_increase),
                onPressed: () {
                  setState(() {
                    if (_fontSize < 32) _fontSize += 2;
                  });
                },
              ),
            ],
          ),

          // Bismillah (except for At-Tawbah)
          if (widget.surah.number != 9 && widget.surah.number != 1)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _fontSize + 4,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2E7D32),
                    height: 2,
                  ),
                ),
              ),
            ),

          // Ayahs List
          if (ayahs.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ayah = ayahs[index];
                  return AyahCard(
                    ayah: ayah,
                    surahNumber: widget.surah.number,
                  );
                },
                childCount: ayahs.length,
              ),
            )
          else
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Ayat untuk surah ini belum tersedia',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}
