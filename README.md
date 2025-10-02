# 📖 Alquran Digital - Aplikasi Al-Qur'an & Hadist

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

**Aplikasi Al-Qur'an Digital yang komprehensif dengan fitur lengkap untuk membaca, mempelajari, dan mengamalkan kitab suci**

[📱 Download APK](https://drive.google.com/file/d/1pZATImaulrlrlrGC9MMqYXQvfX1R6YmW/view) • [🚀 Getting Started](#-getting-started) • [📖 Documentation](#-documentation) • [🤝 Contributing](#-contributing)

</div>

---

## ✨ Fitur Utama

### 📚 **Al-Qur'an Digital**

- ✅ **114 Surah Lengkap** dengan teks Arab asli
- ✅ **Terjemahan Bahasa Indonesia**
- ✅ **Audio Murotal** (streaming)
- ✅ **Pencarian Surah** berdasarkan nama/nomor
- ✅ **Bookmark Ayat** untuk bacaan favorit
- ✅ **Riwayat Bacaan** otomatis
- ✅ **Font Size Control** (14px - 32px)
- ✅ **Mode Gelap/Terang**

### 🕌 **Kiblat & Waktu Sholat**

- ✅ **Kompas Kiblat Digital** dengan sensor magnetometer
- ✅ **Deteksi Lokasi Otomatis** (GPS)
- ✅ **Jadwal Sholat Harian** sesuai lokasi
- ✅ **Notifikasi Adzan** dengan reminder
- ✅ **Fallback Jakarta** jika GPS tidak tersedia

### 📜 **Hadist & Doa**

- ✅ **Hadist Sahih** dari berbagai kitab
- ✅ **Doa Harian** lengkap dengan Arab & terjemahan
- ✅ **Kategorisasi** berdasarkan tema
- ✅ **Search Function** dalam hadist

### ⚙️ **Pengaturan Lanjutan**

- ✅ **Sinkronisasi Data** dengan SharedPreferences
- ✅ **Permission Management** yang user-friendly
- ✅ **Offline Mode** untuk fitur utama
- ✅ **Clean UI** tanpa iklan mengganggu

---

## 🏗️ Struktur Aplikasi

```
lib/
├── main.dart                     # Entry point aplikasi
├── models/                       # Data models
│   ├── api_models.dart          # API response models
│   ├── surah.dart              # Surah data structure
│   └── ayah.dart               # Ayah data structure
├── screens/                      # UI Screens
│   ├── main_navigation_screen.dart  # Bottom navigation
│   ├── quran_home_screen.dart      # Al-Qur'an home
│   ├── api_surah_detail_screen.dart # Surah detail & ayat
│   ├── kiblat_screen.dart          # Kompas kiblat
│   ├── prayer_times_screen.dart    # Jadwal sholat
│   ├── hadist_screen.dart          # Hadist collection
│   ├── doa_screen.dart             # Doa harian
│   ├── reading_history_screen.dart # Riwayat bacaan
│   ├── bookmark_screen.dart        # Ayat tersimpan
│   └── settings_screen.dart        # Pengaturan
├── services/                     # Business Logic
│   ├── quran_api_service.dart   # Al-Qur'an API
│   ├── hadist_api_service.dart  # Hadist API
│   ├── prayer_times_service.dart # Waktu sholat
│   ├── location_service.dart    # GPS & lokasi
│   ├── permission_service.dart  # Permission handler
│   ├── notification_service.dart # Push notification
│   ├── reading_history_service.dart # History management
│   └── settings_service.dart    # App preferences
├── widgets/                      # Reusable Components
│   ├── api_surah_card.dart      # Surah list item
│   ├── api_ayah_card.dart       # Ayah display
│   └── loading_widget.dart      # Loading indicators
└── utils/                        # Utilities
    ├── constants.dart           # App constants
    ├── text_utils.dart         # Text formatting
    └── date_utils.dart         # Date helpers
```

---

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.13.2+
- Dart SDK 3.1.0+
- Android Studio / VS Code
- Android SDK (API 21-33)
- Git

### 📥 Installation

1. **Clone Repository**

```bash
git clone https://github.com/divadestiarohyadi/Aplikasi_AlquranDigital.git
cd Aplikasi_AlquranDigital
```

2. **Install Dependencies**

```bash
flutter pub get
```

3. **Run Application**

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device-id>
```

### 🔧 Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK (Recommended)
flutter build apk --release

# Split APK by architecture
flutter build apk --split-per-abi
```

---

## 📱 Download

### Latest Release

- **Version**: 1.0.0
- **Size**: 21.4MB
- **Min Android**: 5.0 (API 21)
- **Target Android**: 13 (API 33)

📦 [**Download APK**](https://drive.google.com/file/d/1pZATImaulrlrlrGC9MMqYXQvfX1R6YmW/view)

### Installation Guide

1. Enable **"Install from Unknown Sources"** di Android Settings
2. Download APK dari release page
3. Install dan buka aplikasi
4. Grant **Location Permission** saat diminta
5. Enjoy! 🎉

---

## 🛠️ Development

### Run di Emulator

```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch Pixel_5_API_30

# Run app
flutter run -d emulator-5554
```

### Hot Reload Commands

- `r` - Hot reload
- `R` - Hot restart
- `p` - Performance overlay
- `q` - Quit application

### Debug & Testing

```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Check dependencies
flutter doctor

# Format code
dart format .
```

---

## 🌐 API & Data Sources

### Al-Qur'an API

- **Primary**: [Quran API](https://quran-api.santrikoding.com/)
- **Fallback**: Local JSON data
- **Features**: Arab text, translations

### Hadist API

- **Source**: [Hadith API](https://api.hadith.gading.dev)
- **Collections**: Bukhari, Muslim, Tirmidzi, dll
- **Language**: Arabic + Indonesian

### Prayer Times

- **Service**: [Aladhan API](https://aladhan.com/prayer-times-api)
- **Method**: Islamic Society of North America (ISNA)
- **Timezone**: Auto-detect atau manual

### Location Services

- **GPS**: Geolocator package
- **Fallback**: Jakarta coordinates (-6.2088, 106.8456)
- **Geocoding**: Address resolution

---

## 📋 Dependencies

### Core Dependencies

```yaml
dependencies:
  flutter: sdk
  http: ^1.1.0 # API requests
  shared_preferences: ^2.0.15 # Local storage
  geolocator: ^8.2.1 # GPS location
  geocoding: ^2.0.4 # Address conversion
  sensors_plus: ^3.0.1 # Compass sensor
  flutter_local_notifications: ^8.2.0 # Push notifications
  timezone: ^0.8.0 # Timezone handling
```

### Development Dependencies

```yaml
dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^2.0.0
```

---

## 🎨 Design System

### Color Palette

```dart
// Primary Colors
Color primary = Color(0xFF2E7D32);      // Islamic Green
Color primaryLight = Color(0xFF4CAF50);  // Light Green
Color primaryDark = Color(0xFF1B5E20);   // Dark Green

// Accent Colors
Color accent = Color(0xFFFFC107);        // Gold
Color background = Color(0xFFF5F5F5);    // Light Grey
Color surface = Color(0xFFFFFFFF);       // White
```

### Typography

```dart
// Arabic Text
FontFamily: 'Amiri', 'Noto Sans Arabic'
FontSize: 18-32px (adjustable)

// Latin Text
FontFamily: 'Roboto', 'Open Sans'
FontSize: 14-18px
```

---

## 🔒 Permissions

### Android Permissions

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.WAKE_LOCK" />

<!-- Optional sensor permissions -->
<uses-feature android:name="android.hardware.sensor.accelerometer" android:required="false" />
<uses-feature android:name="android.hardware.sensor.compass" android:required="false" />
```

### Privacy Policy

- **Location**: Hanya untuk kiblat dan waktu sholat
- **Storage**: Preference lokal, tidak di-upload
- **Network**: API calls untuk content, no tracking
- **Sensors**: Kompas untuk kiblat direction

---


## 🗺️ Roadmap

### ✅ Completed (v1.0.0)

- [x] Al-Qur'an dengan 114 surah
- [x] Kiblat direction dengan kompas
- [x] Hadist collection
- [x] Doa harian
- [x] Prayer times
- [x] Reading history
- [x] Bookmark system
- [x] Settings & preferences

### 🚧 In Progress (v1.1.0)

- [ ] Audio murotal streaming
- [ ] Tafsir Al-Qur'an
- [ ] Advanced search dalam ayat
- [ ] Export ayat ke image/PDF
- [ ] Widget untuk home screen

### 🔮 Future Plans (v2.0.0)

- [ ] Multi-language support
- [ ] Cloud sync untuk bookmark
- [ ] Social sharing features
- [ ] Islamic calendar integration
- [ ] Qibla finder dengan AR
- [ ] Voice search
- [ ] Offline maps untuk kiblat

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### 📝 Development Guidelines

1. **Fork** the repository
2. **Create** feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** changes (`git commit -m 'Add amazing feature'`)
4. **Push** to branch (`git push origin feature/amazing-feature`)
5. **Open** Pull Request

### 🐛 Bug Reports

- Use [GitHub Issues](https://github.com/divadestiarohyadi/Aplikasi_AlquranDigital/issues)
- Include device info, Android version, steps to reproduce
- Add screenshots jika memungkinkan

### 💡 Feature Requests

- Check existing issues terlebih dahulu
- Explain use case dan benefit untuk users
- Mockup atau wireframe sangat membantu

### 📋 Code Style

```bash
# Format kode sebelum commit
dart format .

# Analyze untuk quality check
flutter analyze

# Run tests
flutter test
```

---

## 📄 License

```
MIT License

Copyright (c) 2025 Diva Destia Rohyadi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👥 Team

<div align="center">

**Diva Destia Rohyadi**  
_Lead Developer & Designer_

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/divadestiarohyadi)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/divadestiarohyadi)

</div>

---

## 🙏 Acknowledgments

- **Al-Qur'an API** - quran-api.santrikoding.com untuk data surah
- **Hadith API** - Gading.dev untuk hadist collection
- **Aladhan API** - Prayer times calculation
- **Flutter Community** - Amazing framework dan plugins
- **Islamic Community** - Feedback dan testing
- **Open Source Contributors** - Dependencies yang digunakan

---

<div align="center">

**Dibuat dengan ❤️ untuk umat Muslim di seluruh dunia**

_Barakallahu fiikum - Semoga Allah memberkahi kalian_

[![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-blue.svg)](https://flutter.dev)
[![GitHub release](https://img.shields.io/github/release/divadestiarohyadi/Aplikasi_AlquranDigital.svg)](https://GitHub.com/divadestiarohyadi/Aplikasi_AlquranDigital/releases/)
[![GitHub stars](https://img.shields.io/github/stars/divadestiarohyadi/Aplikasi_AlquranDigital.svg?style=social&label=Star)](https://GitHub.com/divadestiarohyadi/Aplikasi_AlquranDigital/stargazers/)

**⭐ Jika aplikasi ini bermanfaat, berikan bintang di GitHub! ⭐**

</div>
