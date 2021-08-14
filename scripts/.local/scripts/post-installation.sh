#!/bin/bash

###############################################################################
#              jacob's debian buster post-installation script                 #
###############################################################################

# packages based on tsinghua repository

HOME=/home/jacob
user_local_bin=${HOME}/.local/bin/

server_packages="
    zsh
    git
    curl
    sudo
    vim
    htop
    neofetch
    unrar
    stow
    ssh
    lm-sensors
    nfs-kernel-server
    nfs-common
    ranger
    network-manager
    build-essential
    firmware-linux
    intel-microcode
"

wm_packages="
    xorg
    lightdm
    libghc-xmonad-contrib-dev
    xmonad
    suckless-tools
    xmobar
    ibus
    ibus-rime
    vim-gtk
    imagemagick
    mpv
    dunst
    sxiv 
    feh
    zathura
    zathura-pdf-poppler
    thunar
    gvfs
    gvfs-backends
    pulseaudio
    pulsemixer
    mpd
    mpc
    ncmpcpp
    fonts-noto-cjk
    fonts-noto-color-emoji
    firefox-esr
    chromium
    thunderbird
"

optional_packages="
    obs-studio
    liferea
    telegram-desktop
    gimp
    libreoffice
"

function updatetodate() {
    sudo apt-get update -y && sudo apt-get upgrade -y
}

function creat_user_local_bin() {
    if [ ! -d $user_local_bin ]; then
        mkdir -p $user_local_bin
    fi
}

function get_dropbox() {
    wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb
    sudo dpkg -i dropbox_2020.03.04_amd64.deb
    sudo aptget -f install
    dropbox -i install
}

function get_spotify() {
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install spotify-client
}

function get_typora() {
    wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
    echo -e "\ndeb https://typora.io/linux ./" | sudo tee -a /etc/apt/sources.list
    sudo apt-get update && sudo apt-get install typora
}

function get_discord() {
    wget https://discord.com/api/download?platform=linux&format=deb -O
    discord.deb
    sudo dpkg -i discord.deb
    sudo apt-get -f install
}

function get_skype() {
    wget https://go.skype.com/skypeforlinux-64.deb
    sudo dpkg -i skypeforlinux-64.deb
    sudo apt-get -f install
}

function get_bitwarden() {
    wget https://vault.bitwarden.com/download/?app=desktop&platform=linux -O
    Bitwarden-x86_64.AppImage
    mv Bitwarden-x86_64.AppImage ${user_local_bin}
}

function get_vscode() {
    wget https://code.visualstudio.com/docs/?dv=linux64_deb code.deb
    sudo dpkg -i code.deb
    sudo apt-get -f install
}

function get_virtualbox() {
    wget https://download.virtualbox.org/virtualbox/6.1.26/virtualbox-6.1_6.1.26-145957~Debian~buster_amd64.deb
    sudo dpkg -i virtualbox-6.1_6.1.26-145957~Debian~buster_amd64.deb
    sudo apt-get -f install
}

function get_teamviewer() {
    wget
    https://download.teamviewer.com/download/linux/teamviewer_amd64.deb?%3F= -O
    teamviewer.deb
    sudo dpkg -i teamviewer.deb
    sudo apt-get -f install
}

function get_sublimetext() {
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update && sudo apt-get install sublime-text
}

function get_displaycal() {
    wget https://displaycal.net/download/Debian_10/i386/DisplayCAL.deb
    sudo dpkg -i DisplayCAL.deb
    sudo apt-get -f install
}

function get_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

function get_other_packages() {
    sudo apt-get install dialog
    cmd=(dialog --separate-output --checklist "Please Select Programs you wanna
    install:" 22 76 16)
    options=(
        1  "dropbox" off
        2  "spotify" off
        3  "typora" off
        4  "discord" off
        5  "skype" off
        6  "bitwarden" off
        7  "vscode" off
        8  "virtualbox" off
        9  "teamviewer" off
        10 "sublimetext" off
        11 "displaycal" off
        12 "ohmyzsh" off
    )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear
    for choice in $choices
    do
        case $choice in
            1)  get_dropbox ;;
            2)  get_spotify ;;
            3)  get_typora ;;
            4)  get_discord ;;
            5)  get_skype ;;
            6)  get_bitwarden ;;
            7)  get_vscode ;;
            8)  get_virtualbox ;;
            9)  get_teamviewer ;;
            10) get_sublimetext ;;
            11) get_displaycal ;;
            12) get_ohmyzsh ;;
        esac
    done
}

function get_dotfiles() {
    git clone https://github.com/jacobtung/.dotfiles
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
        esac
    done
}

# make sure the script has root or sudo privilage
if [[ "${UID}" -ne 0 ]]
then
    echo 'Must execute with sudo or root' >&2
    exit 1
fi

cat > /etc/apt/sources.list << EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free   
EOF

creat_user_local_bin

# install package
updatetodate
sudo apt install -y ${server_packages}

read -n 1 -p "
###########################################################################
Do you wanna install wm environment related packages? y/n 
###########################################################################
" wm_input

if [ "$wm_input" = "y" ]; then
    sudo apt install ${wm_packages} -y
fi
  
read -n 1 -p "
###########################################################################
Do you wanna install optional packages? Y/n
###########################################################################
" optional_input
if [ "$optional_input" = "y" ]; then
    sudo apt install -y ${optional_packages}
fi

get_other_packages

get_dotfiles

echo "Post-Installation Completed."
