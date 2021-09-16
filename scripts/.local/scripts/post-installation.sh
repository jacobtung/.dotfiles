#!/bin/bash

###############################################################################
#                                  TO DO LIST                                 #
###############################################################################

#
#
#
#
#

###############################################################################
#                                  VARIABLES                                  #
###############################################################################

HOME=/home/jacob

dotfiles_url=https://github.com/jacobtung/.dotfiles

tsinghua_buster_apt_sourcelist="
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
"

tsinghua_bullseye_apt_sourcelist="
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
"

# note:packages name are based on tsinghua repo debian/buseter, so notice the
# difference between different repo
essential_packages="
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
    papirus-icon-theme
    xmobar
    ibus
    ibus-rime
    vim-gtk
    imagemagick
    mpv
    dunst
    sxiv 
    feh
    byzanz
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

###############################################################################
#                                  FUNCTIONS                                  #
###############################################################################

apt_update() {
    sudo apt-get update -y && sudo apt-get upgrade -y
}

# note: echo some text \t next line 
# echo will igonre \t unless you add "some text\t next line"
# here we need echo "$apt_sourceslist_include_\t_in text"
ch_apt_repo() {
    sudo apt install dialog
    local select=`dialog --menu "Select Debian Version" 22 76 5 1 "Buster" 2 "Bullseye" 2>&1 >/dev/tty`
    if [ $select = 1 ]; then
        clear
        echo "$tsinghua_buster_apt_sourcelist" > /etc/apt/sources.list
        echo apt source changed to tsinghua buster repo successfully!
    elif [ $select = 2 ]; then
        clear
        echo "$tsinghua_bullseye_apt_sourcelist" > /etc/apt/sources.list
        echo apt source changed to tsinghua bullseye repo successfully!
    else
        clear
        echo Something bad happend! XD
    fi
}

system_settings_before() {
    mkdir -p ${HOME}/Downloads
    mkdir -p ${HOME}/Pictures/Backgrouds
    mkdir -p ${HOME}/Pictures/Screenshots
    mkdir -p ${HOME}/.local/bin
}
system_settings_after() {
    sudo chown -R jacob.jacob ${HOME}
    vim -c 'PlugInstall | q | q'
}

get_cascadiacode() {
    wget -t 1 https://github.com/microsoft/cascadia-code/releases/download/v2108.26/CascadiaCode-2108.26.zip
    unzip CascadiaCode*.zip
    sudo mv ./ttf /usr/share/fonts/truetype/CascadiaCode
    fc-cache
}
get_dropbox() {
    wget -t 1 https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb
    sudo dpkg -i dropbox_2020.03.04_amd64.deb
    sudo apt-get -fy install
    dropbox -i install
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

get_discord() {
    wget -t 1 https://discord.com/api/download?platform=linux&format=deb -O
    discord.deb
    sudo dpkg -i discord.deb
    sudo apt-get -fy install
}

get_skype() {
    wget -t 1 https://go.skype.com/skypeforlinux-64.deb
    sudo dpkg -i skypeforlinux-64.deb
    sudo apt-get -fy install
}

get_bitwarden() {
    wget -t 1 https://vault.bitwarden.com/download/?app=desktop&platform=linux -O
    Bitwarden-x86_64.AppImage
    mv Bitwarden-x86_64.AppImage ${HOME}/.local/bin/
    chmod u+x ${HOME}/.local/bin/Bitwarden-x84_64.AppImage
}

get_vscode() {
    wget -t 1 https://code.visualstudio.com/docs/?dv=linux64_deb code.deb
    sudo dpkg -i code.deb
    sudo apt-get -fy install
}

get_virtualbox() {
    wget -t 1 https://download.virtualbox.org/virtualbox/6.1.26/virtualbox-6.1_6.1.26-145957~Debian~buster_amd64.deb
    sudo dpkg -i virtualbox-6.1_6.1.26-145957~Debian~buster_amd64.deb
    sudo apt-get -fy install
}

get_teamviewer() {
    wget -t 1 https://download.teamviewer.com/download/linux/teamviewer_amd64.deb?%3F= -O teamviewer.deb
    sudo dpkg -i teamviewer.deb
    sudo apt-get -fy install
}
 
get_sublimetext() {
    wget -t 1 -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update && sudo apt-get install sublime-text
}

get_displaycal() {
    wget -t 1 https://displaycal.net/download/Debian_10/i386/DisplayCAL.deb
    sudo dpkg -i DisplayCAL.deb
    sudo apt-get -fy install
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
        13 "CascadiaCode" off
    )
    choices=`"${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty`
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
            13) get_cascadiacode ;;
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


/
###############################################################################
#                                     MAIN                                    #
###############################################################################

echo "
###########################################################################
#             jacob's debian buster post-installation script              #
###########################################################################

# ABOUT THIS SCRIPT!
# 1) packages based on tsinghua repository
# 2) debian installation:
#       1.ssh server
#       2.print server
#       3.standard system utilities

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
sudo apt install -y ${essential_packages}

read -n 1 -p "
###########################################################################
        Do you wanna install wm environment related packages? y/n 
###########################################################################
" wm_input

if [ $wm_input = y ] || [ $wm_input = Y ]; then
    sudo apt install ${wm_packages} -y
fi
  
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
