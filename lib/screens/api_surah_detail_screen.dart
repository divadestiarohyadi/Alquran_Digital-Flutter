import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/quran_api_service.dart';
import '../services/reading_history_service.dart';
import '../widgets/api_ayah_card.dart';
import '../utils/text_utils.dart';

class ApiSurahDetailScreen extends StatefulWidget {
  final ApiSurah surah;

  const ApiSurahDetailScreen({super.key, required this.surah});

  @override
  State<ApiSurahDetailScreen> createState() => _ApiSurahDetailScreenState();
}

class _ApiSurahDetailScreenState extends State<ApiSurahDetailScreen> {
  ApiSurahDetail? surahDetail;
  bool isLoading = true;
  String? errorMessage;
  double _fontSize = 20;

  @override
  void initState() {
    super.initState();
    _loadSurahDetail();
  }

  Future<void> _loadSurahDetail() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final detail = await QuranApiService.getSurahDetail(widget.surah.nomor);

      // Add to reading history
      await ReadingHistoryService.addToHistory(widget.surah);

      setState(() {
        surahDetail = detail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF2E7D32),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 50, bottom: 16),
              title: Text(
                widget.surah.namaLatin,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
                      const SizedBox(height: 40),
                      // Informasi tempat turun dan jumlah ayat di atas (tanpa background)
                      Text(
                        '${widget.surah.tempatTurun} • ${widget.surah.jumlahAyat} Ayat',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Teks Arab tanpa background
                      Text(
                        widget.surah.nama,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Arti/terjemahan di bawah
                      Text(
                        TextUtils.removeHtmlTags(widget.surah.arti),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
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
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadSurahDetail,
              ),
            ],
          ),

          // Loading, Error, or Content
          if (isLoading)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFF2E7D32),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Memuat ayat-ayat...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (errorMessage != null)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Terjadi kesalahan:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSurahDetail,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (surahDetail != null) ...[
            // Bismillah (except for At-Tawbah)
            if (widget.surah.nomor != 9 && widget.surah.nomor != 1)
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ayah = surahDetail!.ayat[index];
                  return ApiAyahCard(
                    ayah: ayah,
                    fontSize: _fontSize,
                    surahNumber: widget.surah.nomor,
                  );
                },
                childCount: surahDetail!.ayat.length,
              ),
            ),
          ],

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}
