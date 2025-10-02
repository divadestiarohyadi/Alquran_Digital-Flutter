import 'package:flutter/material.dart';
import 'dart:math';

class KiblatScreen extends StatefulWidget {
  const KiblatScreen({super.key});

  @override
  State<KiblatScreen> createState() => _KiblatScreenState();
}

class _KiblatScreenState extends State<KiblatScreen> with TickerProviderStateMixin {
  late AnimationController _compassController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  double _currentHeading = 0;
  double _kiblatDirection = 293; // Default direction (adjust based on location)
  bool _isCalibrating = false;
  String _currentCity = 'Jakarta';
  
  // Sample cities with their Kiblat directions
  final Map<String, double> _cityDirections = {
    'Jakarta': 293.0,
    'Bandung': 294.0,
    'Surabaya': 295.0,
    'Medan': 290.0,
    'Makassar': 290.0,
    'Denpasar': 297.0,
    'Pontianak': 288.0,
    'Balikpapan': 287.0,
    'Palembang': 294.0,
    'Semarang': 294.0,
  };

  @override
  void initState() {
    super.initState();
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
    _startCompassSimulation();
  }

  @override
  void dispose() {
    _compassController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startCompassSimulation() {
    // Simulate compass movement for demo purposes
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _currentHeading += (Random().nextDouble() - 0.5) * 2;
          if (_currentHeading < 0) _currentHeading += 360;
          if (_currentHeading >= 360) _currentHeading -= 360;
        });
        _startCompassSimulation();
      }
    });
  }

  void _calibrateCompass() {
    setState(() {
      _isCalibrating = true;
    });
    
    // Simulate calibration
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isCalibrating = false;
        });
        _showCalibrationComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final kiblatAngle = (_kiblatDirection - _currentHeading) * (pi / 180);
    final isAligned = ((_kiblatDirection - _currentHeading).abs() < 5) || 
                     ((_kiblatDirection - _currentHeading).abs() > 355);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Arah Kiblat'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: _showCityPicker,
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _calibrateCompass,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Location Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentCity,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Arah Kiblat: ${_kiblatDirection.toStringAsFixed(0)}°',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Status Indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isAligned ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isAligned ? Icons.check_circle : Icons.info,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isAligned ? 'Arah Kiblat Tepat' : 'Putar Perangkat Anda',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Compass
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Compass Background
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.grey[100]!,
                              Colors.grey[200]!,
                            ],
                          ),
                        ),
                      ),
                      
                      // Degree Marks
                      ...List.generate(36, (index) {
                        final angle = index * 10;
                        return Transform.rotate(
                          angle: angle * (pi / 180),
                          child: Container(
                            width: 2,
                            height: angle % 30 == 0 ? 20 : 10,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        );
                      }),
                      
                      // Cardinal Directions
                      Positioned(
                        top: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'N',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      
                      // Kiblat Direction Arrow
                      Transform.rotate(
                        angle: kiblatAngle,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: isAligned ? _pulseAnimation.value : 1.0,
                              child: Container(
                                width: 4,
                                height: 100,
                                margin: const EdgeInsets.only(bottom: 40),
                                decoration: BoxDecoration(
                                  color: isAligned ? Colors.green : const Color(0xFF2E7D32),
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isAligned ? Colors.green : const Color(0xFF2E7D32))
                                          .withOpacity(0.5),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 0,
                                      height: 0,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Colors.transparent,
                                            width: 8,
                                          ),
                                          right: BorderSide(
                                            color: Colors.transparent,
                                            width: 8,
                                          ),
                                          bottom: BorderSide(
                                            color: isAligned ? Colors.green : const Color(0xFF2E7D32),
                                            width: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Center Point
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2E7D32),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      
                      // Kaaba Icon
                      if (isAligned)
                        Positioned(
                          top: 80,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Compass Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCompassDetail('Heading', '${_currentHeading.toStringAsFixed(0)}°'),
                _buildCompassDetail('Kiblat', '${_kiblatDirection.toStringAsFixed(0)}°'),
                _buildCompassDetail(
                  'Jarak', 
                  '${((_kiblatDirection - _currentHeading).abs()).toStringAsFixed(0)}°'
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Calibration Status
            if (_isCalibrating)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'Kalibrasi Kompas...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Putar perangkat Anda dalam gerakan angka 8',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            
            // Action Buttons
            if (!_isCalibrating) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _calibrateCompass,
                      icon: const Icon(Icons.tune),
                      label: const Text('Kalibrasi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showCityPicker,
                      icon: const Icon(Icons.location_city),
                      label: const Text('Pilih Kota'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Color(0xFF2E7D32)),
                        SizedBox(width: 8),
                        Text(
                          'Cara Menggunakan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Pastikan perangkat dalam posisi datar\n'
                      '2. Jauhkan dari benda logam atau elektronik\n'
                      '3. Putar perangkat hingga panah hijau menunjuk ke atas\n'
                      '4. Hadapkan badan Anda ke arah panah',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompassDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Lokasi Anda',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _cityDirections.entries.map((entry) => ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(entry.key),
                  subtitle: Text('Arah Kiblat: ${entry.value.toStringAsFixed(0)}°'),
                  onTap: () {
                    setState(() {
                      _currentCity = entry.key;
                      _kiblatDirection = entry.value;
                    });
                    Navigator.pop(context);
                  },
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCalibrationComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Kalibrasi Selesai'),
          ],
        ),
        content: const Text(
          'Kompas telah berhasil dikalibrasi. Sekarang Anda dapat menggunakan arah kiblat dengan lebih akurat.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}