#!/bin/bash
yay -Syu --noconfirm --needed hyprland-legacyrenderer-git mako pipewire wireplumber alsa-utils pipwire-alsa pipwire-pulse bluez bluez-utils xdg-desktop-portal-hyprland-git polkit-kde-agent qt5-wayland qt6-wayland sddm-catppuccin-git waybar-hyprland-git alacritty kitty qt5ct lxappearance catppuccin-gtk-theme-mocha firefox armcord-bin youtubemusic-nativefier nextcloud-client nautilus electron20-bin wlogout swayidle swaylock-effects wofi pamixer playerctl slurp grim jq swaybg wf-recorder wl-clipboard copyq wlroots light xorg-xwayland yad viewnior mpv bemenu-wayland hyprpicker-git fish neofetch btop htop neovim exa ttf-nerd-fonts-symbols-2048-em ttf-hack ttf-ubuntu-font-family ttf-kanjistrokeorders ttf-iosevka packer breeze-gtk breeze-icons

# oh my fish instalation
if [ ! -d "$HOME/.local/share/omf" ]; then
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fi

systemctl enable bluetooth
