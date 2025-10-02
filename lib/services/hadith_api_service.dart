import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hadith_models.dart';

class HadithApiService {
  static const String baseUrl = 'https://hadith-api-go.vercel.app/api/v1';

  // Get list of available narrators
  static Future<List<HadithNarrator>> getNarrators() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/narrators'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final narratorsResponse = NarratorsResponse.fromJson(jsonData);
        return narratorsResponse.data;
      } else {
        throw Exception('Failed to load narrators');
      }
    } catch (e) {
      print('Error fetching narrators: $e');
      return [];
    }
  }

  // Get all hadiths with pagination
  static Future<HadithResponse?> getAllHadiths({
    int page = 1,
    int limit = 10,
    String? query,
  }) async {
    try {
      // Try API first
      var uri = Uri.parse('$baseUrl/hadis/bukhari');
      var queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (query != null && query.isNotEmpty) {
        queryParams['q'] = query;
      }

      uri = uri.replace(queryParameters: queryParams);
      print('Trying API: $uri');

      final response = await http.get(uri).timeout(
            const Duration(seconds: 10),
          );

      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Hadith> hadithList = [];

        if (jsonData is List) {
          hadithList = jsonData.map((item) {
            // Add narrator info
            final hadithData = Map<String, dynamic>.from(item);
            hadithData['narrator'] = 'Bukhari';
            return Hadith.fromJson(hadithData);
          }).toList();
        }

        if (hadithList.isNotEmpty) {
          return HadithResponse(
            status: 'success',
            message: 'Data loaded successfully',
            data: hadithList,
            pagination: null,
          );
        }
      }
    } catch (e) {
      print('API Error: $e');
    }

    // Fallback to sample data
    print('Using fallback data');
    return _getFallbackHadiths();
  }

  // Get hadiths by narrator
  static Future<HadithResponse?> getHadithsByNarrator(
    String narratorSlug, {
    int page = 1,
    int limit = 10,
    String? query,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/hadis/$narratorSlug');
      var queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (query != null && query.isNotEmpty) {
        queryParams['q'] = query;
      }

      uri = uri.replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Handle different response formats
        List<Hadith> hadithList = [];
        if (jsonData is List) {
          // Direct array response with narrator info
          hadithList = jsonData.map((item) {
            // Add narrator info to each hadith
            item['narrator'] = narratorSlug;
            return Hadith.fromJson(item);
          }).toList();
        } else if (jsonData is Map && jsonData['data'] != null) {
          // Wrapped response
          if (jsonData['data'] is List) {
            hadithList = (jsonData['data'] as List).map((item) {
              item['narrator'] = narratorSlug;
              return Hadith.fromJson(item);
            }).toList();
          }
        }

        return HadithResponse(
          status: 'success',
          message: 'Data loaded successfully',
          data: hadithList,
          pagination: null,
        );
      } else {
        throw Exception('Failed to load hadiths by narrator');
      }
    } catch (e) {
      print('Error fetching hadiths by narrator: $e');
      return null;
    }
  }

  // Get specific hadith by narrator and number
  static Future<Hadith?> getHadithByNumber(
    String narratorSlug,
    int hadithNumber,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hadis/$narratorSlug/$hadithNumber'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final hadithResponse = HadithResponse.fromJson(jsonData);
        return hadithResponse.data.isNotEmpty
            ? hadithResponse.data.first
            : null;
      } else {
        throw Exception('Failed to load specific hadith');
      }
    } catch (e) {
      print('Error fetching specific hadith: $e');
      return null;
    }
  }

  // Get popular narrators (predefined list)
  static List<Map<String, String>> getPopularNarrators() {
    return [
      {
        'slug': 'bukhari',
        'name': 'Shahih Bukhari',
        'description': 'Kitab hadis paling sahih'
      },
      {
        'slug': 'muslim',
        'name': 'Shahih Muslim',
        'description': 'Kitab hadis sahih kedua setelah Bukhari'
      },
      {
        'slug': 'abudawud',
        'name': 'Sunan Abu Dawud',
        'description': 'Kitab hadis Sunan Abu Dawud'
      },
      {
        'slug': 'tirmidzi',
        'name': 'Sunan At-Tirmidzi',
        'description': 'Kitab hadis Sunan At-Tirmidzi'
      },
      {
        'slug': 'nasai',
        'name': 'Sunan An-Nasai',
        'description': 'Kitab hadis Sunan An-Nasai'
      },
      {
        'slug': 'ibnumajah',
        'name': 'Sunan Ibnu Majah',
        'description': 'Kitab hadis Sunan Ibnu Majah'
      },
    ];
  }

  // Fallback hadith data
  static HadithResponse _getFallbackHadiths() {
    final fallbackHadiths = [
      Hadith(
        number: 1,
        narrator: 'Bukhari',
        arab:
            'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
        indonesian:
            'Sesungguhnya setiap perbuatan tergantung niatnya, dan setiap orang akan mendapat balasan sesuai dengan apa yang ia niatkan.',
        grade: 'Sahih',
        theme: 'Niat',
      ),
      Hadith(
        number: 2,
        narrator: 'Bukhari',
        arab:
            'بُنِيَ الْإِسْلَامُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ',
        indonesian:
            'Islam dibangun atas lima perkara: bersaksi bahwa tidak ada tuhan selain Allah dan Muhammad adalah utusan Allah, mendirikan shalat, menunaikan zakat, haji, dan puasa Ramadan.',
        grade: 'Sahih',
        theme: 'Rukun Islam',
      ),
      Hadith(
        number: 3,
        narrator: 'Muslim',
        arab: 'الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ',
        indonesian:
            'Muslim sejati adalah orang yang membuat muslim lainnya selamat dari gangguan lisan dan tangannya.',
        grade: 'Sahih',
        theme: 'Akhlak',
      ),
      Hadith(
        number: 4,
        narrator: 'Abu Dawud',
        arab: 'مَنْ صَلَّى الْفَجْرَ فَهُوَ فِي ذِمَّةِ اللَّهِ',
        indonesian:
            'Barangsiapa yang shalat Subuh, maka dia berada dalam jaminan Allah.',
        grade: 'Hasan',
        theme: 'Shalat',
      ),
      Hadith(
        number: 5,
        narrator: 'Tirmidzi',
        arab:
            'الدُّنْيَا مَلْعُونَةٌ مَلْعُونٌ مَا فِيهَا إِلَّا ذِكْرَ اللَّهِ',
        indonesian:
            'Dunia itu terlaknat, terlaknat pula apa yang ada di dalamnya, kecuali dzikir kepada Allah dan apa yang menyertainya.',
        grade: 'Hasan',
        theme: 'Kehidupan Dunia',
      ),
    ];

    return HadithResponse(
      status: 'success',
      message: 'Data hadist berhasil dimuat',
      data: fallbackHadiths,
      pagination: null,
    );
  }
}
