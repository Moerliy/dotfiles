#!/usr/bin/env bash

if [ "$(id -u)" = 0 ]; then
    echo "################################################"
    echo "##                                            ##"
    echo "##  This script must be run as a normal user  ##"
    echo "##                                            ##"
    echo "################################################"
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

    sudo pacman --noconfirm --needed -Syu libnewt git || error "Failed to install 'whiptail' and 'git'"
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

welcome() {
    whiptail --title "Welcome" --msgbox "Welcome to my Doom Emacs installer script. This script will backup existing Emacs configuration files and install my Doom Emacs with the necessary packages" 10 60
}

welcome || error "User exited"

lastchance() {
    whiptail --title "Last chance" --yesno "Are you sure you want to continue?" 10 60
}

lastchance || error "User exited"

backup() {
    echo "#######################"
    echo "##                   ##"
    echo "##  Backup old files ##"
    echo "##                   ##"
    echo "#######################"

    if [ -d ~/.emacs.d ]; then
        echo "Backing up old .emacs.d"
        mv ~/.emacs.d ~/.emacs.d.bak."$(date +%Y%m%d%H%M%S)"
    fi

    if [ -f ~/.emacs ]; then
        echo "Backing up old .emacs"
        mv ~/.emacs ~/.emacs.bak."$(date +%Y%m%d%H%M%S)"
    fi

    if [ -d ~/.config/doom ]; then
        echo "Backing up old .config/doom"
        mv ~/.config/doom ~/.config/doom.bak."$(date +%Y%m%d%H%M%S)"
    fi
}

gitclone() {
    echo "#####################"
    echo "##                 ##"
    echo "##  Clone my repo  ##"
    echo "##                 ##"
    echo "#####################"

    cd "$HOME" || error "Failed to change directory to $HOME"
    git clone --nocheckout https://gitlab.gleissner.com/Moritz/dotfiles.git
    cd dotfiles || error "Failed to change directory to dotfiles"
    git sparse-checkout init --cone || error "Failed to init sparse checkout"
    git sparse-checkout set .config/doom || error "Failed to set sparse checkout"
    git checkout origin/master || error "Failed to checkout master"
    cp -r .config/doom ~/.config || error "Failed to copy .config/doom to ~/.config"
    cd "$HOME" || error "Failed to change directory to $HOME"
}

packages() {
    echo "##################################"
    echo "##                              ##"
    echo "##  Install packages and emacs  ##"
    echo "##                              ##"
    echo "##################################"

    bash ~/.config/doom/install-packages.sh || error "Failed to install packages and emacs"
}

doom() {
    echo "##########################"
    echo "##                      ##"
    echo "##  Install Doom Emacs  ##"
    echo "##                      ##"
    echo "##########################"

    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install --force || error "Failed to install Doom Emacs"
    ~/.emacs.d/bin/doom sync || error "Failed to sync Doom Emacs"
}

backup
gitclone
packages
doom

cleanup() {
    echo "######################"
    echo "##                  ##"
    echo "##  Clean up files  ##"
    echo "##                  ##"
    echo "######################"

    rm -rf "$HOME/dotfiles"
}

cleanup || error "Failed to clean up files"

echo "#######################"
echo "##                   ##"
echo "##  All done! Enjoy  ##"
echo "##                   ##"
echo "#######################"
