import 'package:flutter/material.dart';
import 'quran_home_screen.dart';
import 'search_screen.dart';
import 'reading_history_screen.dart';
import 'settings_screen.dart';
import '../services/permission_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final GlobalKey<ReadingHistoryScreenState> _historyKey =
      GlobalKey<ReadingHistoryScreenState>();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Initialize screens with key for history screen
    _screens = [
      const QuranHomeScreen(),
      const SearchScreen(),
      ReadingHistoryScreen(key: _historyKey),
      const SettingsScreen(),
    ];

    // Check and request location permission when first entering the app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionService.checkAndRequestLocationPermission(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Refresh reading history when navigating to it
          if (index == 2 && _historyKey.currentState != null) {
            _historyKey.currentState!.refreshHistory();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Al-Qur\'an',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Hadist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
