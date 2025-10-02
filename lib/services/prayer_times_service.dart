import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerTimesService {
  static const String _baseUrl = 'https://api.aladhan.com/v1/timings';

  // Fallback prayer times for Jakarta (when API fails)
  static Map<String, dynamic> _getFallbackPrayerTimes() {
    final now = DateTime.now();
    return {
      'data': {
        'timings': {
          'Fajr': '04:50',
          'Sunrise': '06:00',
          'Dhuhr': '12:00',
          'Asr': '15:15',
          'Maghrib': '18:00',
          'Isha': '19:15',
        },
        'date': {
          'hijri': {
            'day': '${now.day}',
            'month': {'en': 'Hijri'},
            'year': '${1445 + (now.year - 2023)}',
          },
        },
        'meta': {
          'timezone': 'Asia/Jakarta',
        },
      },
    };
  }

  static Future<Map<String, dynamic>?> getPrayerTimes({
    required double latitude,
    required double longitude,
    int method = 2, // 2 = Islamic Society of North America (ISNA)
  }) async {
    try {
      final now = DateTime.now();
      final date = '${now.day}-${now.month}-${now.year}';

      final url =
          '$_baseUrl/$date?latitude=$latitude&longitude=$longitude&method=$method';

      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        // Return fallback data if API fails
        return _getFallbackPrayerTimes();
      }
    } catch (e) {
      print('Error fetching prayer times: $e');
      // Return fallback data on any error
      return _getFallbackPrayerTimes();
    }
  }

  static Map<String, String> formatPrayerTimes(
      Map<String, dynamic> apiResponse) {
    final timings = apiResponse['data']['timings'];

    return {
      'Fajr': _formatTime(timings['Fajr']),
      'Sunrise': _formatTime(timings['Sunrise']),
      'Dhuhr': _formatTime(timings['Dhuhr']),
      'Asr': _formatTime(timings['Asr']),
      'Maghrib': _formatTime(timings['Maghrib']),
      'Isha': _formatTime(timings['Isha']),
    };
  }

  static String _formatTime(String time) {
    // Remove timezone info if present (e.g., "05:30 (+07)" -> "05:30")
    return time.split(' ')[0];
  }

  static String getLocationInfo(Map<String, dynamic> apiResponse) {
    try {
      final meta = apiResponse['data']['meta'];
      return '${meta['timezone']}';
    } catch (e) {
      return 'Unknown Location';
    }
  }

  static String getHijriDate(Map<String, dynamic> apiResponse) {
    try {
      final hijri = apiResponse['data']['date']['hijri'];
      return '${hijri['day']} ${hijri['month']['en']} ${hijri['year']} H';
    } catch (e) {
      return '';
    }
  }

  static String getCurrentPrayer(Map<String, String> prayerTimes) {
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final prayers = [
      'Fajr',
      'Sunrise',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha',
    ];

    for (int i = 0; i < prayers.length; i++) {
      final prayerTime = prayerTimes[prayers[i]] ?? '';
      if (_isTimeAfter(currentTime, prayerTime)) {
        continue;
      } else {
        return prayers[i];
      }
    }

    return 'Fajr'; // Next day Fajr
  }

  static String getNextPrayer(Map<String, String> prayerTimes) {
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final prayers = [
      'Fajr',
      'Sunrise',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha',
    ];

    for (int i = 0; i < prayers.length; i++) {
      final prayerTime = prayerTimes[prayers[i]] ?? '';
      if (_isTimeAfter(currentTime, prayerTime)) {
        continue;
      } else {
        return prayers[i];
      }
    }

    return 'Fajr'; // Next day Fajr
  }

  static bool _isTimeAfter(String time1, String time2) {
    final parts1 = time1.split(':');
    final parts2 = time2.split(':');

    final hour1 = int.parse(parts1[0]);
    final minute1 = int.parse(parts1[1]);
    final hour2 = int.parse(parts2[0]);
    final minute2 = int.parse(parts2[1]);

    if (hour1 > hour2) return true;
    if (hour1 == hour2 && minute1 > minute2) return true;

    return false;
  }
}
