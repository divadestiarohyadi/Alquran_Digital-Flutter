# Panduan Instalasi Alqurandigital

## Download APK

APK terbaru tersedia di: `build\app\outputs\flutter-apk\app-release.apk` (21.2MB)

## Instalasi di Android

1. Buka **Pengaturan** > **Keamanan**
2. Aktifkan **"Sumber tidak dikenal"** atau **"Install dari sumber lain"**
3. Buka file APK yang sudah didownload
4. Tap **Install**
5. Berikan izin yang diminta (Location, dll)

## Fitur Yang Diperbaiki

### ✅ Layout Header Surah

- **Masalah**: Teks Arab bertabrakan dengan nama Latin surah
- **Solusi**: Pindahkan info "mekah • 52 Ayat" ke atas teks Arab
- **Hasil**: Layout lebih rapi dan mudah dibaca
- **Perubahan**:
  - Info ayat & lokasi wahyu sekarang di atas teks Arab
  - Teks Arab diperbesar dan diberi spacing yang lebih baik
  - Title Latin dengan padding yang tepat

### ✅ Kompas Kiblat

- Menggunakan sensor magnetometer dan accelerometer
- Fallback ke simulasi jika sensor tidak tersedia
- Lebih akurat dengan tilt compensation
- Debug logging untuk troubleshooting

### ✅ Nama Aplikasi

- Nama berubah dari "apps_kurir" menjadi **"Alqurandigital"**
- Package name: `com.example.alqurandigital`

### ✅ Permission Sensor

- Ditambahkan permission untuk sensor kompas
- Support untuk perangkat tanpa sensor (fallback)

## Testing Kompas

1. Buka tab **"Al-Qur'an"**
2. Pilih **"Kiblat"**
3. Izinkan akses lokasi
4. Kompas akan menunjukkan arah kiblat
5. Jika sensor tidak tersedia, akan menggunakan simulasi

## Troubleshooting

- Jika kompas tidak bergerak: Pastikan device memiliki magnetometer
- Jika arah tidak akurat: Kalibrasi kompas device (gerakkan figure-8)
- Check console log untuk debug info

## Build Info

- Flutter SDK: 3.13.2
- Target SDK: Android 33
- Size: 21.2MB
- Permissions: Location, Internet, Sensor
