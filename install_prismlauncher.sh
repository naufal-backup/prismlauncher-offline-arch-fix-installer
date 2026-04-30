#!/bin/bash

# Script Installer Prism Launcher Offline (Fix)
# Deskripsi: Mengotomatisasi instalasi dengan perbaikan versi 11.0.2, 
#            kompatibilitas Java 17, dan Vulkan headers.

set -e

PASSWORD="fawwaz453"
BUILD_DIR="$HOME/prismlauncher_fix_build"
CURRENT_JAVA=$(archlinux-java get)

# Fungsi untuk menjalankan sudo dengan password otomatis
run_sudo() {
    echo "$PASSWORD" | sudo -S "$@"
}

echo "1. Menginstall dependensi yang dibutuhkan (JDK 17, Vulkan, Wayland, Adwaita)..."
run_sudo pacman -S --needed --noconfirm git base-devel jdk17-openjdk vulkan-headers qt6-wayland adwaita-qt6

echo "2. Mengatur Java ke versi 17 untuk proses build..."
run_sudo archlinux-java set java-17-openjdk

echo "3. Mendownload PKGBUILD dari AUR..."
rm -rf "$BUILD_DIR"
git clone https://aur.archlinux.org/prismlauncher-offline.git "$BUILD_DIR"
cd "$BUILD_DIR"

echo "4. Menerapkan patch pada PKGBUILD..."
# Update versi ke 11.0.2
sed -i 's/pkgver=10.0.2/pkgver=11.0.2/' PKGBUILD
# Tambahkan vulkan-headers ke makedepends
sed -i "s/makedepends=(\([^)]*\))/makedepends=(\1 'vulkan-headers')/" PKGBUILD

echo "5. Memulai proses build dan instalasi..."
# Refresh sudo timestamp
run_sudo -v
# Jalankan makepkg (makepkg akan meminta konfirmasi sudo saat install, 
# kita gunakan --noconfirm dan trik agar sudo tetap terautentikasi)
makepkg -si --noconfirm

echo "6. Mengembalikan versi Java ke default ($CURRENT_JAVA)..."
run_sudo archlinux-java set "$CURRENT_JAVA"

echo "7. Mengonfigurasi integrasi GNOME (Wayland & Adwaita)..."
mkdir -p ~/.local/share/applications/
cp /usr/share/applications/org.prismlauncher.PrismLauncher.desktop ~/.local/share/applications/
sed -i 's\|Exec=prismlauncher %U\|Exec=env WAYLAND_DISPLAY= QT_WAYLAND_DECORATION=adwaita QT_QPA_PLATFORMTHEME=adwaita prismlauncher %U\|' ~/.local/share/applications/org.prismlauncher.PrismLauncher.desktop

echo "8. Membersihkan file sisa..."
cd "$HOME"
rm -rf "$BUILD_DIR"

echo "==========================================="
echo " Instalasi Selesai! "
echo " Anda bisa menjalankan: prismlauncher"
echo "==========================================="
