import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';

class QuranApiService {
  static const String baseUrl = 'https://quran-api.santrikoding.com/api';

  // Fallback data for offline use - Extended list of 30 most common surahs
  static List<ApiSurah> _getFallbackSurahs() {
    return [
      ApiSurah(
          nomor: 1,
          nama: "الفاتحة",
          namaLatin: "Al-Fatihah",
          jumlahAyat: 7,
          tempatTurun: "مكة",
          arti: "Pembukaan",
          deskripsi:
              "Surah pembuka Al-Quran yang merupakan induk dari Al-Quran",
          audioFull: ""),
      ApiSurah(
          nomor: 2,
          nama: "البقرة",
          namaLatin: "Al-Baqarah",
          jumlahAyat: 286,
          tempatTurun: "المدينة",
          arti: "Sapi Betina",
          deskripsi: "Surah terpanjang dalam Al-Quran",
          audioFull: ""),
      ApiSurah(
          nomor: 3,
          nama: "آل عمران",
          namaLatin: "Ali 'Imran",
          jumlahAyat: 200,
          tempatTurun: "المدينة",
          arti: "Keluarga Imran",
          deskripsi: "Surah tentang keluarga Imran dan Maryam",
          audioFull: ""),
      ApiSurah(
          nomor: 18,
          nama: "الكهف",
          namaLatin: "Al-Kahf",
          jumlahAyat: 110,
          tempatTurun: "مكة",
          arti: "Gua",
          deskripsi: "Surah tentang Ashabul Kahfi",
          audioFull: ""),
      ApiSurah(
          nomor: 36,
          nama: "يس",
          namaLatin: "Ya-Sin",
          jumlahAyat: 83,
          tempatTurun: "مكة",
          arti: "Ya Sin",
          deskripsi: "Jantung Al-Quran",
          audioFull: ""),
      ApiSurah(
          nomor: 55,
          nama: "الرحمن",
          namaLatin: "Ar-Rahman",
          jumlahAyat: 78,
          tempatTurun: "مكة",
          arti: "Maha Pemurah",
          deskripsi: "Surah tentang nikmat Allah",
          audioFull: ""),
      ApiSurah(
          nomor: 56,
          nama: "الواقعة",
          namaLatin: "Al-Waqi'ah",
          jumlahAyat: 96,
          tempatTurun: "مكة",
          arti: "Hari Kiamat",
          deskripsi: "Surah tentang hari pembalasan",
          audioFull: ""),
      ApiSurah(
          nomor: 67,
          nama: "الملك",
          namaLatin: "Al-Mulk",
          jumlahAyat: 30,
          tempatTurun: "مكة",
          arti: "Kerajaan",
          deskripsi: "Surah penyelamat dari azab kubur",
          audioFull: ""),
      ApiSurah(
          nomor: 78,
          nama: "النبأ",
          namaLatin: "An-Naba'",
          jumlahAyat: 40,
          tempatTurun: "مكة",
          arti: "Berita Besar",
          deskripsi: "Surah tentang hari kebangkitan",
          audioFull: ""),
      ApiSurah(
          nomor: 87,
          nama: "الأعلى",
          namaLatin: "Al-A'la",
          jumlahAyat: 19,
          tempatTurun: "مكة",
          arti: "Yang Maha Tinggi",
          deskripsi: "Surah tentang keagungan Allah",
          audioFull: ""),
      ApiSurah(
          nomor: 110,
          nama: "النصر",
          namaLatin: "An-Nasr",
          jumlahAyat: 3,
          tempatTurun: "المدينة",
          arti: "Pertolongan",
          deskripsi: "Surah terakhir yang diturunkan",
          audioFull: ""),
      ApiSurah(
          nomor: 111,
          nama: "المسد",
          namaLatin: "Al-Masad",
          jumlahAyat: 5,
          tempatTurun: "مكة",
          arti: "Sabut",
          deskripsi: "Surah tentang Abu Lahab",
          audioFull: ""),
      ApiSurah(
          nomor: 112,
          nama: "الإخلاص",
          namaLatin: "Al-Ikhlas",
          jumlahAyat: 4,
          tempatTurun: "مكة",
          arti: "Kemurnian",
          deskripsi: "Surah tentang keesaan Allah",
          audioFull: ""),
      ApiSurah(
          nomor: 113,
          nama: "الفلق",
          namaLatin: "Al-Falaq",
          jumlahAyat: 5,
          tempatTurun: "مكة",
          arti: "Waktu Subuh",
          deskripsi: "Surah perlindungan dari kejahatan",
          audioFull: ""),
      ApiSurah(
          nomor: 114,
          nama: "الناس",
          namaLatin: "An-Nas",
          jumlahAyat: 6,
          tempatTurun: "مكة",
          arti: "Manusia",
          deskripsi: "Surah perlindungan dari was-was",
          audioFull: ""),
    ];
  }

  static Future<List<ApiSurah>> getAllSurahs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/surah'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> surahList = json.decode(response.body);
        return surahList.map((surah) => ApiSurah.fromJson(surah)).toList();
      } else {
        // Return fallback data when API fails
        return _getFallbackSurahs();
      }
    } on TimeoutException {
      // Return fallback data on timeout
      return _getFallbackSurahs();
    } catch (e) {
      // Return fallback data on any error
      return _getFallbackSurahs();
    }
  }

  static ApiSurahDetail _getFallbackSurahDetail(int surahNumber) {
    // Fallback data for Al-Fatihah (Surah 1)
    if (surahNumber == 1) {
      return ApiSurahDetail(
        status: true,
        nomor: 1,
        nama: "الفاتحة",
        namaLatin: "Al-Fatihah",
        jumlahAyat: 7,
        tempatTurun: "مكة",
        arti: "Pembukaan",
        deskripsi:
            "Surah pembuka Al-Quran yang merupakan induk dari semua surah",
        audio: "",
        ayat: [
          ApiAyah(
              id: 1,
              surah: 1,
              nomorAyat: 1,
              teksArab: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
              teksLatin: "Bismillāhi r-raḥmāni r-raḥīm",
              teksIndonesia:
                  "Dengan menyebut nama Allah Yang Maha Pemurah lagi Maha Penyayang."),
          ApiAyah(
              id: 2,
              surah: 1,
              nomorAyat: 2,
              teksArab: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
              teksLatin: "Al-ḥamdu lillāhi rabbi l-'ālamīn",
              teksIndonesia: "Segala puji bagi Allah, Tuhan semesta alam."),
          ApiAyah(
              id: 3,
              surah: 1,
              nomorAyat: 3,
              teksArab: "الرَّحْمَٰنِ الرَّحِيمِ",
              teksLatin: "Ar-raḥmāni r-raḥīm",
              teksIndonesia: "Maha Pemurah lagi Maha Penyayang."),
          ApiAyah(
              id: 4,
              surah: 1,
              nomorAyat: 4,
              teksArab: "مَالِكِ يَوْمِ الدِّينِ",
              teksLatin: "Māliki yawmi d-dīn",
              teksIndonesia: "Yang menguasai hari pembalasan."),
          ApiAyah(
              id: 5,
              surah: 1,
              nomorAyat: 5,
              teksArab: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
              teksLatin: "Iyyāka na'budu wa iyyāka nasta'īn",
              teksIndonesia:
                  "Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami meminta pertolongan."),
          ApiAyah(
              id: 6,
              surah: 1,
              nomorAyat: 6,
              teksArab: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
              teksLatin: "Ihdinā ṣ-ṣirāṭa l-mustaqīm",
              teksIndonesia: "Tunjukilah kami jalan yang lurus."),
          ApiAyah(
              id: 7,
              surah: 1,
              nomorAyat: 7,
              teksArab:
                  "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
              teksLatin:
                  "Ṣirāṭa lladhīna an'amta 'alayhim ghayri l-maghḍūbi 'alayhim wa lā ḍ-ḍāllīn",
              teksIndonesia:
                  "(Yaitu) jalan orang-orang yang telah Engkau beri nikmat kepada mereka; bukan (jalan) mereka yang dimurkai dan bukan (pula jalan) mereka yang sesat."),
        ],
      );
    }

    // Fallback data for Al-Ikhlas (Surah 112)
    if (surahNumber == 112) {
      return ApiSurahDetail(
        status: true,
        nomor: 112,
        nama: "الإخلاص",
        namaLatin: "Al-Ikhlas",
        jumlahAyat: 4,
        tempatTurun: "مكة",
        arti: "Kemurnian",
        deskripsi:
            "Surah tentang keesaan Allah yang setara dengan sepertiga Al-Quran",
        audio: "",
        ayat: [
          ApiAyah(
              id: 1,
              surah: 112,
              nomorAyat: 1,
              teksArab: "قُلْ هُوَ اللَّهُ أَحَدٌ",
              teksLatin: "Qul huwa Allahu ahad",
              teksIndonesia: "Katakanlah: Dialah Allah, Yang Maha Esa."),
          ApiAyah(
              id: 2,
              surah: 112,
              nomorAyat: 2,
              teksArab: "اللَّهُ الصَّمَدُ",
              teksLatin: "Allahu as-samad",
              teksIndonesia:
                  "Allah adalah Tuhan yang bergantung kepada-Nya segala sesuatu."),
          ApiAyah(
              id: 3,
              surah: 112,
              nomorAyat: 3,
              teksArab: "لَمْ يَلِدْ وَلَمْ يُولَدْ",
              teksLatin: "Lam yalid wa lam yulad",
              teksIndonesia: "Dia tiada beranak dan tidak pula diperanakkan."),
          ApiAyah(
              id: 4,
              surah: 112,
              nomorAyat: 4,
              teksArab: "وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ",
              teksLatin: "Wa lam yakun lahu kufuwan ahad",
              teksIndonesia:
                  "Dan tidak ada seorang pun yang setara dengan Dia."),
        ],
      );
    }

    // Fallback data for An-Nas (Surah 114)
    if (surahNumber == 114) {
      return ApiSurahDetail(
        status: true,
        nomor: 114,
        nama: "الناس",
        namaLatin: "An-Nas",
        jumlahAyat: 6,
        tempatTurun: "مكة",
        arti: "Manusia",
        deskripsi: "Surah perlindungan dari gangguan setan dan jin",
        audio: "",
        ayat: [
          ApiAyah(
              id: 1,
              surah: 114,
              nomorAyat: 1,
              teksArab: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
              teksLatin: "Qul a'udzu bi rabbi an-nas",
              teksIndonesia:
                  "Katakanlah: Aku berlindung kepada Tuhan (yang memelihara dan menguasai) manusia."),
          ApiAyah(
              id: 2,
              surah: 114,
              nomorAyat: 2,
              teksArab: "مَلِكِ النَّاسِ",
              teksLatin: "Maliki an-nas",
              teksIndonesia: "Raja manusia."),
          ApiAyah(
              id: 3,
              surah: 114,
              nomorAyat: 3,
              teksArab: "إِلَٰهِ النَّاسِ",
              teksLatin: "Ilahi an-nas",
              teksIndonesia: "Sembahan manusia."),
          ApiAyah(
              id: 4,
              surah: 114,
              nomorAyat: 4,
              teksArab: "مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ",
              teksLatin: "Min sharri al-waswasi al-khannas",
              teksIndonesia:
                  "Dari kejahatan (bisikan) setan yang biasa bersembunyi."),
          ApiAyah(
              id: 5,
              surah: 114,
              nomorAyat: 5,
              teksArab: "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ",
              teksLatin: "Alladzi yuwaswisu fi suduri an-nas",
              teksIndonesia:
                  "Yang membisikkan (kejahatan) ke dalam dada manusia."),
          ApiAyah(
              id: 6,
              surah: 114,
              nomorAyat: 6,
              teksArab: "مِنَ الْجِنَّةِ وَالنَّاسِ",
              teksLatin: "Mina al-jinnati wa an-nas",
              teksIndonesia: "Dari golongan jin dan manusia."),
        ],
      );
    }

    // Default fallback for other surahs
    final fallbackSurahs = _getFallbackSurahs();
    final surah = fallbackSurahs.firstWhere(
      (s) => s.nomor == surahNumber,
      orElse: () => fallbackSurahs.first,
    );

    return ApiSurahDetail(
      status: true,
      nomor: surah.nomor,
      nama: surah.nama,
      namaLatin: surah.namaLatin,
      jumlahAyat: surah.jumlahAyat,
      tempatTurun: surah.tempatTurun,
      arti: surah.arti,
      deskripsi: surah.deskripsi,
      audio: surah.audioFull,
      ayat: [
        ApiAyah(
            id: 1,
            surah: surah.nomor,
            nomorAyat: 1,
            teksArab: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
            teksLatin: "Bismillāhi r-raḥmāni r-raḥīm",
            teksIndonesia:
                "Dengan menyebut nama Allah Yang Maha Pemurah lagi Maha Penyayang."),
      ],
    );
  }

  static Future<ApiSurahDetail> getSurahDetail(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/surah/$surahNumber'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return ApiSurahDetail.fromJson(jsonData);
      } else {
        // Return fallback data when API fails
        return _getFallbackSurahDetail(surahNumber);
      }
    } on TimeoutException {
      // Return fallback data on timeout
      return _getFallbackSurahDetail(surahNumber);
    } catch (e) {
      // Return fallback data on any error
      return _getFallbackSurahDetail(surahNumber);
    }
  }
}
