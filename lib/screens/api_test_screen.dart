import 'package:flutter/material.dart';
import '../services/quran_api_service.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  bool isLoading = false;
  String result = '';

  Future<void> testGetAllSurahs() async {
    setState(() {
      isLoading = true;
      result = 'Testing getAllSurahs...';
    });

    try {
      final surahs = await QuranApiService.getAllSurahs();
      setState(() {
        result =
            'Success! Got ${surahs.length} surahs\n\nFirst surah: ${surahs.first.namaLatin}';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> testGetSurahDetail() async {
    setState(() {
      isLoading = true;
      result = 'Testing getSurahDetail for Al-Fatihah...';
    });

    try {
      final detail = await QuranApiService.getSurahDetail(1);
      setState(() {
        result =
            'Success! Got detail for: ${detail.namaLatin}\nAyat count: ${detail.ayat.length}\nFirst ayat: ${detail.ayat.first.teksIndonesia}';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : testGetAllSurahs,
              child: const Text('Test Get All Surahs'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: isLoading ? null : testGetSurahDetail,
              child: const Text('Test Get Surah Detail'),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
