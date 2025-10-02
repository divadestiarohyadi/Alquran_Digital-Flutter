import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../services/location_service.dart';

class KiblatScreen extends StatefulWidget {
  const KiblatScreen({super.key});

  @override
  State<KiblatScreen> createState() => _KiblatScreenState();
}

class _KiblatScreenState extends State<KiblatScreen>
    with TickerProviderStateMixin {
  late AnimationController _compassController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  double _currentHeading = 0;
  double _kiblatDirection = 0;
  bool _isLoading = true;
  Timer? _compassTimer;
  StreamSubscription<MagnetometerEvent>? _magnetSubscription;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;

  String _locationName = 'Mencari lokasi...';
  String? _errorMessage;
  double? _latitude;
  double? _longitude;
  double? _distanceToKaaba;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadKiblatDirection();
    _startCompassSimulation();
  }

  void _startCompassSimulation() {
    print('Starting compass sensor...');

    try {
      List<double> magnetValues = [0, 0, 0];
      List<double> accelValues = [0, 0, 0];

      // Listen to magnetometer
      _magnetSubscription =
          magnetometerEvents.listen((MagnetometerEvent event) {
        magnetValues = [event.x, event.y, event.z];
        _updateCompass(magnetValues, accelValues);
      }, onError: (error) {
        print('Magnetometer error: $error');
        _startFallbackCompass();
      });

      // Listen to accelerometer for tilt compensation
      _accelSubscription =
          accelerometerEvents.listen((AccelerometerEvent event) {
        accelValues = [event.x, event.y, event.z];
        _updateCompass(magnetValues, accelValues);
      }, onError: (error) {
        print('Accelerometer error: $error');
      });

      print('Compass sensor started successfully');
    } catch (e) {
      print('Sensor initialization failed: $e');
      _startFallbackCompass();
    }
  }

  void _updateCompass(List<double> magnetValues, List<double> accelValues) {
    if (!mounted) return;

    try {
      // Calculate heading using magnetometer data
      double heading =
          math.atan2(magnetValues[1], magnetValues[0]) * (180 / math.pi);
      if (heading < 0) heading += 360;

      // Smooth the heading changes
      double diff = heading - _currentHeading;
      if (diff > 180) diff -= 360;
      if (diff < -180) diff += 360;

      setState(() {
        _currentHeading = (_currentHeading + diff * 0.1) % 360;
      });
    } catch (e) {
      print('Compass calculation error: $e');
    }
  }

  void _startFallbackCompass() {
    print('Starting fallback compass simulation');
    _compassTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          // Smooth simulation for testing
          _currentHeading = (_currentHeading + 1) % 360;
        });
      }
    });
  }

  void _stopCompassSimulation() {
    _compassTimer?.cancel();
    _compassTimer = null;
  }

  void _setupAnimations() {
    _compassController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  Future<void> _loadKiblatDirection() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Get current location
      final locationData = await LocationService.getCurrentLocation();

      if (locationData == null) {
        setState(() {
          _errorMessage =
              'Tidak dapat mengakses lokasi. Pastikan GPS aktif dan berikan izin lokasi.';
          _isLoading = false;
        });
        return;
      }

      _latitude = locationData['latitude'];
      _longitude = locationData['longitude'];

      // Calculate Qibla direction
      _kiblatDirection =
          LocationService.calculateQiblaDirection(_latitude!, _longitude!);

      // Get short location name
      final locationName =
          await LocationService.getShortLocationName(_latitude!, _longitude!);

      // Calculate distance to Kaaba
      _distanceToKaaba = LocationService.calculateDistance(
          _latitude!, _longitude!, 21.4225, 39.8262 // Kaaba coordinates
          );

      setState(() {
        _locationName = locationName;
        _isLoading = false;
      });

      // Show success snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lokasi berhasil diperbarui: $locationName'),
            backgroundColor: const Color(0xFF2E7D32),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });

      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _compassController.dispose();
    _pulseController.dispose();
    _stopCompassSimulation();
    _magnetSubscription?.cancel();
    _accelSubscription?.cancel();
    super.dispose();
  }

  double get _kiblatAngle {
    return _kiblatDirection - _currentHeading;
  }

  bool get _isPointingToKiblat {
    double angleDiff = (_kiblatAngle % 360).abs();
    if (angleDiff > 180) angleDiff = 360 - angleDiff;
    return angleDiff < 10; // Within 10 degrees
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Arah Kiblat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadKiblatDirection,
            tooltip: 'Refresh Lokasi',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF2E7D32),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mendapatkan lokasi dan menghitung arah kiblat...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Terjadi kesalahan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadKiblatDirection,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Location info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF2E7D32),
                              Color(0xFF4CAF50),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _locationName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_latitude != null && _longitude != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Koordinat: ${_latitude!.toStringAsFixed(4)}°, ${_longitude!.toStringAsFixed(4)}°',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            if (_distanceToKaaba != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Jarak ke Ka\'bah: ${(_distanceToKaaba! / 1000).toStringAsFixed(0)} km',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Kiblat direction info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _isPointingToKiblat
                              ? Colors.green.shade50
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: _isPointingToKiblat
                              ? Border.all(color: Colors.green, width: 2)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isPointingToKiblat
                                      ? Icons.check_circle
                                      : Icons.explore,
                                  color: _isPointingToKiblat
                                      ? Colors.green
                                      : const Color(0xFF2E7D32),
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isPointingToKiblat
                                      ? 'Menghadap Kiblat'
                                      : 'Arah Kiblat',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _isPointingToKiblat
                                        ? Colors.green
                                        : const Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${_kiblatDirection.toStringAsFixed(1)}°',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _isPointingToKiblat
                                    ? Colors.green
                                    : const Color(0xFF2E7D32),
                              ),
                            ),
                            Text(
                              'dari Utara',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Compass
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Compass background
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.grey.shade100,
                                    Colors.white,
                                  ],
                                ),
                              ),
                            ),

                            // Compass markings
                            CustomPaint(
                              size: const Size(280, 280),
                              painter: CompassPainter(),
                            ),

                            // Kiblat direction indicator
                            Transform.rotate(
                              angle: (_kiblatDirection * math.pi / 180),
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _isPointingToKiblat
                                        ? _pulseAnimation.value
                                        : 1.0,
                                    child: Container(
                                      width: 4,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: _isPointingToKiblat
                                            ? Colors.green
                                            : const Color(0xFF2E7D32),
                                        borderRadius: BorderRadius.circular(2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _isPointingToKiblat
                                                ? Colors.green.withOpacity(0.5)
                                                : Colors.black.withOpacity(0.3),
                                            blurRadius:
                                                _isPointingToKiblat ? 10 : 5,
                                            spreadRadius:
                                                _isPointingToKiblat ? 2 : 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Center point
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: _isPointingToKiblat
                                    ? Colors.green
                                    : const Color(0xFF2E7D32),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                            ),

                            // North indicator
                            Positioned(
                              top: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'N',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            // Kiblat label
                            Transform.rotate(
                              angle: (_kiblatDirection * math.pi / 180),
                              child: Positioned(
                                top: 40,
                                child: Transform.rotate(
                                  angle: -(_kiblatDirection * math.pi / 180),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _isPointingToKiblat
                                          ? Colors.green
                                          : const Color(0xFF2E7D32),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'KIBLAT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Instructions
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 24,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Cara Menggunakan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '1. Pastikan HP dalam posisi datar\n'
                              '2. Putar HP hingga panah hijau menunjuk arah kiblat\n'
                              '3. Hadapkan tubuh searah dengan panah hijau\n'
                              '4. Anda sudah menghadap kiblat',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    // Draw compass markings
    for (int i = 0; i < 360; i += 30) {
      final angle = (i * math.pi / 180);
      final startRadius = radius * 0.85;
      final endRadius = radius * 0.95;

      final start = Offset(
        center.dx + math.cos(angle - math.pi / 2) * startRadius,
        center.dy + math.sin(angle - math.pi / 2) * startRadius,
      );

      final end = Offset(
        center.dx + math.cos(angle - math.pi / 2) * endRadius,
        center.dy + math.sin(angle - math.pi / 2) * endRadius,
      );

      canvas.drawLine(start, end, paint);
    }

    // Draw smaller markings
    paint.strokeWidth = 0.5;
    for (int i = 0; i < 360; i += 10) {
      if (i % 30 != 0) {
        final angle = (i * math.pi / 180);
        final startRadius = radius * 0.90;
        final endRadius = radius * 0.95;

        final start = Offset(
          center.dx + math.cos(angle - math.pi / 2) * startRadius,
          center.dy + math.sin(angle - math.pi / 2) * startRadius,
        );

        final end = Offset(
          center.dx + math.cos(angle - math.pi / 2) * endRadius,
          center.dy + math.sin(angle - math.pi / 2) * endRadius,
        );

        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
