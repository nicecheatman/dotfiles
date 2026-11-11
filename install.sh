#!/usr/bin/env bash
set -e

echo "=== 1. Mise à jour du système ==="
sudo pacman -Syu --noconfirm

echo "=== 3. Installation des pilotes graphiques AMD & Hyprland ==="
sudo pacman -S --needed --noconfirm \
  hyprland xdg-desktop-portal-hyprland xorg-xwayland mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon

echo "=== 4. Installation des composants de l'interface et du son ==="
sudo pacman -S --needed --noconfirm \
  waybar rofi swaync hyprpaper pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol playerctl

echo "=== 5. Installation des polices, terminal et utilitaires ==="
sudo pacman -S --needed --noconfirm \
  kitty ttf-jetbrains-mono-nerd noto-fonts-cjk wl-clipboard cliphist ly ufw zram-generator

echo "=== 6. Installation des logiciels du quotidien ==="
sudo pacman -S --needed --noconfirm \
 waybar-module-pacman-updates-git cava git firefox obsidian steam mangohud gamemode mpv imv nemo qbittorrent bitwarden flatpak unzip zip ncdu

echo "=== 7. Déploiement des configurations (Dotfiles) ==="
mkdir -p ~/.config
cp -r ./config/hypr ~/.config/
cp -r ./config/waybar ~/.config/
cp -r ./config/theme ~/.config/
cp -r ./config/waybar-weather ~/.config/

echo "=== 8. Activation des services système ==="
sudo systemctl enable NetworkManager
sudo systemctl enable ly@tty2.service

echo "=== Terminé ! Tu peux redémarrer ton PC avec la commande 'reboot' ==="
