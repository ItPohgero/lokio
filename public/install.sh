#!/bin/bash

# URL untuk mendapatkan daftar file
FILE_LIST_URL="https://sh.lokio.dev/data/list.txt"
BINARY_URL="https://sh.lokio.dev/bin/lokio"
DATA_DEST="$HOME/.local/share/lokio"

# Warna untuk output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Fungsi untuk mencoba instalasi sistem
try_system_install() {
    if sudo -n true 2>/dev/null; then
        # Sudo tersedia tanpa password
        sudo mkdir -p "/usr/local/bin"
        echo "Installing to system directory..."
        sudo curl -# -o "/usr/local/bin/lokio" "$BINARY_URL"
        sudo chmod +x "/usr/local/bin/lokio"
        return 0
    fi
    return 1
}

# Fungsi untuk instalasi user
do_user_install() {
    echo "Installing to user directory..."
    mkdir -p "$HOME/.local/bin"
    curl -# -o "$HOME/.local/bin/lokio" "$BINARY_URL"
    chmod +x "$HOME/.local/bin/lokio"

    # Membuat direktori untuk menyimpan data
    mkdir -p "$DATA_DEST"

    # Mengunduh daftar file
    echo "Downloading file list..."
    curl -# -o "$DATA_DEST/file_list.txt" "$FILE_LIST_URL"

    # Membaca file daftar dan mengunduh setiap file
    while read -r file_url; do
        # Mengunduh setiap file berdasarkan URL yang ada di file daftar
        curl -# -o "$DATA_DEST/$(basename $file_url)" "$file_url"
    done < "$DATA_DEST/file_list.txt"

    # Menambahkan ke PATH jika belum ada
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.bashrc"
        export PATH="$HOME/.local/bin:$PATH"
    fi
}

# Main installation
echo "Installing Lokio..."

# Coba instalasi sistem dulu
if try_system_install; then
    INSTALL_TYPE="system"
else
    # Jika gagal, lakukan instalasi user
    do_user_install
    INSTALL_TYPE="user"
fi

# Verifikasi instalasi
if command -v lokio &>/dev/null; then
    echo -e "\n${GREEN}Congratulations! Lokio has been installed successfully!${NC}"
    echo -e "Installation type: $INSTALL_TYPE"
    if [ "$INSTALL_TYPE" = "user" ]; then
        echo -e "Note: You may need to restart your terminal or run 'source ~/.bashrc'"
    fi
    echo -e "Let's run 'lokio'"
else
    echo -e "\n${RED}Installation failed. Please try again.${NC}"
    exit 1
fi
