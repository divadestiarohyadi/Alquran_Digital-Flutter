import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/permission_service.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _arabicTextOnly = false;
  bool _showTranslation = true;
  bool _nightMode = false;
  double _fontSize = 20;
  bool _locationEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      // Load all settings from SharedPreferences
      final arabicTextOnly = await SettingsService.getArabicTextOnly();
      final showTranslation = await SettingsService.getShowTranslation();
      final nightMode = await SettingsService.getNightMode();
      final fontSize = await SettingsService.getFontSize();

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      final locationEnabled = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;

      setState(() {
        _arabicTextOnly = arabicTextOnly;
        _showTranslation = showTranslation;
        _nightMode = nightMode;
        _fontSize = fontSize;
        _locationEnabled = locationEnabled;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkLocationStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    setState(() {
      _locationEnabled = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    });
  }

  Future<void> _resetSettings() async {
    try {
      // Reset all settings to default values
      await SettingsService.resetToDefaults();

      // Reload settings from storage
      await _loadSettings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengaturan berhasil direset ke default'),
            backgroundColor: Color(0xFF2E7D32),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal reset pengaturan: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _clearAllData() async {
    try {
      // Clear all stored settings
      await SettingsService.clearAllSettings();

      // Reset to default values in UI
      setState(() {
        _arabicTextOnly = false;
        _showTranslation = true;
        _nightMode = false;
        _fontSize = 20.0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Semua data pengaturan berhasil dihapus'),
            backgroundColor: Color(0xFF2E7D32),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSettings,
            tooltip: 'Refresh Pengaturan',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2E7D32),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Display Settings
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pengaturan Tampilan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Font Size
                        const Text('Ukuran Teks Arab'),
                        Slider(
                          value: _fontSize,
                          min: 14,
                          max: 32,
                          divisions: 9,
                          label: _fontSize.round().toString(),
                          activeColor: const Color(0xFF2E7D32),
                          onChanged: (value) async {
                            setState(() {
                              _fontSize = value;
                            });
                            await SettingsService.setFontSize(value);
                          },
                        ),
                        Text(
                          'Contoh: وَمِنَ النَّاسِ مَن يَقُولُ آمَنَّا بِاللَّهِ',
                          style: TextStyle(fontSize: _fontSize),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Arabic Text Only
                        SwitchListTile(
                          title: const Text('Hanya Teks Arab'),
                          subtitle: const Text('Sembunyikan terjemahan'),
                          value: _arabicTextOnly,
                          activeColor: const Color(0xFF2E7D32),
                          onChanged: (value) async {
                            setState(() {
                              _arabicTextOnly = value;
                              // Jika hanya teks arab diaktifkan, otomatis matikan terjemahan
                              if (value) {
                                _showTranslation = false;
                              }
                            });
                            await SettingsService.setArabicTextOnly(value);
                            if (value) {
                              await SettingsService.setShowTranslation(false);
                            }
                          },
                        ),

                        // Show Translation
                        SwitchListTile(
                          title: const Text('Tampilkan Terjemahan'),
                          subtitle:
                              const Text('Menampilkan terjemahan Indonesia'),
                          value: _showTranslation,
                          activeColor: const Color(0xFF2E7D32),
                          onChanged: _arabicTextOnly
                              ? null
                              : (value) async {
                                  setState(() {
                                    _showTranslation = value;
                                  });
                                  await SettingsService.setShowTranslation(
                                      value);
                                },
                        ),

                        // Night Mode
                        SwitchListTile(
                          title: const Text('Mode Malam'),
                          subtitle:
                              const Text('Tema gelap untuk mata yang nyaman'),
                          value: _nightMode,
                          activeColor: const Color(0xFF2E7D32),
                          onChanged: (value) async {
                            setState(() {
                              _nightMode = value;
                            });
                            await SettingsService.setNightMode(value);
                            // Show snackbar untuk memberitahu user bahwa perubahan akan efektif setelah restart
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Mode malam akan aktif setelah restart aplikasi'),
                                  backgroundColor: const Color(0xFF2E7D32),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Location Settings
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pengaturan Lokasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Location Permission Status
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _locationEnabled
                                ? Colors.green[50]
                                : Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _locationEnabled
                                  ? Colors.green[200]!
                                  : Colors.orange[200]!,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _locationEnabled
                                    ? Icons.location_on
                                    : Icons.location_off,
                                color: _locationEnabled
                                    ? Colors.green[600]
                                    : Colors.orange[600],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _locationEnabled
                                          ? 'Lokasi Aktif'
                                          : 'Lokasi Tidak Aktif',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: _locationEnabled
                                            ? Colors.green[700]
                                            : Colors.orange[700],
                                      ),
                                    ),
                                    Text(
                                      _locationEnabled
                                          ? 'Jadwal sholat sesuai lokasi Anda'
                                          : 'Menggunakan lokasi default (Jakarta)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _locationEnabled
                                            ? Colors.green[600]
                                            : Colors.orange[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Location Action Buttons
                        if (!_locationEnabled) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await PermissionService
                                    .showLocationPermissionDialog(context);
                                _checkLocationStatus(); // Refresh status
                              },
                              icon: const Icon(Icons.location_on),
                              label: const Text('Aktifkan Lokasi'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    await Geolocator.openAppSettings();
                                    _checkLocationStatus(); // Refresh status
                                  },
                                  icon: const Icon(Icons.settings),
                                  label: const Text('Pengaturan'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF2E7D32),
                                    side: const BorderSide(
                                        color: Color(0xFF2E7D32)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _checkLocationStatus,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Refresh'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2E7D32),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // App Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tentang Aplikasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('Versi Aplikasi'),
                          subtitle: const Text('1.0.0'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.star_outline),
                          title: const Text('Beri Rating'),
                          subtitle:
                              const Text('Bantu kami dengan memberikan rating'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Terima kasih atas dukungannya!'),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.share_outlined),
                          title: const Text('Bagikan Aplikasi'),
                          subtitle: const Text(
                              'Ajak teman untuk menggunakan aplikasi ini'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Fitur berbagi akan segera hadir'),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.privacy_tip_outlined),
                          title: const Text('Kebijakan Privasi'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Membuka kebijakan privasi...'),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.restore, color: Colors.orange[700]),
                          title: Text(
                            'Reset Pengaturan',
                            style: TextStyle(color: Colors.orange[700]),
                          ),
                          subtitle:
                              const Text('Kembalikan ke pengaturan default'),
                          onTap: () {
                            _showResetDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.restore, color: Colors.orange[700]),
              const SizedBox(width: 12),
              const Text('Reset Pengaturan'),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin mengembalikan semua pengaturan ke default? Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _resetSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.delete_sweep, color: Colors.red[700]),
              const SizedBox(width: 12),
              const Text('Hapus Data'),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus semua data pengaturan? Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _clearAllData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
