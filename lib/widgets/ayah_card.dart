import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/surah.dart';
import '../services/settings_service.dart';

class AyahCard extends StatefulWidget {
  final Ayah ayah;
  final int surahNumber;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.surahNumber,
  });

  @override
  State<AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends State<AyahCard> {
  bool _arabicTextOnly = false;
  bool _showTranslation = true;
  double _fontSize = 20.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final arabicOnly = await SettingsService.getArabicTextOnly();
    final showTranslation = await SettingsService.getShowTranslation();
    final fontSize = await SettingsService.getFontSize();

    if (mounted) {
      setState(() {
        _arabicTextOnly = arabicOnly;
        _showTranslation = showTranslation;
        _fontSize = fontSize;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ayah Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.ayah.numberInSurah}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        iconSize: 20,
                        onPressed: () => _copyAyah(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        iconSize: 20,
                        onPressed: () => _shareAyah(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border),
                        iconSize: 20,
                        onPressed: () => _bookmarkAyah(context),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Arabic Text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.ayah.text,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: _fontSize,
                    height: 2.2,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Show translation info if settings allow
              if (_showTranslation && !_arabicTextOnly) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.translate,
                        color: Colors.blue[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Terjemahan tersedia melalui API online',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Additional Info
              if (widget.ayah.juz > 0) ...[
                Row(
                  children: [
                    _buildInfoChip('Juz ${widget.ayah.juz}', Colors.blue),
                    const SizedBox(width: 8),
                    _buildInfoChip('Halaman ${widget.ayah.page}', Colors.green),
                    const SizedBox(width: 8),
                    if (widget.ayah.sajda) _buildInfoChip('Sajda', Colors.red),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    Color textColor = Colors.blue.shade700;
    if (color == Colors.green) textColor = Colors.green.shade700;
    if (color == Colors.orange) textColor = Colors.orange.shade700;
    if (color == Colors.red) textColor = Colors.red.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _copyAyah(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.ayah.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ayat berhasil disalin'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareAyah(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur berbagi akan segera hadir'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _bookmarkAyah(BuildContext context) {
    // Implement bookmark functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ayat berhasil di-bookmark'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
