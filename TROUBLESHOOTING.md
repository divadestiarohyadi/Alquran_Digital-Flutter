# Troubleshooting APK Alqurandigital

## Jika APK Tidak Bisa Dibuka

### 1. Masalah Instalasi

- **Aktifkan "Sumber Tidak Dikenal"**
  - Buka **Pengaturan** > **Keamanan** > **Install app dari sumber tidak dikenal**
  - Atau **Pengaturan** > **Aplikasi** > **Install dari sumber tidak dikenal**

### 2. Kompatibilitas Android

- **Minimum Android**: Android 5.0 (API 21)
- **Target Android**: Android 13 (API 33)
- **Rekomendasi**: Android 7.0+ untuk performa optimal

### 3. Jika App Crash saat Dibuka

- **Restart HP** setelah instalasi
- **Clear cache** aplikasi di pengaturan Android
- **Reinstall APK** (hapus dulu, install ulang)

### 4. Permission Issues

- Saat pertama buka, izinkan **semua permission** yang diminta:
  - ✅ Location/Lokasi
  - ✅ Storage/Penyimpanan
  - ✅ Internet

### 5. Masalah Sensor Kompas

- Jika kompas tidak bergerak: Kalibrasi kompas HP (gerakkan figure-8)
- Beberapa HP tidak punya sensor magnetometer (normal)

### 6. Debug Steps

1. **Install APK** dengan cara manual (jangan lewat Play Store)
2. **Buka aplikasi** dan tunggu loading selesai
3. **Test fitur satu per satu**:
   - Home (Al-Qur'an) ✓
   - Search (Hadist) ✓
   - History (Riwayat) ✓
   - Settings (Pengaturan) ✓

### 7. Error Log

Jika masih error, cek **Logcat** atau **Developer Options**:

- Aktifkan **USB Debugging**
- Jalankan `adb logcat` untuk melihat error detail

### 8. Fallback Options

- Gunakan **Chrome browser** untuk versi web
- Install **Flutter** untuk development mode
- Build ulang dengan `flutter build apk --debug`

## Kontak

Jika masih ada masalah, hubungi developer dengan info:

- Model HP
- Versi Android
- Error message (screenshot)
- Langkah yang sudah dicoba
