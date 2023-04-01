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
    echo "Finished installing 'whiptail' and 'git'"
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
    makepkg -si --noconfirm || error "Failed to install 'yay'"
    cd ..
    rm -rf yay
    echo "Finished installing yay"
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
    whiptail --title "Installing!" --msgbox "WARNING! The installation script is currently in public beta testing. There are almost certainly errors in it; therefore, it is strongly recommended that you not install this on production machines. It is recommended that you try this out in either a virtual machine or on a test machine." 16 60

    whiptail --title "Are You Sure You Want To Do This?" --yesno "Shall we begin installing?" 8 60 || { clear; exit 1; }
}

lastchance || error "User choose to exit."

grep "LANG" /etc/locale.conf && echo "Checking the LANG variable in /etc/locale.conf. Variable is already set." || error "LANG variable is not set in /etc/locale.conf"

backup() { \
    whiptail --title "Backup" --yesno "Do you want to backup your current configuration?" 8 60
}

backup && backup=true || backup=false

scipto=$(
    whiptail --title "Scip" --menu "Do you want to scip and when yes where?" 25 75 10 \
    "1)" "Don't scip" \
    "2)" "Go to Hyprland installation" \
    "3)" "Go to Doom Emacs installation" \
    "4)" "Go to grub theme installation" \
    "5)" "Go to sddm theme installation" \
    "6)" "Go to reboot" \
    "7)" "Exit" \
    3>&2 2>&1 1>&3
)

getfiles() { \
    bareclone() { \
        whiptail --title "Bare Clone" --yesno "Do you want to clone the bare repository?" 8 60
    }

    bareclone && bareclone=true || bareclone=false

    if [ "$backup" = true ]; then
        backupfile="$HOME/backup.$(date +%Y%m%d%H%M%S)" && mkdir -p "$backupfile"
        echo "made backup directory $backupfile"
    fi

    echo "##############################"
    echo "##                          ##"
    echo "##  Cloning git repository  ##"
    echo "##                          ##"
    echo "##############################"

    if [ -d "$HOME/dotfiles" ]; then
        echo "Directory $HOME/dotfiles exists."
        if [ "$backup" = true ]; then
            echo "Backing up $HOME/dotfiles to $backupfile"
            mv "$HOME/dotfiles" "$backupfile"
        else
            echo "Removing $HOME/dotfiles"
            rm -rf "$HOME/dotfiles"
        fi
    fi

    if [ "$bareclone" = true ]; then
        mkdir -p "$HOME/dotfiles"
        git clone --bare https://gitlab.gleissner.com/Moritz/dotfiles.git "$HOME/dotfiles" || error "Failed to clone the bare repository"
        echo "Finished cloning the bare repository"
    else
        git clone https://gitlab.gleissner.com/Moritz/dotfiles.git "$HOME/dotfiles" || error "Failed to clone the repository"
        echo "Finished cloning the repository"
    fi

    echo "################################"
    echo "##                            ##"
    echo "##  Moving dotfiles to home   ##"
    echo "##                            ##"
    echo "################################"

    if [ "$backup" = true ]; then
        echo "Backing up $HOME/.config to $backupfile"
        mv "$HOME/.config" "$backupfile"
        echo "Backing up $HOME/LICENCE to $backupfile"
        mv "$HOME/LICENCE" "$backupfile"
        echo "Backing up $HOME/README.org to $backupfile"
        mv "$HOME/README.org" "$backupfile"
        echo "Backing up $HOME/install-dotfiles.sh to $backupfile"
        mv "$HOME/install-dotfiles.sh" "$backupfile"
    else
        echo "Removing $HOME/.config"
        rm -rf "$HOME/.config"
        echo "Removing $HOME/LICENCE"
        rm "$HOME/LICENCE"
        echo "Removing $HOME/README.org"
        rm "$HOME/README.org"
        echo "Removing $HOME/install-dotfiles.sh"
        rm "$HOME/install-dotfiles.sh"
    fi

    if [ "$bareclone" = true ]; then
        git --git-dir="$HOME/dotfiles" --work-tree="$HOME" checkout || error "Failed to checkout the dotfiles"
        echo "Finished checking out the dotfiles"
    else
        mv "$HOME/dotfiles/.config" "$HOME/.config"
        rm -rf "$HOME/dotfiles"
        echo "Finished moving the dotfiles"
    fi
}

gethyprland() { \
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

    changehyprlandpackages && error "User choose to exit. You can change the package list at $HOME/dotfiles/.config/hypr/install-packages.sh"

    bash "$HOME/.config/hypr/install-packages.sh" || error "Failed to install Hyprland"
    echo "Finished installing Hyprland and the needed packages"

    activatesddm() { \
        whiptail --title "Installing!" --yesno "Do you want to activate sddm?" 8 60
    }

    if activatesddm; then
        sudo systemctl enable sddm.service || error "Failed to enable sddm"
        echo "Finished enabling sddm"
    fi
}

getdoomemacs() { \
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

        changeemacspackages && error "User choose to exit. You can change the package list at $HOME/dotfiles/.config/doom/install-packages.sh"

        bash "$HOME/.config/doom/install-packages.sh" || error "Failed to install Doom Emacs"
        echo "Finished installing Doom Emacs and the needed packages"

        git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.emacs.d" || error "Failed to clone Doom Emacs"
        "$HOME/.emacs.d/bin/doom" install || error "Failed to install Doom Emacs"
        "$HOME/.emacs.d/bin/doom" sync || error "Failed to sync Doom Emacs"

        startdaemon() {
            whiptail --title "Installing!" --yesno "Do you want to start the emcas daemon?" 8 60
        }

        startdaemon && startdaemon=true || startdaemon=false

        if [ "$startdaemon" = true ]; then
            systemctl --user enable emacs.service || error "Failed to enable emacs daemon"
            systemctl --user start emacs.service || error "Failed to start emacs daemon"
            echo "Finished starting the emacs daemon"
        fi

        echo "Finished installing Doom Emacs"
    fi
}

getgrubtheme() { \
    grubtheme() { \
        whiptail --title "Installing!" --yesno "Do you want to install the grub theme?" 8 60
    }

    grubtheme && grubtheme=true || grubtheme=false

    if [ "$grubtheme" = true ]; then
        echo "############################################"
        echo "##                                        ##"
        echo "##  Installing grub theme                 ##"
        echo "##                                        ##"
        echo "############################################"

        if [ "$backup" = true ]; then
            echo "Backing up $HOME/grub to $backupfile"
            mv "$HOME/grub" "$backupfile"
        else
            echo "Removing $HOME/grub"
            rm -rf "$HOME/grub"
        fi
        git clone https://github.com/catppuccin/grub.git "$HOME/grub" || error "Failed to clone grub theme"
        sudo mv "$HOME/grub/src/catppuccin-mocha-grub-theme/" /usr/share/grub/themes/ || error "Failed to copy grub theme"
        if [ "$backup" = true ]; then
            echo "Backing up /etc/default/grub to $backupfile"
            sudo mv /etc/default/grub "$backupfile"
        fi

        if grep -q -E "(^|\s)GRUB_THEME=" /etc/default/grub; then
            echo "Changing GRUB_THEME in /etc/default/grub"
            sudo sed -i "s/GRUB_THEME=.*/GRUB_THEME=\"\/usr\/share\/grub\/themes\/catppuccin-mocha-grub-theme\/theme.txt\"/g" /etc/default/grub || error "Failed to change grub theme"
        else
            echo "Adding GRUB_THEME to end of line"
            sudo bash -c "echo "GRUB_THEME=\"/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt\"" >> /etc/default/grub" || error "Failed to add grub theme at end of file"
        fi

        sudo grub-mkconfig -o /boot/grub/grub.cfg || error "Failed to update grub"
        rm -rf "$HOME/grub"
        echo "Finished installing grub theme"
    fi
}

getsddmtheme() { \
    sddmtheme() { \
        whiptail --title "Installing!" --yesno "Do you want to install the sddm theme?" 8 60
    }

    sddmtheme && sddmtheme=true || sddmtheme=false

    if [ "$sddmtheme" = true ]; then
        echo "############################################"
        echo "##                                        ##"
        echo "##  Installing sddm theme                 ##"
        echo "##                                        ##"
        echo "############################################"

        if [ -f "/etc/sddm.conf" ]; then
            if [ "$backup" = true ]; then
                echo "Backing up $HOME/sddm to $backupfile"
                mv "/etc/sddm.conf" "$backupfile"
            else
                echo "Removing $HOME/sddm"
                rm "/etc/sddm.conf"
            fi
        fi

        sudo bash -c "echo "[Theme]" >> /etc/sddm.conf" || error "Failed to add theme to sddm.conf"
        sudo bash -c "echo "Current=catppuccin" >> /etc/sddm.conf" || error "Failed to add theme to sddm.conf"
        echo "Finnished installing sddm theme"

    fi
}

reboot() { \
    echo "###########################"
    echo "##                       ##"
    echo "##  Finished installing  ##"
    echo "##                       ##"
    echo "###########################"

    while true; do
        read -rp "Do you want to reboot to get your instalation? [Y/n] " yn
        case $yn in
            [Yy]* ) reboot;;
            [Nn]* ) break;;
            "" ) reboot;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

case "$scipto" in
    "1)")
        echo "Installing all"
        getfiles && gethyprland && getdoomemacs && getgrubtheme && getsddmtheme && reboot
    ;;
    "2)")
        echo "Sciped cloning the repo"
        gethyprland && getdoomemacs && getgrubtheme && getsddmtheme && reboot
    ;;
    "3)") echo "Sciped clone and hyprland install"
        getdoomemacs && getgrubtheme && getsddmtheme && reboot
    ;;
    "4)") echo "Sciped clone, hyperland and doom emacs install"
        getgrubtheme && getsddmtheme && reboot
    ;;
    "5)") echo "Sciped clone, hyperland, doom emacs and grub theme install"
        getsddmtheme && reboot
    ;;
    "6)") echo "Sciped clone, hyperland, doom emacs, grub theme and sddm theme install"
        reboot
    ;;
    "7)") error "User choose to exit"
    ;;
esac
