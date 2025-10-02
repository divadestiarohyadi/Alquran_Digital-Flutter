# Solusi APK Alqurandigital Tidak Bisa Dibuka

## 🚨 Masalah Setelah Ganti Nama Package

Setelah mengganti nama dari `apps_kurir` ke `Alqurandigital`, ada beberapa langkah yang harus dilakukan:

### 1. Hapus APK Lama Dulu

```bash
# Di HP Android:
# 1. Buka Pengaturan > Aplikasi
# 2. Cari "apps_kurir" atau "Alqurandigital"
# 3. Tap > Uninstall/Hapus
# 4. Restart HP
```

### 2. Install APK Baru

- **File**: `build\app\outputs\flutter-apk\app-release.apk` (21.4MB)
- **Package**: Sekarang kembali ke `com.example.apps_kurir` (stabil)
- **Display Name**: Tetap "Alqurandigital"

### 3. Langkah Install yang Benar

1. **Hapus cache** Android: Settings > Storage > Cached data > Clear
2. **Aktifkan Developer Mode** (opsional tapi disarankan):
   - Settings > About Phone > Tap Build Number 7x
3. **Aktifkan "Install from Unknown Sources"**:
   - Settings > Security > Unknown Sources ✓
4. **Install APK**:
   - Buka File Manager > Download APK > Install
5. **Restart HP** setelah instalasi

### 4. Debugging Steps

Jika masih crash:

```bash
# A. Cek log error (butuh USB debugging):
adb logcat | grep -i "apps_kurir"

# B. Test step by step:
# 1. Install APK ✓
# 2. Buka app (loading splash screen) ✓
# 3. Izinkan permission lokasi ✓
# 4. Test menu Home/Al-Qur'an ✓
# 5. Test Kiblat ✓
```

### 5. Fallback Solutions

#### Option A: Web Version

```bash
flutter run -d chrome --web-port=8080
# Buka: http://localhost:8080
```

#### Option B: Debug APK

```bash
flutter build apk --debug
# Install debug APK (lebih besar tapi lebih verbose error)
```

#### Option C: Profile Mode

```bash
flutter build apk --profile
# Performance mode dengan some debugging
```

### 6. Kemungkinan Penyebab Crash

| Penyebab              | Solusi                      |
| --------------------- | --------------------------- |
| **Cache conflict**    | Clear cache + restart       |
| **Permission denied** | Manual grant permissions    |
| **Package signature** | Uninstall old + install new |
| **Android version**   | Min Android 5.0 required    |
| **RAM insufficient**  | Close other apps            |
| **Storage full**      | Free up 100MB+ space        |

### 7. Quick Fix Commands

```bash
# Full clean rebuild:
flutter clean
flutter pub get
flutter build apk --release

# Test tanpa install:
flutter run --debug
```

### 8. Kontak Debug Info

Jika masih error, share info:

- **Model HP**: [e.g. Samsung Galaxy A50]
- **Android Version**: [e.g. Android 10]
- **Error Message**: [screenshot/text]
- **Install Step yang Gagal**: [1-5 dari langkah di atas]

---

## ✅ Expected Result

Setelah langkah di atas:

- App name: **"Alqurandigital"**
- Package: `com.example.apps_kurir`
- Size: 21.4MB
- Features: Al-Qur'an, Kiblat, Riwayat, Settings ✓
