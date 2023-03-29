#!/usr/bin/env bash

if [ "$(id -u)" = 0 ]; then
    echo "##################################################"
    echo "##                                              ##"
    echo "##  This script must be run as a regular user.  ##"
    echo "##                                              ##"
    echo "##################################################"
    exit 1
fi

error() { \
    printf "ERROR:\\n%s\\n" "$1" >&2; exit 1;
}

export NEWT_COLORS="
root=,blue
window=,black
shadow=,blue
border=blue,black
title=blue,black
textbox=blue,black
radiolist=black,black
label=black,blue
checkbox=black,blue
compactbutton=black,blue
button=black,red"

whiptail_git() {
    echo "########################################"
    echo "##                                    ##"
    echo "##  Cheking for 'whiptale' and 'git'  ##"
    echo "##                                    ##"
    echo "########################################"

    sudo pacman --noconfirm --needed -Syu libnewt git base-devel || error "Failed to install 'whiptail' and 'git'"
}

whiptail_git

echo "#######################"
echo "##                   ##"
echo "##  Check for 'yay'  ##"
echo "##                   ##"
echo "#######################"

if ! command -v yay &> /dev/null; then
    echo "yay not found"
    echo "Installing yay"
    git clone https://aur.archlinux.org/yay.git
    cd yay || error "Failed to change directory"
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "yay found"
fi

welcome() { \
    whiptail --title "Installing!" --msgbox "This is a script includes a Hyprland deskrop and Doom Emacs as main editor. You will be asked to enter your sudo password at various points during this installation, so stay near the computer." 16 60
}

welcome || error "User choose to exit."

speedwarning() { \
    whiptail --title "Installing!" --yesno "WARNING! The ParallelDownloads option is not enabled in /etc/pacman.conf. This may result in slower installation speeds. Are you sure you want to continue?" 16 60 || error "User choose to exit."
}

distrowarning() { \
    whiptail --title "Installing!" --msgbox "WARNING! While this script works on all Arch based distros, some distros might have some problems with some packages. Please have a look at the packages list and adjust it if needed" 16 60 || error "User choose to exit."
}

grep -qs "#ParallelDownloads" /etc/pacman.conf && speedwarning
grep -qs "ID=archarm" /etc/os-release || distrowarning

lastchance() { \
    whiptail --title "Installing!" --msgbox "WARNING! The DTOS installation script is currently in public beta testing. There are almost certainly errors in it; therefore, it is strongly recommended that you not install this on production machines. It is recommended that you try this out in either a virtual machine or on a test machine." 16 60

    whiptail --title "Are You Sure You Want To Do This?" --yesno "Shall we begin installing?" 8 60 || { clear; exit 1; }
}

lastchance || error "User choose to exit."

grep "LANG" /etc/locale.conf && echo "Checking the LANG variable in /etc/locale.conf. Variable is already set." || error "LANG variable is not set in /etc/locale.conf"

backup() { \
    whiptail --title "Backup" --yesno "Do you want to backup your current configuration?" 8 60
}

bareclone() { \
    whiptail --title "Bare Clone" --yesno "Do you want to clone the bare repository?" 8 60
}

bareclone && bareclone=true || bareclone=false
backup && backup=true || backup=false

if [ "$backup" = true ]; then
    backupfile="$HOME/backup."$(date +%Y%m%d%H%M%S)"" && mkdir -p "$backupfile"
fi

echo "##############################"
echo "##                          ##"
echo "##  Cloning git repository  ##"
echo "##                          ##"
echo "##############################"

if [ -d "$HOME/.dotfiles" ]; then
    echo "Directory $HOME/.dotfiles exists."
    if [ "$backup" = true ]; then
        echo "Backing up $HOME/.dotfiles to $backupfile"
        mv "$HOME/.dotfiles" "$backupfile"
    else
        echo "Removing $HOME/.dotfiles"
        rm -rf "$HOME/.dotfiles"
    fi
fi

if [ "$bareclone" = true ]; then
    mkdir -p "$HOME/.dotfiles"
    git clone --bare https://gitlap.gleissner.com/Moritz/dotfiles.git "$HOME/.dotfiles" || error "Failed to clone the bare repository"
else
    git clone https://gitlab.gleissner.com/Moritz/dotfiles.git "$HOME/.dotfiles" || error "Failed to clone the repository"
fi

echo "################################"
echo "##                            ##"
echo "##  Moving dotfiles to home   ##"
echo "##                            ##"
echo "################################"

if [ "$backup" = true ]; then
    echo "Backing up $HOME/.config to $backupfile"
    mv "$HOME/.config" "$backupfile"
else
    echo "Removing $HOME/.config"
    rm -rf "$HOME/.config"
fi

if [ "$bareclone" = true ]; then
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout || error "Failed to checkout the dotfiles"
else
    mv "$HOME/.dotfiles/.config" "$HOME/.config"
    rm -rf "$HOME/.dotfiles"
fi

installhyprland() { \
    whiptail --title "Installing!" --yesno "Do you want to install Hyprland and the needed packages?" 8 60
}

installhyprland || error "User choose to exit."

echo "########################################"
echo "##                                    ##"
echo "##  Installing Hyprland and packeges  ##"
echo "##                                    ##"
echo "########################################"

changehyprlandpackages() {
    whiptail --title "Installing!" --yesno "Do you want to change the package list for hyprland?" 8 60
}

if changehyprlandpackages; then
    vim "$HOME/.config/hypr/install-packages.sh" || error "Failed to open vim"
    wait
fi

bash "$HOME/.config/hypr/install-packages.sh" || error "Failed to install Hyprland"

activatesddm() { \
    whiptail --title "Installing!" --yesno "Do you want to activate sddm?" 8 60
}

if activatesddm; then
    sudo systemctl enable sddm.service || error "Failed to enable sddm"
    sudo systemctl start sddm.service || error "Failed to start sddm"
fi

installdoomemacs() { \
    whiptail --title "Installing!" --yesno "Do you want to install Doom Emacs and the needed packages?" 8 60
}

installdoomemacs && installdoomemacs=true || installdoomemacs=false

if [ "$installdoomemacs" = true ]; then
    echo "############################################"
    echo "##                                        ##"
    echo "##  Installing Doom Emacs and packeges    ##"
    echo "##                                        ##"
    echo "############################################"

    if [ "$backup" = true ]; then
        echo "Backing up $HOME/.emacs.d to $backupfile"
        mv "$HOME/.emacs.d" "$backupfile"
        echo "Backing up $HOME/.emacs to $backupfile"
        mv "$HOME/.emacs" "$backupfile"
        echo "Backing up $HOME/.doom.d to $backupfile"
        mv "$HOME/.doom.d" "$backupfile"
    else
        echo "Removing $HOME/.emacs.d"
        rm -rf "$HOME/.emacs.d"
        echo "Removing $HOME/.emacs"
        rm -rf "$HOME/.emacs"
        echo "Removing $HOME/.doom.d"
        rm -rf "$HOME/.doom.d"
    fi

    changeemacspackages() {
        whiptail --title "Installing!" --yesno "Do you want to change the package list for Doom Emacs?" 8 60
    }

    if changeemacspackages; then
        vim "$HOME/.config/doom/install-packages.sh" || error "Failed to open vim"
        wait
    fi

    bash "$HOME/.config/doom/install-packages.sh" || error "Failed to install Doom Emacs"

    git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.emacs.d" || error "Failed to clone Doom Emacs"
    "$HOME/.emacs.d/bin/doom" install || error "Failed to install Doom Emacs"
    "$HOME/.emacs.d/bin/doom" sync || error "Failed to sync Doom Emacs"
fi

echo "###########################"
echo "##                       ##"
echo "##  Finished installing  ##"
echo "##                       ##"
echo "###########################"
