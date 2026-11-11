#!/usr/bin/env bash
set -e

echo "=== 1. Mise à jour du système ==="
sudo pacman -Syu --noconfirm

echo "=== 2. Installation de la base AMD & Système ==="
sudo pacman -S --needed --noconfirm \
  base base-devel linux linux-headers linux-firmware amd-ucode networkmanager sudo git

echo "=== 3. Installation des pilotes graphiques AMD & Hyprland ==="
sudo pacman -S --needed --noconfirm \
  hyprland xdg-desktop-portal-hyprland xorg-xwayland mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon

echo "=== 4. Installation des composants de l'interface et du son ==="
sudo pacman -S --needed --noconfirm \
  waybar rofi swaync hyprpaper hyprshade pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol playerctl

echo "=== 5. Installation des polices, terminal et utilitaires ==="
sudo pacman -S --needed --noconfirm \
  kitty ttf-jetbrains-mono-nerd fonts-cjk wl-clipboard cliphist ly ufw zram-generator

echo "=== 6. Installation des logiciels du quotidien ==="
sudo pacman -S --needed --noconfirm \
  obsidian steam mangohud gamemode mpv imv nemo qbittorrent bitwarden flatpak unzip zip ncdu

echo "=== 7. Déploiement des configurations (Dotfiles) ==="
mkdir -p ~/.config
cp -r ./config/hypr ~/.config/
cp -r ./config/waybar ~/.config/

echo "=== 8. Activation des services système ==="
sudo systemctl enable NetworkManager
sudo systemctl enable ly

echo "=== Terminé ! Tu peux redémarrer ton PC avec la commande 'reboot' ==="
