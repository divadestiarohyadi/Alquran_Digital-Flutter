import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_models.dart';

class ReadingHistoryService {
  static const String _historyKey = 'reading_history';
  static const String _lastReadKey = 'last_read_surah';

  /// Add surah to reading history
  static Future<void> addToHistory(ApiSurah surah) async {
    try {
      print('Adding to history: Surah ${surah.nomor} - ${surah.namaLatin}');
      final prefs = await SharedPreferences.getInstance();

      // Get existing history
      List<ApiSurah> history = await getHistory();
      print('Current history length: ${history.length}');

      // Remove if already exists to avoid duplicates
      history.removeWhere((s) => s.nomor == surah.nomor);

      // Add to beginning of list
      history.insert(0, surah);

      // Keep only last 20 items
      if (history.length > 20) {
        history = history.take(20).toList();
      }

      // Save to preferences
      final historyJson = history
          .map((s) => {
                'nomor': s.nomor,
                'nama': s.nama,
                'namaLatin': s.namaLatin,
                'jumlahAyat': s.jumlahAyat,
                'tempatTurun': s.tempatTurun,
                'arti': s.arti,
                'deskripsi': s.deskripsi,
                'audioFull': s.audioFull,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
              })
          .toList();

      await prefs.setString(_historyKey, json.encode(historyJson));
      print('History saved successfully. New length: ${history.length}');

      // Update last read
      await prefs.setInt(_lastReadKey, surah.nomor);
    } catch (e) {
      print('Error saving reading history: $e');
    }
  }

  /// Get reading history
  static Future<List<ApiSurah>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyString = prefs.getString(_historyKey);

      if (historyString == null) return [];

      final historyJson = json.decode(historyString) as List;

      return historyJson
          .map((item) => ApiSurah(
                nomor: item['nomor'] ?? 0,
                nama: item['nama'] ?? '',
                namaLatin: item['namaLatin'] ?? '',
                jumlahAyat: item['jumlahAyat'] ?? 0,
                tempatTurun: item['tempatTurun'] ?? '',
                arti: item['arti'] ?? '',
                deskripsi: item['deskripsi'] ?? '',
                audioFull: item['audioFull'] ?? '',
              ))
          .toList();
    } catch (e) {
      print('Error loading reading history: $e');
      return [];
    }
  }

  /// Check if surah has been read
  static Future<bool> hasBeenRead(int surahNumber) async {
    try {
      final history = await getHistory();
      return history.any((s) => s.nomor == surahNumber);
    } catch (e) {
      return false;
    }
  }

  /// Get last read surah number
  static Future<int?> getLastReadSurah() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_lastReadKey);
    } catch (e) {
      return null;
    }
  }

  /// Clear all history
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      await prefs.remove(_lastReadKey);
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  /// Get reading statistics
  static Future<Map<String, dynamic>> getReadingStats() async {
    try {
      final history = await getHistory();
      final lastRead = await getLastReadSurah();

      return {
        'totalRead': history.length,
        'lastReadSurah': lastRead,
        'readingSurahNames': history.take(3).map((s) => s.namaLatin).toList(),
      };
    } catch (e) {
      return {
        'totalRead': 0,
        'lastReadSurah': null,
        'readingSurahNames': <String>[],
      };
    }
  }
}
