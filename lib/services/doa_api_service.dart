import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';

class DoaApiService {
  static const String baseUrl = 'https://open-api.my.id/api';

  /// Get all doa harian from API
  static Future<List<DoaHarian>> getAllDoa() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doa'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> doaList = json.decode(response.body);
        return doaList.map((doa) => DoaHarian.fromJson(doa)).toList();
      } else {
        // Fallback to local data if API fails
        return _getFallbackDoa();
      }
    } on TimeoutException {
      // Fallback to local data if timeout
      return _getFallbackDoa();
    } catch (e) {
      // Fallback to local data if any error
      return _getFallbackDoa();
    }
  }

  /// Fallback doa data when API is not available
  static List<DoaHarian> _getFallbackDoa() {
    return [
      DoaHarian(
        id: 1,
        judul: 'Doa Sebelum Makan',
        arab:
            'اَللّٰهُمَّ بَارِكْ لَنَا فِيْمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ',
        latin:
            'Allaahumma baarik lanaa fiimaa rozaqtanaa wa qinaa adzaa bannaar',
        terjemah:
            'Ya Allah, berkahilah kami dalam rezeki yang telah Engkau berikan kepada kami dan peliharalah kami dari siksa api neraka.',
      ),
      DoaHarian(
        id: 2,
        judul: 'Doa Sesudah Makan',
        arab:
            'اَلْحَمْدُ لِلّٰهِ الَّذِيْ اَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِيْنَ',
        latin:
            'Alhamdulillahilladzi ath-amanaa wa saqoonaa wa ja-alanaa minal muslimiin',
        terjemah:
            'Segala puji bagi Allah yang telah memberi makan dan minum kepada kami serta menjadikan kami termasuk orang-orang yang berserah diri kepada-Nya.',
      ),
      DoaHarian(
        id: 3,
        judul: 'Doa Bangun Tidur',
        arab:
            'اَلْحَمْدُ لِلّٰهِ الَّذِيْ اَحْيَانَا بَعْدَ مَا اَمَاتَنَا وَاِلَيْهِ النُّشُوْرُ',
        latin:
            'Alhamdulillahilladzi ahyaanaa ba-da maa amaatanaa wa ilaihin nusyuuru',
        terjemah:
            'Segala puji bagi Allah yang telah menghidupkan kami sesudah kami mati (tidur) dan hanya kepada-Nya kami dibangkitkan.',
      ),
      DoaHarian(
        id: 4,
        judul: 'Doa Sebelum Tidur',
        arab: 'بِاسْمِكَ اللّٰهُمَّ اَمُوْتُ وَاَحْيَا',
        latin: 'Bismikallaahumma amuutu wa ahyaa',
        terjemah: 'Dengan nama-Mu ya Allah aku mati dan aku hidup.',
      ),
      DoaHarian(
        id: 5,
        judul: 'Doa Masuk Kamar Mandi',
        arab: 'اَللّٰهُمَّ اِنِّيْ اَعُوْذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَآئِثِ',
        latin: 'Allaahumma innii a-uudzubika minal khubutsi wal khobaaitsi',
        terjemah:
            'Ya Allah, sesungguhnya aku berlindung kepada-Mu dari godaan setan laki-laki dan setan perempuan.',
      ),
    ];
  }

  /// Search doa by name
  static Future<List<DoaHarian>> searchDoa(String query) async {
    try {
      final allDoa = await getAllDoa();

      if (query.isEmpty) return allDoa;

      return allDoa.where((doa) {
        return doa.judul.toLowerCase().contains(query.toLowerCase()) ||
            doa.terjemah.toLowerCase().contains(query.toLowerCase()) ||
            doa.latin.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mencari doa: $e');
    }
  }

  /// Get doa by ID
  static Future<DoaHarian?> getDoaById(int id) async {
    try {
      final allDoa = await getAllDoa();
      return allDoa.firstWhere((doa) => doa.id == id);
    } catch (e) {
      return null;
    }
  }
}
