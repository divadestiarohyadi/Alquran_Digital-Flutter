import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color backgroundGrey = Color(0xFFF5F5F5);

  static ThemeData get theme => ThemeData(
        primarySwatch: Colors.green,
        primaryColor: primaryGreen,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: backgroundGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryGreen,
          unselectedItemColor: Colors.grey,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        useMaterial3: true,
      );
}

class AppColors {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color cardWhite = Colors.white;
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);
  static const Color meccanOrange = Color(0xFFFF9800);
  static const Color medinanBlue = Color(0xFF2196F3);
}

class AppStrings {
  static const String appName = 'Al-Qur\'an Digital';
  static const String bismillah = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';

  // Navigation
  static const String quran = 'Al-Qur\'an';
  static const String search = 'Pencarian';
  static const String bookmark = 'Bookmark';
  static const String settings = 'Pengaturan';

  // Messages
  static const String noSearchResults = 'Tidak ada hasil yang ditemukan';
  static const String startTyping = 'Mulai mengetik untuk mencari surah';
  static const String noBookmarks = 'Belum ada ayat yang di-bookmark';
  static const String ayahCopied = 'Ayat berhasil disalin';
  static const String ayahBookmarked = 'Ayat berhasil di-bookmark';
  static const String bookmarkRemoved = 'Bookmark berhasil dihapus';
}

class AppDimensions {
  static const double padding = 16.0;
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;

  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;
}
