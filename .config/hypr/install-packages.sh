#!/bin/bash
yay -Syu --noconfirm --needed hyprland-git mako pipewire wireplumber alsa-utils pipewire-alsa pipewire-pulse pulsemixer bluez bluez-utils xdg-desktop-portal-hyprland-git polkit-kde-agent qt5-wayland qt6-wayland sddm-catppuccin-git waybar-hyprland-git alacritty kitty qt5ct lxappearance catppuccin-gtk-theme-mocha firefox armcord-git youtubemusic-nativefier nextcloud-client nautilus electron20-bin electron24-bin wlogout swayidle swaylock-effects wofi pamixer playerctl slurp grim jq swww-git wf-recorder wl-clipboard copyq wlroots light xorg-xwayland yad viewnior mpv bemenu-wayland hyprpicker-git fish starship neofetch btop htop vim neovim exa packer breeze bat-extras checkupdates+aur waybar-mpris-git postman-bin

# oh my fish instalation
# if [ ! -d "$HOME/.local/share/omf" ]; then
#     curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
# fi

# check and delete other xdg-desktop-portal's
echo "removing other xdg-desktop-portal instances"
yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
