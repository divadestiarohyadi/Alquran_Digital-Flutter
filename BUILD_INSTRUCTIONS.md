# 📱 PANDUAN MEMBUAT RELEASE APK - Apps Kurir

## 🚨 MASALAH SAAT INI

Aplikasi mengalami konflik dependency antara:

- Flutter SDK (Android API 33)
- Dependencies yang memerlukan Android API 34
- Android Gradle Plugin 7.3.0

## ✅ SOLUSI YANG SUDAH DICOBA

1. ✅ Downgrade dependencies ke versi kompatibel
2. ✅ Update notification service untuk kompatibilitas
3. ✅ Bypass AAR metadata check
4. ✅ Force dependency resolution
5. ❌ Build masih gagal karena sistem konflik

## 🔧 SOLUSI REKOMENDASI

### OPSI 1: Menggunakan Android Studio (PALING MUDAH)

1. Buka Android Studio
2. Open project folder: `c:\laragon\www\apps_kurir`
3. Tunggu sync selesai
4. Klik "Build" → "Build Bundle(s) / APK(s)" → "Build APK(s)"
5. APK akan tersedia di `app/build/outputs/apk/release/`

### OPSI 2: Update Environment (Butuh Waktu)

```bash
# 1. Update Flutter ke versi terbaru
flutter upgrade

# 2. Update Android SDK ke API 34
# Buka Android Studio → SDK Manager → Install API 34

# 3. Clean dan rebuild
flutter clean
flutter pub get
flutter build apk --release
```

### OPSI 3: Menggunakan GitHub Actions / CI (Cloud Build)

Buat file `.github/workflows/build.yml` untuk build otomatis di cloud.

## 📱 STATUS APLIKASI

- ✅ Code berfungsi dengan baik (web sudah jalan)
- ✅ Hadith API integration berhasil
- ✅ Dark mode support
- ✅ UI fixes completed
- ✅ **APK RELEASE BERHASIL DIBUAT!**

## � APK BERHASIL DIBUAT!

**File APK tersedia di:**
📱 `build/app/outputs/flutter-apk/app-release.apk` (21.4MB)

### Masalah yang Berhasil Diperbaiki:

1. ✅ Downgrade Android Gradle Plugin ke versi kompatibel (7.2.0)
2. ✅ Sesuaikan konfigurasi dependencies dengan Android API 33
3. ✅ Perbaiki flutter_local_notifications API untuk versi 8.2.0
4. ✅ Tambahkan konfigurasi AndroidManifest.xml untuk Android 12+
5. ✅ Sesuaikan gradle.properties dan wrapper

## 🚀 CARA INSTALL APK

1. Transfer file `app-release.apk` ke device Android
2. Enable "Install from Unknown Sources" di Settings
3. Tap file APK dan install
4. Aplikasi siap digunakan!

## 📂 LOKASI FILE APK (Setelah Berhasil Build)

- Release APK: `build/app/outputs/flutter-apk/app-release.apk`
- Debug APK: `build/app/outputs/flutter-apk/app-debug.apk`

## 🔍 TROUBLESHOOTING

Jika Android Studio juga gagal:

1. File → Invalidate Caches and Restart
2. Tools → SDK Manager → Update semua SDK
3. Gradle → Refresh Gradle Project

---

**Note:** Aplikasi sudah berfungsi dengan baik, hanya masalah build environment saja.
