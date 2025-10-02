import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionService {
  static const String _firstLaunchKey = 'first_launch';
  static const String _locationPermissionKey = 'location_permission_asked';

  // Check if this is the first launch
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_firstLaunchKey) ?? false);
  }

  // Mark that the app has been launched
  static Future<void> markFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, true);
  }

  // Check if location permission has been asked
  static Future<bool> hasLocationPermissionBeenAsked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationPermissionKey) ?? false;
  }

  // Mark that location permission has been asked
  static Future<void> markLocationPermissionAsked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationPermissionKey, true);
  }

  // Request location permission
  static Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  // Show location permission dialog
  static Future<void> showLocationPermissionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.orange,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Izin Lokasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aplikasi ini memerlukan akses lokasi untuk menampilkan:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              _buildFeatureItem(
                Icons.schedule,
                'Waktu Sholat Akurat',
                'Mendapatkan jadwal sholat sesuai lokasi Anda',
              ),
              SizedBox(height: 8),
              _buildFeatureItem(
                Icons.notifications,
                'Notifikasi Adzan',
                'Pengingat waktu sholat otomatis',
              ),
              SizedBox(height: 8),
              _buildFeatureItem(
                Icons.explore,
                'Arah Kiblat',
                'Menunjukkan arah kiblat dari lokasi Anda',
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Data lokasi Anda tidak akan disimpan atau dibagikan.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await markLocationPermissionAsked();
                Navigator.of(context).pop();
              },
              child: Text(
                'Nanti Saja',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await markLocationPermissionAsked();
                final permission = await requestLocationPermission();

                if (context.mounted) {
                  Navigator.of(context).pop();

                  if (permission == LocationPermission.denied ||
                      permission == LocationPermission.deniedForever) {
                    _showPermissionDeniedDialog(context);
                  } else {
                    _showPermissionGrantedDialog(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Izinkan Akses',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildFeatureItem(
      IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF2E7D32).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Color(0xFF2E7D32),
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static void _showPermissionGrantedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.green[600],
                  size: 32,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Terima Kasih!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Lokasi berhasil diaktifkan. Anda akan mendapatkan jadwal sholat yang akurat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_off,
                  color: Colors.orange[600],
                  size: 32,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Izin Lokasi Ditolak',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Aplikasi akan menggunakan lokasi default (Jakarta) untuk jadwal sholat. Anda dapat mengaktifkan izin lokasi kapan saja di pengaturan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openAppSettings();
              },
              child: Text(
                'Buka Pengaturan',
                style: TextStyle(
                  color: Colors.orange[700],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Check and request permission if needed
  static Future<void> checkAndRequestLocationPermission(
      BuildContext context) async {
    final isFirstLaunch = await PermissionService.isFirstLaunch();
    final hasBeenAsked =
        await PermissionService.hasLocationPermissionBeenAsked();

    if (isFirstLaunch || !hasBeenAsked) {
      await PermissionService.markFirstLaunchComplete();

      // Show dialog after a short delay to ensure the screen is fully loaded
      Future.delayed(Duration(milliseconds: 1000), () {
        if (context.mounted) {
          PermissionService.showLocationPermissionDialog(context);
        }
      });
    }
  }
}
