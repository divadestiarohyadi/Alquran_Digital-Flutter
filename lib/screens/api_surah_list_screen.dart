import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/quran_api_service.dart';
import '../widgets/api_surah_card.dart';
import 'api_surah_detail_screen.dart';

class ApiSurahListScreen extends StatefulWidget {
  const ApiSurahListScreen({super.key});

  @override
  State<ApiSurahListScreen> createState() => _ApiSurahListScreenState();
}

class _ApiSurahListScreenState extends State<ApiSurahListScreen> {
  List<ApiSurah> surahs = [];
  List<ApiSurah> filteredSurahs = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSurahs();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final surahList = await QuranApiService.getAllSurahs();

      setState(() {
        surahs = surahList;
        filteredSurahs = surahList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredSurahs = surahs;
      } else {
        filteredSurahs = surahs.where((surah) {
          return surah.namaLatin.toLowerCase().contains(query) ||
              surah.nama.contains(query) ||
              surah.arti.toLowerCase().contains(query) ||
              surah.nomor.toString().contains(query);
        }).toList();
      }
    });
  }

  void _navigateToDetail(ApiSurah surah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApiSurahDetailScreen(surah: surah),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Daftar Surah',
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
            onPressed: _loadSurahs,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: const Color(0xFF2E7D32),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari surah...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          // Content
          Expanded(
            child: isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF2E7D32),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Memuat daftar surah...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                onPressed: _loadSurahs,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : filteredSurahs.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Surah tidak ditemukan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: filteredSurahs.length,
                            itemBuilder: (context, index) {
                              final surah = filteredSurahs[index];
                              return ApiSurahCard(
                                surah: surah,
                                onTap: () => _navigateToDetail(surah),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
