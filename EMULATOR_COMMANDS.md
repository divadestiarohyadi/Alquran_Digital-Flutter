# 🚀 Quick Commands - Run di Emulator

## Status Saat Ini

✅ **Emulator**: Pixel 5 API 30 (emulator-5554) - RUNNING  
✅ **App**: Sedang build dan install ke emulator  
✅ **Mode**: Debug mode (hot reload enabled)

## 🎮 Controls Saat App Running

### Hot Reload & Development

```bash
# Dalam terminal yang sedang running:
r         # Hot reload - apply code changes tanpa restart
R         # Hot restart - restart app completely
p         # Show performance overlay
o         # Toggle platform (Android/iOS rendering)
q         # Quit app dan stop running
h         # Show all commands
```

### Flutter Inspector & Debug

```bash
# Dalam terminal:
i         # Open Flutter Inspector (widget tree)
v         # Launch DevTools in browser
s         # Screenshot app
w         # Dump widget hierarchy to console
t         # Dump render tree to console
```

## 📱 Quick Test Checklist

Setelah app terbuka di emulator:

1. **✓ Launch Test**:

   - App icon muncul di home screen
   - Splash screen tampil
   - Main screen terbuka tanpa crash

2. **✓ Navigation Test**:

   - Bottom navigation (Al-Qur'an, Hadist, Riwayat, Settings)
   - Tap each tab - semua berfungsi

3. **✓ Permission Test**:

   - Location permission popup muncul
   - Accept atau decline permission

4. **✓ Content Test**:

   - Al-Qur'an: Daftar surah muncul
   - Tap surah: Detail buka dengan teks Arab
   - Header bersih tanpa background shapes ✨

5. **✓ Kiblat Test**:
   - Buka Al-Qur'an > Kiblat
   - Kompas muncul (simulasi di emulator)

## 🔄 Common Commands

```bash
# Restart emulator
flutter emulators --launch Pixel_5_API_30

# Check devices
flutter devices

# Run specific device
flutter run -d emulator-5554

# Run release mode di emulator
flutter run -d emulator-5554 --release

# Install APK manual
adb -s emulator-5554 install build\app\outputs\flutter-apk\app-release.apk
```

## 🛠️ Troubleshooting Emulator

### App Tidak Install

```bash
# Check adb connection
adb devices

# Restart adb
adb kill-server
adb start-server

# Clean dan rebuild
flutter clean
flutter pub get
flutter run -d emulator-5554
```

### Performance Issues

```bash
# Enable software rendering jika lag
flutter run -d emulator-5554 --enable-software-rendering

# Close unused apps di emulator
# Allocate more RAM: Android Studio > AVD Manager > Edit
```

### Permission Issues di Emulator

```bash
# Manual grant permission via adb:
adb -s emulator-5554 shell pm grant com.example.apps_kurir android.permission.ACCESS_FINE_LOCATION

# Or via emulator settings:
# Settings > Apps > Alqurandigital > Permissions > Location ✓
```

## 📊 Expected Output

```bash
✅ Connected devices: sdk gphone x86 (emulator-5554)
✅ Launching lib\main.dart on sdk gphone x86 in debug mode...
✅ Running Gradle task 'assembleDebug'...
✅ Built build\app\outputs\flutter-apk\app-debug.apk
✅ Installing build\app\outputs\flutter-apk\app-debug.apk...
✅ Waiting for sdk gphone x86 to report its views...
✅ Syncing files to device sdk gphone x86...
✅ Flutter run key commands.
✅ r Hot reload. 🔥🔥🔥
✅ R Hot restart.
✅ h List all available interactive commands.
✅ d Detach (terminate "flutter run" but leave application running).
✅ c Clear the screen
✅ q Quit (terminate the application on the device).
💡 An Observatory debugger and profiler on sdk gphone x86 is available at: http://127.0.0.1:xxxxx/
```

---

**🎉 Sekarang aplikasi Alqurandigital sedang running di emulator!**  
**Cek emulator Anda - app icon dan splash screen seharusnya sudah muncul.**
