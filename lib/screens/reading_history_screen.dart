import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/reading_history_service.dart';
import '../widgets/api_surah_card.dart';
import 'api_surah_detail_screen.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  ReadingHistoryScreenState createState() => ReadingHistoryScreenState();
}

class ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  List<ApiSurah> history = [];
  bool isLoading = true;
  Map<String, dynamic> stats = {};

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void didUpdateWidget(ReadingHistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh when widget updates
    _loadHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh history when returning from other screens
    _loadHistory();
  }

  // Auto refresh when screen becomes visible again
  void _refreshOnResume() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadHistory();
      }
    });
  }

  Future<void> _loadHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      final historyData = await ReadingHistoryService.getHistory();
      final statsData = await ReadingHistoryService.getReadingStats();

      setState(() {
        history = historyData;
        stats = statsData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Public method to refresh history from outside
  void refreshHistory() {
    print('Manual refresh requested from MainNavigationScreen');
    _loadHistory();
  }

  Future<void> _clearHistory() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text(
            'Apakah Anda yakin ingin menghapus semua riwayat bacaan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ReadingHistoryService.clearHistory();
              await _loadHistory();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Riwayat bacaan berhasil dihapus'),
                    backgroundColor: Color(0xFF2E7D32),
                  ),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToSurah(ApiSurah surah) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApiSurahDetailScreen(surah: surah),
      ),
    );

    // Refresh history after returning from detail screen
    if (mounted) {
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Riwayat Bacaan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              refreshHistory();
            },
            tooltip: 'Refresh Riwayat',
          ),
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: _clearHistory,
              tooltip: 'Hapus Semua Riwayat',
            ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF2E7D32),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat riwayat bacaan...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Statistics Card
                if (stats['totalRead'] > 0)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2E7D32),
                          Color(0xFF4CAF50),
                        ],
                      ),
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
                    child: Row(
                      children: [
                        const Icon(
                          Icons.menu_book,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Surah Dibaca',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${stats['totalRead']} dari 114 Surah',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (stats['readingSurahNames']?.isNotEmpty ==
                                  true)
                                Text(
                                  'Terakhir: ${(stats['readingSurahNames'] as List).join(', ')}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${((stats['totalRead'] / 114) * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // History List
                Expanded(
                  child: history.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum Ada Riwayat Bacaan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Mulai baca surah untuk melihat riwayat di sini',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final surah = history[index];
                            return ApiSurahCard(
                              surah: surah,
                              onTap: () => _navigateToSurah(surah),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
