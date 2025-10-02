import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../screens/api_surah_detail_screen.dart';
import '../utils/text_utils.dart';

class ApiSurahCard extends StatelessWidget {
  final ApiSurah surah;
  final VoidCallback? onTap;

  const ApiSurahCard({super.key, required this.surah, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ListTile(
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApiSurahDetailScreen(surah: surah),
                ),
              );
            },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${surah.nomor}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.namaLatin,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    TextUtils.removeHtmlTags(surah.arti),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              surah.nama,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: surah.tempatTurun.toLowerCase() == 'mekah'
                      ? Colors.orange[100]
                      : Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  surah.tempatTurun,
                  style: TextStyle(
                    fontSize: 10,
                    color: surah.tempatTurun.toLowerCase() == 'mekah'
                        ? Colors.orange[800]
                        : Colors.blue[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${surah.jumlahAyat} Ayat',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }
}
