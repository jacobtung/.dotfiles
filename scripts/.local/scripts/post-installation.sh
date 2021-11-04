!/bin/bash
#########
# NOTES #
#########
# 1. draw.io need to be downloaded and installed manually!
# 2. displaycal need to be installed manually if needed.

##################
# DATA STRUCTURE #
##################

HOME=/home/jacob

folders_created="
    /$HOME/Desktop
    /$HOME/Documents
    /$HOME/Downloads
    /$HOME/Dropbox
    /$HOME/Music/.lyrics
    /$HOME/.local/bin
    /$HOME/Pictures/Backgrounds
    /$HOME/Pictures/Screenshots
    /$HOME/.config/mpd/playlists
"

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
    dialog
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

system_utilties_packages="
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
    firefox-esr
    chromium
    thunderbird
    transmission-gtk
"

optional_packages="
    obs-studio
    gimp
    telegram-desktop
    liferea
"

###################
# FUNCTION BLOCKS #
###################

apt_update() {
    sudo apt update -y && sudo apt upgrade -y
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
    mkdir -p $folders_created
}

system_settings_after() {
    sudo apt remove fonts-noto-core fonts-noto-extra fonts-noto-mono fonts-noto-ui-core fonts-noto-ui-extra fonts-noto-unhinted
    sudo chown -R jacob.jacob $HOME
    vim -c 'PlugInstall | q | q'
    sudo systemctl disable mpd.service
}

get_spotify() {
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update && sudo apt install spotify-client
}

get_dropbox() {
    cd $HOME
    wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
}

get_discord() {
    cd $HOME/Downloads
    wget -O discord.deb https://discordapp.com/api/download\?platform\=linux\&format\=deb
    sudo dpkg -i ./discord.deb
    sudo apt -f install
}

get_vscode() {
    cd $HOME/Downloads
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code
}

get_virtualbox(){
    sudo sh -c 'echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bullseye contrib" >> /etc/apt/sources.list'
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt update && sudo apt install virtualbox-6.1
}

get_fdm() {
    cd $HOME/Downloads
    wget -t 1 -O - https://deb.fdmpkg.org/freedownloadmanager.deb
    sudo dpkg -i freedownloadmanager.deb
    sudo apt -f install
}

get_bitwarden() {
    cd $HOME/Downloads
    wget -t 1 -O - https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=appimage
    chmod u+x ./Bitwarden-*-x86_64.AppImage
    mv ./Bitwarden-*-x86_64.AppImage $HOME/.local/bin/
}

get_skype() {
    cd $HOME
    wget https://go.skype.com/skypeforlinux-64.deb
    sudo dpkg -i ./skypeforlinux-64.deb
    sudo apt -f install
}

get_typora() {
    wget -t 1 -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
    echo -e "\ndeb https://typora.io/linux ./" | sudo tee -a /etc/apt/sources.list
    sudo apt update && sudo apt install typora
}

get_sublimetext() {
    wget -t 1 -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt update && sudo apt install sublime-text
}

get_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

get_other_packages() {
    cd $HOME/Downloads
    cmd=(dialog --separate-output --checklist "Please Select Programs you wanna
    install:" 22 76 16)
    options=(
        1  "spotify" off
        2  "typora" off
        3  "sublimetext" off
        4  "ohmyzsh" off
        5  "dropbox" off
        6  "skype" off
        7  "virtualbox" off
        8  "vscode" off
        9  "discord" off
        10 "bitwarden" off
        11 "fdm" off
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
            5)  get_dropbox ;;
            6)  get_skype ;;
            7)  get_vitualbox ;;
            8)  get_vscode ;;
            9)  get_discord ;;
            10) get_bitwarden ;;
            11) get_fdm ;;
        esac
    done
}

depoly_dotfiles() {
    cd $HOME
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
            1)  stow -vt $HOME zsh ;;
            2)  stow -vt $HOME xmonad ;;
            3)  stow -vt $HOME xmobar ;;
            4)  stow -vt $HOME X ;;
            5)  stow -vt $HOME vim ;;
            6)  stow -vt $HOME typora ;;
            7)  stow -vt $HOME scripts ;;
            8)  stow -vt $HOME ncmpcpp ;;
            9)  stow -vt $HOME mpd ;;
            10) stow -vt $HOME ibus ;;
            11) stow -vt $HOME fontconfig ;;
            12) stow -vt $HOME dunst ;;
            13) stow -vt $HOME aria2 ;;
            14) stow -vt $HOME gtk ;;
            15) stow -vt $HOME themes ;;
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