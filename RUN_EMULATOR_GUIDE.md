# Panduan Run Aplikasi di Emulator Android

## 🔧 Persiapan Emulator

### 1. Install Android Studio
```bash
# Download dari: https://developer.android.com/studio
# Install dengan semua komponen default
```

### 2. Setup Android SDK & Tools
```bash
# Buka Android Studio > More Actions > SDK Manager
# Install:
✓ Android SDK Platform (API 33, 31, 30)
✓ Android SDK Build-Tools  
✓ Android Emulator
✓ Android SDK Platform-Tools
✓ Intel x86 Emulator Accelerator (HAXM) atau AMD Processor
```

### 3. Buat AVD (Android Virtual Device)
```bash
# Android Studio > More Actions > AVD Manager > Create Virtual Device
# Pilih:
- Device: Pixel 4 atau Pixel 6
- System Image: API 30 (Android 11) atau API 33 (Android 13)
- RAM: 2048MB+
- Storage: 6GB+
```

## 🚀 Cara Run di Emulator

### Method 1: Dari VS Code
```bash
# 1. Buka terminal di VS Code
cd c:\laragon\www\apps_kurir

# 2. Start emulator (jika belum jalan)
flutter emulators --launch <emulator_name>

# 3. Cek device available
flutter devices

# 4. Run aplikasi
flutter run
# atau untuk debug mode:
flutter run --debug
# atau untuk release mode:
flutter run --release
```

### Method 2: Dari Command Line
```powershell
# 1. Start emulator manual
# Buka Android Studio > AVD Manager > Play button

# 2. Navigate ke project
cd c:\laragon\www\apps_kurir

# 3. Run aplikasi
flutter run

# Output yang diharapkan:
# Connected devices:
# sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64 • Android 11 (API 30)
# [1]: sdk gphone64 x86 64 (emulator-5554)
# Please choose one (or "q" to quit): 1
```

### Method 3: Direct Install APK
```bash
# 1. Start emulator
# 2. Install APK ke emulator
adb install build\app\outputs\flutter-apk\app-release.apk

# 3. Launch manual dari emulator home screen
```

## 🛠️ Troubleshooting Emulator

### Emulator Tidak Muncul
```bash
# Cek emulator list
flutter emulators

# Jika kosong, buat emulator baru:
# Android Studio > AVD Manager > Create Virtual Device

# Cek ANDROID_HOME environment variable
echo $ANDROID_HOME
# Should point to: C:\Users\[username]\AppData\Local\Android\Sdk
```

### Performance Issues
```bash
# Enable hardware acceleration:
# 1. Enable Hyper-V (Windows)
# 2. Or install Intel HAXM
# 3. Di AVD settings: Graphics = Hardware - GLES 2.0

# Allocate more RAM:
# AVD Manager > Edit > Advanced Settings > RAM: 4096MB
```

### Emulator Commands
```bash
# List available emulators
flutter emulators

# Launch specific emulator  
flutter emulators --launch Pixel_4_API_30

# Kill all emulators
adb kill-server

# Restart adb
adb start-server

# Check connected devices
adb devices
flutter devices
```

## 🎯 Quick Start Commands

```powershell
# Full setup dari awal:
cd c:\laragon\www\apps_kurir
flutter clean
flutter pub get

# Start emulator (pilih salah satu):
flutter emulators --launch Pixel_4_API_30
# atau buka manual dari Android Studio

# Run aplikasi
flutter run

# Hot reload: tekan 'r' di terminal
# Hot restart: tekan 'R' di terminal  
# Quit: tekan 'q' di terminal
```

## 📱 Recommended Emulator Settings

| Setting | Value | Reason |
|---------|-------|---------|
| **Device** | Pixel 4/6 | Standard Android |
| **API Level** | 30-33 | Target compatibility |
| **RAM** | 2048-4096MB | Smooth performance |
| **Storage** | 6GB+ | App + cache space |
| **Graphics** | Hardware GLES 2.0 | Kompas sensor simulation |

## 🔍 Debug di Emulator

```bash
# Run dengan verbose logging
flutter run --verbose

# Check logcat untuk errors
adb logcat | findstr "flutter"

# Install debug APK untuk detailed errors
flutter build apk --debug
adb install build\app\outputs\flutter-apk\app-debug.apk
```

## ✅ Verifikasi App Features

Setelah run di emulator, test:

1. **Launch** ✓ - App buka tanpa crash
2. **Navigation** ✓ - Bottom tabs berfungsi  
3. **Al-Qur'an** ✓ - Surah list dan detail
4. **Kiblat** ✓ - Kompas (simulasi di emulator)
5. **Permission** ✓ - Location popup muncul
6. **Settings** ✓ - Font size, preferences

---

## 🚨 Common Issues

| Error | Solution |
|-------|----------|
| `No devices found` | Start emulator first |
| `adb not found` | Add Android SDK to PATH |
| `Emulator slow` | Enable hardware acceleration |
| `Build failed` | Run `flutter clean` first |
| `Permission denied` | Grant location in emulator settings |

**Sekarang coba jalankan dengan:** `flutter run` setelah emulator sudah menyala! 🚀