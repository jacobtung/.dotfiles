#!/bin/bash

#############
# VARIABLES #
#############

HOME=/home/jacob

dotfiles_url=https://github.com/jacobtung/.dotfiles

tsinghua_buster_apt="
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
"

tsinghua_bullseye_apt="
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
"

basic_packages="
    git
    sudo
    curl
    vim
    htop
    neofetch
    unrar
    p7zip-full
    bzip2
    unzip
    ssh
    stow
    lm-sensors
    nfs-common
    nfs-kernel-server
    build-essential
    firmware-linux
    intel-microcode
    imagemagick
    pulseaudio
    fonts-noto-cjk
    fonts-noto-color-emoji
    fonts-cascadia-code
    papirus-icon-theme
"

sytem_utilties_packages="
    zsh
    ranger
    xterm
    network-manager
    lightdm
    xorg
    libghc-xmonad-contrib-dev
    xmonad
    xmobar
    ibus
    ibus-rime
    vim-gtk
    mpv
    sxiv
    feh
    zathura
    zathura-pdf-poppler
    byzanz
    mpd
    ncmpcpp
    mpc
    dunst
    thunar
    gvfs
    gvfs-backends
    pulsemixer
    libreoffice
    suckless-tools
"

daily_use_packages="
    firefox-esr
    chromium
    thunderbird
    telegram-desktop
    liferea
"

optional_packages="
    obs-studio
    gimp
    transmission-gtk
"

#############
# FUNCTIONS #
#############

apt_update() {
    sudo apt-get update -y && sudo apt-get upgrade -y
}

ch_apt_repo() {
    sudo apt install dialog
    local select=`dialog --menu "Select Debian Version" 22 76 5 1 "Buster" 2 "Bullseye" 2>&1 >/dev/tty`
    if [ $select = 1 ]; then
        clear
        echo "$tsinghua_buster_apt" > /etc/apt/sources.list
        echo apt source changed to tsinghua buster repo successfully!
    elif [ $select = 2 ]; then
        clear
        echo "$tsinghua_bullseye_apt" > /etc/apt/sources.list
        echo apt source changed to tsinghua bullseye repo successfully!
    else
        clear
        echo Something bad happend! XD
    fi
}

system_settings_before() {
    mkdir -p $HOME/Downloads
    mkdir -p $HOME/Pictures/Backgrounds
    mkdir -p $HOME/Pictures/Screenshots
    mkdir -p $HOME/.local/bin
}

system_settings_after() {
    sudo chown -R jacob.jacob ${HOME}
    vim -c 'PlugInstall | q | q'
    sudo systemctl disable mpd.service
    mkdir -p $HOME/.config/mpd/playlists
}

get_spotify() {
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install spotify-client
}

get_typora() {
    wget -t 1 -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
    echo -e "\ndeb https://typora.io/linux ./" | sudo tee -a /etc/apt/sources.list
    sudo apt-get update && sudo apt-get install typora
}

get_sublimetext() {
    wget -t 1 -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update && sudo apt-get install sublime-text
}

get_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

get_other_packages() {
    cd ${HOME}/Downloads
    cmd=(dialog --separate-output --checklist "Please Select Programs you wanna
    install:" 22 76 16)
    options=(
        1  "spotify" off
        2  "typora" off
        3  "sublimetext" off
        4  "ohmyzsh" off
    )
    choices=`"${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty`
    clear
    for choice in $choices
    do
        case $choice in
            1)  get_spotify ;;
            2)  get_typora ;;
            3)  get_sublimetext ;;
            4)  get_ohmyzsh ;;
        esac
    done
}

depoly_dotfiles() {
    cd ${HOME}
    git clone dotfiles_url
    cd .dotfiles
    cmd=(dialog --separate-output --checklist "Please Select dotfiles you wanna
    to stow:" 22 76 16)
    options=(
        1  "zsh" off
        2  "xmonad" off
        3  "xmobar" off
        4  "X" off
        5  "vim" off
        6  "typora" off
        7  "scripts" off
        8  "ncmpcpp" off
        9  "mpd" off
        10 "ibus" off
        11 "fontconfig" off
        12 "dunst" off
        13 "aria2" off
        14 "gtk" off
        15 "nordtheme" off
    ) 
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear
    for choice in $choices
    do
        case $choice in
            1)  stow -vt ${HOME} zsh ;;
            2)  stow -vt ${HOME} xmonad ;;
            3)  stow -vt ${HOME} xmobar ;;
            4)  stow -vt ${HOME} X ;;
            5)  stow -vt ${HOME} vim ;;
            6)  stow -vt ${HOME} typora ;;
            7)  stow -vt ${HOME} scripts ;;
            8)  stow -vt ${HOME} ncmpcpp ;;
            9)  stow -vt ${HOME} mpd ;;
            10) stow -vt ${HOME} ibus ;;
            11) stow -vt ${HOME} fontconfig ;;
            12) stow -vt ${HOME} dunst ;;
            13) stow -vt ${HOME} aria2 ;;
            14) stow -vt ${HOME} gtk ;;
            15) stow -vt ${HOME} themes ;;
        esac
    done
}

#############
#    MAIN   #
#############

echo "
###########################################################################
#                  jacob's debian post-installation script                #
###########################################################################

# ABOUT THIS SCRIPT!
# 1) packages based on tsinghua repository
# 2) debian installation:
#       1.ssh server
#       2.standard system utilities

"

# 1.check privilage

if [[ "${UID}" -ne 0 ]]
then
    echo 'Must execute with sudo or root' >&2
    exit 1
fi

# 2.creat environment

system_settings_before
ch_apt_repo
apt_update

#3.installation start
sudo apt install -y ${basic_packages}
sudo apt install -y ${system_utilies_packages}
sudo apt install -y ${daily_use_packages}
  
read -n 1 -p "
###########################################################################
                Do you wanna install optional packages? y/n
###########################################################################
" optional_input
if [ $optional_input = y ] || [ $optional_input = Y ]; then
    sudo apt install -y ${optional_packages}
fi

get_other_packages

depoly_dotfiles

system_settings_after

echo "
###########################################################################
                        Post-Installation Completed 
###########################################################################
"
