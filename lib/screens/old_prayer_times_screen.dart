import 'package:flutter/material.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  String selectedCity = 'Jakarta';
  final List<String> cities = [
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Medan',
    'Semarang',
    'Makassar',
    'Palembang',
    'Yogyakarta',
  ];

  // Sample prayer times data
  final Map<String, Map<String, String>> prayerTimes = {
    'Jakarta': {
      'Subuh': '04:45',
      'Dzuhur': '12:05',
      'Ashar': '15:15',
      'Maghrib': '18:05',
      'Isya': '19:15',
    },
    'Surabaya': {
      'Subuh': '04:40',
      'Dzuhur': '12:00',
      'Ashar': '15:10',
      'Maghrib': '18:00',
      'Isya': '19:10',
    },
    'Bandung': {
      'Subuh': '04:50',
      'Dzuhur': '12:10',
      'Ashar': '15:20',
      'Maghrib': '18:10',
      'Isya': '19:20',
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentTimes = prayerTimes[selectedCity] ?? prayerTimes['Jakarta']!;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Jadwal Sholat'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: _showCityPicker,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.mosque,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    selectedCity,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getCurrentDate(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getCurrentHijriDate(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Prayer Times List
            const Text(
              'Waktu Sholat Hari Ini',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            
            const SizedBox(height: 16),
            
            ...currentTimes.entries.map((entry) => _buildPrayerTimeCard(
              entry.key,
              entry.value,
              _getNextPrayer() == entry.key,
            )).toList(),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            const Text(
              'Fitur Tambahan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Kiblat',
                    Icons.compass_calibration,
                    Colors.blue,
                    () => _showComingSoon('Arah Kiblat'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    'Alarm',
                    Icons.alarm,
                    Colors.orange,
                    () => _showComingSoon('Alarm Sholat'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Doa Sholat',
                    Icons.menu_book,
                    Colors.purple,
                    () => _showComingSoon('Doa Setelah Sholat'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    'Masjid Terdekat',
                    Icons.location_searching,
                    Colors.teal,
                    () => _showComingSoon('Masjid Terdekat'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimeCard(String prayer, String time, bool isNext) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isNext ? 4 : 2,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isNext ? Border.all(color: const Color(0xFF2E7D32), width: 2) : null,
            gradient: isNext ? LinearGradient(
              colors: [Colors.green.withOpacity(0.1), Colors.white],
            ) : null,
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isNext ? const Color(0xFF2E7D32) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getPrayerIcon(prayer),
                  color: isNext ? Colors.white : Colors.grey[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prayer,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isNext ? const Color(0xFF2E7D32) : Colors.black87,
                      ),
                    ),
                    if (isNext)
                      const Text(
                        'Waktu Sholat Berikutnya',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isNext ? const Color(0xFF2E7D32) : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPrayerIcon(String prayer) {
    switch (prayer) {
      case 'Subuh':
        return Icons.wb_twilight;
      case 'Dzuhur':
        return Icons.wb_sunny;
      case 'Ashar':
        return Icons.wb_sunny_outlined;
      case 'Maghrib':
        return Icons.wb_incandescent;
      case 'Isya':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }

  String _getNextPrayer() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    
    if (currentHour < 4 || (currentHour == 4 && currentMinute < 45)) return 'Subuh';
    if (currentHour < 12 || (currentHour == 12 && currentMinute < 5)) return 'Dzuhur';
    if (currentHour < 15 || (currentHour == 15 && currentMinute < 15)) return 'Ashar';
    if (currentHour < 18 || (currentHour == 18 && currentMinute < 5)) return 'Maghrib';
    if (currentHour < 19 || (currentHour == 19 && currentMinute < 15)) return 'Isya';
    return 'Subuh';
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String _getCurrentHijriDate() {
    return '15 Rabi\' al-Awwal 1447 H'; // Sample Hijri date
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Kota',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...cities.map((city) => ListTile(
              title: Text(city),
              leading: const Icon(Icons.location_city),
              onTap: () {
                setState(() {
                  selectedCity = city;
                });
                Navigator.pop(context);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur $feature akan segera hadir!'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }
}