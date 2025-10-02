# Screenshots Placeholder

## 📸 Cara Menambahkan Screenshots

### 1. Ambil Screenshots dari Emulator/Device

```bash
# Via Flutter (saat app running)
s  # Screenshot command in flutter run

# Via ADB
adb exec-out screencap -p > screenshot.png

# Via Emulator menu
# Extended controls > Camera > Take screenshot
```

### 2. Rename Files Sesuai Fitur

- `home.png` - Al-Qur'an home screen
- `detail.png` - Surah detail dengan ayat
- `kiblat.png` - Kompas kiblat screen
- `hadist.png` - Hadist collection
- `doa.png` - Doa harian
- `settings.png` - Settings screen

### 3. Optimasi Gambar

```bash
# Resize ke 300x600 untuk mobile
# Compress untuk file size kecil
# Format: PNG untuk UI screenshots
```

### 4. Update README

Setelah menambahkan screenshots, README.md akan otomatis menampilkan gambar di section Screenshots.

## 📝 Notes

- Screenshots saat ini placeholder - belum ada file gambar
- Bisa ditambahkan nanti setelah app final
- Atau bisa dihapus section screenshots dari README jika tidak diperlukan
