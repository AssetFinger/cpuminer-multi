#!/data/data/com.termux/files/usr/bin/bash

# Pindah ke direktori script berada
cd "$(dirname "$0")"

echo "[*] Memulai persiapan sistem..."

# 1. Update & Install dependensi jika belum ada
pkg update -y
pkg install -y git wget build-essential cmake clang automake autoconf libcurl openssl zlib

# 2. Cek apakah binary cpuminer sudah dikompilasi
if [ ! -f "cpuminer" ]; then
    echo "[*] Mengompilasi cpuminer pertama kali..."
    chmod +x autogen.sh
    ./autogen.sh
    ./configure CFLAGS="-O3"
    make -j$(nproc)
fi

# 3. Cek apakah config.json sudah dibuat
if [ ! -f "config.json" ]; then
    echo "[!] ERROR: config.json tidak ditemukan!"
    echo "[*] Silakan buat file config.json terlebih dahulu."
    exit 1
fi

# 4. Aktifkan wakelock agar Termux tidak mati saat layar off
termux-wake-lock

# 5. Jalankan Mining
echo "[*] Mining dimulai! Gunakan CTRL+C untuk berhenti."
./cpuminer -c config.json
