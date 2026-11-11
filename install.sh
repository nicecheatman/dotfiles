#!/usr/bin/env bash
set -e

echo "=== 1. Activation du dépôt multilib (32-bit) ==="
sudo sed -i '/^#\[multilib\]/{N;s/#\[multilib\]\n#Include/\[multilib\]\nInclude/}' /etc/pacman.conf
sudo pacman -Sy --noconfirm

echo "=== 2. Installation de la base AMD & Noyau Zen ==="
sudo pacman -S --needed --noconfirm \
  base base-devel linux-zen linux-zen-headers linux-firmware amd-ucode networkmanager sudo git

echo "=== 3. Installation des pilotes graphiques AMD & Hyprland ==="
sudo pacman -S --needed --noconfirm \
  hyprland xdg-desktop-portal-hyprland xorg-xwayland mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon

echo "=== 4. Installation des composants de l'interface, du son & AUR ==="
sudo pacman -S --needed --noconfirm \
  waybar rofi swaync hyprpaper pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol playerctl cava curl jq

# Installation automatique de yay si absent
if ! command -v yay &> /dev/null; then
    echo "Installation de yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
fi

yay -S --needed --noconfirm hyprshade

echo "=== 5. Installation des polices, terminal et utilitaires ==="
sudo pacman -S --needed --noconfirm \
  kitty ttf-jetbrains-mono-nerd noto-fonts-cjk ttf-font-awesome wl-clipboard cliphist ly ufw zram-generator

echo "=== 6. Installation des paquets conditionnels (Laptop / Bluetooth) ==="
# Gestion de l'énergie sur PC portable (Acer Nitro 5)
if [ -d "/sys/class/power_supply/BAT0" ] || [ -d "/sys/class/power_supply/BAT1" ]; then
    echo "--> Détection d'un PC Portable : installation de power-profiles-daemon..."
    sudo pacman -S --needed --noconfirm power-profiles-daemon
    sudo systemctl enable power-profiles-daemon
fi

# Bluetooth (s'active si le matériel est détecté)
if lspci | grep -i bluetooth > /dev/null || lsusb | grep -i bluetooth > /dev/null; then
    echo "--> Carte Bluetooth détectée : installation de BlueZ & Blueman..."
    sudo pacman -S --needed --noconfirm bluez bluez-utils blueman
    sudo systemctl enable bluetooth
fi

echo "=== 7. Installation des logiciels du quotidien ==="
sudo pacman -S --needed --noconfirm \
  obsidian steam mangohud gamemode mpv imv nemo qbittorrent bitwarden flatpak unzip zip ncdu

echo "=== 8. Déploiement des configurations (Dotfiles) ==="
mkdir -p ~/.config
cp -r ./config/* ~/.config/ 2>/dev/null || cp -r ./.config/* ~/.config/

echo "=== 9. Activation des services système ==="
sudo systemctl enable NetworkManager
sudo systemctl enable ly@tty2.service

echo "=== Installation terminée ! ==="
