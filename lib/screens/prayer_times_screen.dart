import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/prayer_times_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  Map<String, String> prayerTimes = {};
  String location = 'Mencari lokasi...';
  String hijriDate = '';
  bool isLoading = true;
  String? errorMessage;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Get current location
      final locationData = await LocationService.getCurrentLocation();

      if (locationData == null) {
        setState(() {
          errorMessage =
              'Tidak dapat mengakses lokasi. Pastikan GPS aktif dan berikan izin lokasi.';
          isLoading = false;
        });
        return;
      }

      latitude = locationData['latitude'];
      longitude = locationData['longitude'];

      // Get short location name from coordinates
      final address =
          await LocationService.getShortLocationName(latitude!, longitude!);

      // Get prayer times from API
      final prayerData = await PrayerTimesService.getPrayerTimes(
        latitude: latitude!,
        longitude: longitude!,
      );

      if (prayerData == null) {
        setState(() {
          errorMessage =
              'Gagal mengambil data jadwal sholat. Periksa koneksi internet.';
          isLoading = false;
        });
        return;
      }

      setState(() {
        prayerTimes = PrayerTimesService.formatPrayerTimes(prayerData);
        location = address;
        hijriDate = PrayerTimesService.getHijriDate(prayerData);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  String _getNextPrayer() {
    if (prayerTimes.isEmpty) return '';
    return PrayerTimesService.getNextPrayer(prayerTimes);
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Jadwal Sholat',
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
            onPressed: _loadPrayerTimes,
            tooltip: 'Refresh Lokasi',
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
                    'Mendapatkan lokasi dan jadwal sholat...',
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
                          'Terjadi kesalahan',
                          style: TextStyle(
                            fontSize: 18,
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
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadPrayerTimes,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header dengan lokasi dan tanggal
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
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
                        child: Column(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              location,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (hijriDate.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                hijriDate,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Text(
                              'Waktu sekarang: ${_getCurrentTime()}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Next prayer info
                      if (prayerTimes.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Sholat Berikutnya',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    color: const Color(0xFF2E7D32),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_getNextPrayer()} - ${prayerTimes[_getNextPrayer()] ?? ""}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      // Prayer times list
                      if (prayerTimes.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Jadwal Sholat Hari Ini',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ),
                              ...prayerTimes.entries
                                  .map((entry) => _buildPrayerTimeItem(
                                        entry.key,
                                        entry.value,
                                        entry.key == _getNextPrayer(),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),

                      // Coordinate info
                      if (latitude != null && longitude != null)
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.gps_fixed,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Koordinat: ${latitude!.toStringAsFixed(4)}°, ${longitude!.toStringAsFixed(4)}°',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPrayerTimeItem(String prayer, String time, bool isNext) {
    IconData prayerIcon;
    switch (prayer) {
      case 'Fajr':
        prayerIcon = Icons.wb_twilight;
        break;
      case 'Sunrise':
        prayerIcon = Icons.wb_sunny;
        break;
      case 'Dhuhr':
        prayerIcon = Icons.wb_sunny_outlined;
        break;
      case 'Asr':
        prayerIcon = Icons.wb_cloudy;
        break;
      case 'Maghrib':
        prayerIcon = Icons.wb_twilight;
        break;
      case 'Isha':
        prayerIcon = Icons.nightlight_round;
        break;
      default:
        prayerIcon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isNext ? const Color(0xFF2E7D32).withOpacity(0.1) : null,
        border: isNext
            ? Border.all(color: const Color(0xFF2E7D32), width: 1)
            : null,
        borderRadius: isNext ? BorderRadius.circular(12) : null,
      ),
      margin: isNext
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
          : EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isNext
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              prayerIcon,
              color: isNext ? Colors.white : const Color(0xFF2E7D32),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              prayer,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                color: isNext ? const Color(0xFF2E7D32) : Colors.black87,
              ),
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
          if (isNext) const SizedBox(width: 8),
          if (isNext)
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF2E7D32),
            ),
        ],
      ),
    );
  }
}
