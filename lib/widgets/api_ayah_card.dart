import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/api_models.dart';
import '../utils/text_utils.dart';

class ApiAyahCard extends StatefulWidget {
  final ApiAyah ayah;
  final double fontSize;
  final int surahNumber;

  const ApiAyahCard({
    super.key,
    required this.ayah,
    required this.fontSize,
    required this.surahNumber,
  });

  @override
  State<ApiAyahCard> createState() => _ApiAyahCardState();
}

class _ApiAyahCardState extends State<ApiAyahCard> {
  bool _isBookmarked = false;

  void _copyAyah() {
    final text = TextUtils.formatForClipboard(
      widget.ayah.teksArab,
      widget.ayah.teksLatin,
      widget.ayah.teksIndonesia,
      widget.surahNumber,
      widget.ayah.nomorAyat,
    );

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ayat berhasil disalin'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  void _shareAyah() {
    // Placeholder for share functionality
    // You can implement actual sharing using share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur berbagi akan segera hadir'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    final message = _isBookmarked
        ? 'Ayat ditambahkan ke bookmark'
        : 'Ayat dihapus dari bookmark';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Header dengan nomor ayat dan aksi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      widget.ayah.nomorAyat.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: const Color(0xFF2E7D32),
                  ),
                  onPressed: _toggleBookmark,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF2E7D32),
                  ),
                  onPressed: _copyAyah,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.share,
                    color: Color(0xFF2E7D32),
                  ),
                  onPressed: _shareAyah,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Teks Arab
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                TextUtils.formatQuranText(widget.ayah.teksArab),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: widget.fontSize + 4,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 2,
                ),
              ),
            ),
          ),

          // Teks Latin
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                TextUtils.formatQuranText(widget.ayah.teksLatin),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: widget.fontSize - 2,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ),

          // Teks Indonesia
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                TextUtils.formatQuranText(widget.ayah.teksIndonesia),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: widget.fontSize - 2,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
