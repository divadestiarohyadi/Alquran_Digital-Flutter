import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  static Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude,
          localeIdentifier: 'id_ID' // Indonesian locale for better results
          );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Build address parts in priority order
        List<String> addressParts = [];

        // Add street or name if available
        if (place.name != null &&
            place.name!.isNotEmpty &&
            place.name != place.locality) {
          addressParts.add(place.name!);
        }

        // Add subLocality (like area/district)
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }

        // Add locality (city/town)
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }

        // Add subAdministrativeArea (like regency/kabupaten)
        if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty &&
            place.subAdministrativeArea != place.locality) {
          addressParts.add(place.subAdministrativeArea!);
        }

        // Add administrativeArea (province/state)
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }

        // Add country as fallback
        if (addressParts.isEmpty &&
            place.country != null &&
            place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        // Return formatted address or fallback
        if (addressParts.isNotEmpty) {
          return addressParts.join(', ');
        } else {
          return 'Lokasi Tidak Dikenali';
        }
      }
      return 'Lokasi Tidak Ditemukan';
    } catch (e) {
      print('Error getting address: $e');
      return 'Gagal Mendapatkan Alamat';
    }
  }

  static Future<Map<String, double>?> getCurrentLocation() async {
    final position = await getCurrentPosition();
    if (position != null) {
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    }
    // Return Jakarta coordinates as fallback
    return {
      'latitude': -6.2088,
      'longitude': 106.8456,
    };
  }

  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Get short location name (city, province format)
  static Future<String> getShortLocationName(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude,
          localeIdentifier: 'id_ID' // Indonesian locale
          );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        String cityName = '';
        String provinceName = '';

        // Get city name (priority: locality > subAdministrativeArea > name)
        if (place.locality != null && place.locality!.isNotEmpty) {
          cityName = place.locality!;
        } else if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty) {
          cityName = place.subAdministrativeArea!;
        } else if (place.name != null && place.name!.isNotEmpty) {
          cityName = place.name!;
        }

        // Get province name
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          provinceName = place.administrativeArea!;
        }

        // Format the result
        if (cityName.isNotEmpty && provinceName.isNotEmpty) {
          return '$cityName, $provinceName';
        } else if (cityName.isNotEmpty) {
          return cityName;
        } else if (provinceName.isNotEmpty) {
          return provinceName;
        } else {
          return 'Lokasi Saat Ini';
        }
      }
      return 'Lokasi Tidak Diketahui';
    } catch (e) {
      print('Error getting short location: $e');
      return 'Lokasi Saat Ini';
    }
  }

  // Calculate Qibla direction (bearing to Kaaba in Mecca)
  static double calculateQiblaDirection(double latitude, double longitude) {
    // Kaaba coordinates
    const double kaabaLat = 21.4225;
    const double kaabaLon = 39.8262;

    return Geolocator.bearingBetween(latitude, longitude, kaabaLat, kaabaLon);
  }
}
