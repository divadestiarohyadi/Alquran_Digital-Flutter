class ApiSurah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audioFull;

  ApiSurah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
  });

  factory ApiSurah.fromJson(Map<String, dynamic> json) {
    return ApiSurah(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['nama_latin'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      tempatTurun: json['tempat_turun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audioFull: json['audio_full']?['05'] ?? '',
    );
  }
}

class ApiAyah {
  final int id;
  final int surah;
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;

  ApiAyah({
    required this.id,
    required this.surah,
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
  });

  factory ApiAyah.fromJson(Map<String, dynamic> json) {
    return ApiAyah(
      id: json['id'] ?? 0,
      surah: json['surah'] ?? 0,
      nomorAyat: json['nomor'] ?? 0,
      teksArab: json['ar'] ?? '',
      teksLatin: json['tr'] ?? '',
      teksIndonesia: json['idn'] ?? '',
    );
  }
}

class ApiSurahDetail {
  final bool status;
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audio;
  final List<ApiAyah> ayat;

  ApiSurahDetail({
    required this.status,
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
    required this.ayat,
  });

  factory ApiSurahDetail.fromJson(Map<String, dynamic> json) {
    final List<dynamic> ayatList = json['ayat'] ?? [];
    return ApiSurahDetail(
      status: json['status'] ?? false,
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['nama_latin'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      tempatTurun: json['tempat_turun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audio: json['audio'] ?? '',
      ayat: ayatList.map((ayah) => ApiAyah.fromJson(ayah)).toList(),
    );
  }
}

class DoaHarian {
  final int id;
  final String judul;
  final String arab;
  final String latin;
  final String terjemah;

  DoaHarian({
    required this.id,
    required this.judul,
    required this.arab,
    required this.latin,
    required this.terjemah,
  });

  factory DoaHarian.fromJson(Map<String, dynamic> json) {
    return DoaHarian(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      arab: json['arab'] ?? '',
      latin: json['latin'] ?? '',
      terjemah: json['terjemah'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'arab': arab,
      'latin': latin,
      'terjemah': terjemah,
    };
  }
}
