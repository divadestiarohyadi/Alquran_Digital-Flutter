# Panduan Penggunaan Aplikasi Al-Qur'an Digital

## Splash Screen & Login

### Splash Screen

- Animasi loading yang indah saat pertama membuka aplikasi
- Menampilkan logo, nama aplikasi, dan Bismillah
- Loading otomatis menuju halaman login setelah 3 detik

### Halaman Login

- **Form Login**: Masukkan email dan password yang valid
- **Validasi**: Email harus mengandung '@' dan password minimal 6 karakter
- **Show/Hide Password**: Tombol mata untuk menampilkan/menyembunyikan password
- **Lupa Password**: Link bantuan untuk reset password
- **Masuk sebagai Tamu**: Akses langsung tanpa login
- **Daftar Akun**: Link ke halaman registrasi

### Halaman Registrasi

- **Form Lengkap**: Nama, email, password, dan konfirmasi password
- **Validasi Real-time**: Cek kecocokan password dan format email
- **Syarat & Ketentuan**: Checkbox persetujuan yang wajib dicentang
- **Tombol Daftar**: Aktif setelah semua validasi terpenuhi

## Halaman Utama (Home)

- **Bismillah**: Ditampilkan di header dengan gradient hijau yang indah
- **Statistik**: Menampilkan total surah (114), total ayat (6,236), dan jumlah para/juz (30)
- **Pencarian Cepat**: Search bar untuk mencari surah dengan mudah
- **Daftar Surah**: List semua surah dengan informasi:
  - Nomor surah dalam kotak hijau
  - Nama Latin dan terjemahan bahasa Inggris
  - Nama Arab di sebelah kanan
  - Tag Makki/Madani dengan warna berbeda
  - Jumlah ayat
  - Ikon panah untuk masuk ke detail

## Halaman Detail Surah

- **Header Surah**: Menampilkan nama Arab, Latin, terjemahan, dan informasi surah
- **Kontrol Teks**: Tombol untuk memperbesar/memperkecil ukuran teks Arab
- **Bismillah**: Ditampilkan otomatis (kecuali untuk At-Tawbah)
- **Daftar Ayat**: Setiap ayat menampilkan:
  - Nomor ayat dalam lingkaran hijau
  - Teks Arab dengan font yang dapat disesuaikan
  - Tombol copy, share, dan bookmark
  - Informasi juz dan halaman
  - Indikator sajda (jika ada)

## Halaman Pencarian

- **Search Bar**: Pencarian real-time
- **Multi-kriteria**: Cari berdasarkan:
  - Nama Arab surah
  - Nama Latin
  - Terjemahan bahasa Inggris
  - Nomor surah
- **Hasil Instan**: Hasil muncul langsung saat mengetik

## Halaman Bookmark

- **Daftar Bookmark**: Semua ayat yang telah di-bookmark
- **Informasi Lengkap**: Nama surah, nomor ayat, dan teks Arab
- **Kelola Bookmark**: Hapus bookmark yang tidak diperlukan
- **Akses Cepat**: Langsung ke ayat yang di-bookmark

## Halaman Pengaturan

### Pengaturan Tampilan

- **Ukuran Teks Arab**: Slider untuk mengatur 14-32px
- **Preview**: Contoh teks Arab untuk melihat perubahan
- **Hanya Teks Arab**: Sembunyikan terjemahan
- **Tampilkan Terjemahan**: Toggle terjemahan Indonesia
- **Mode Malam**: Tema gelap untuk kenyamanan mata

### Tentang Aplikasi

- **Versi Aplikasi**: Informasi versi saat ini
- **Beri Rating**: Link untuk rating aplikasi
- **Bagikan Aplikasi**: Share ke teman-teman
- **Kebijakan Privasi**: Informasi privasi

### Akun

- **Keluar**: Tombol logout untuk keluar dari akun
- **Konfirmasi Logout**: Dialog konfirmasi sebelum logout
- **Redirect**: Otomatis kembali ke halaman login setelah logout

## Tips Penggunaan

1. **Navigasi**: Gunakan bottom navigation untuk berpindah antar halaman
2. **Pencarian**: Ketik beberapa huruf saja untuk hasil yang cepat
3. **Bookmark**: Tekan ikon bookmark pada ayat untuk menyimpan
4. **Copy**: Tekan ikon copy untuk menyalin teks Arab
5. **Ukuran Teks**: Sesuaikan ukuran teks sesuai kenyamanan mata
6. **Scroll**: Scroll vertikal untuk membaca ayat-ayat dalam surah

## Keyboard Shortcuts (untuk Web)

- **Ctrl + F**: Fokus ke search bar (di halaman pencarian)
- **Esc**: Kembali/tutup modal
- **Arrow Keys**: Navigasi dalam list
- **Enter**: Buka detail surah yang dipilih

## Data Aplikasi

Saat ini aplikasi menggunakan data sample yang mencakup:

- **Surah Lengkap**: Al-Fatihah, Al-Baqarah, Ali Imran, An-Nisa, Al-Maidah, Al-An'am, Al-A'raf, Al-Anfal, At-Tawbah, Yunus, Al-Mulk, Al-Ikhlas, Al-Falaq, An-Nas
- **Ayat Sample**: Al-Fatihah, Al-Ikhlas, Al-Falaq, An-Nas (lengkap)

_Untuk implementasi penuh, diperlukan database Al-Qur'an yang lengkap dengan 114 surah dan 6,236 ayat._
