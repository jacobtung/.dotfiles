!/bin/bash

################## 
# DATA STRUCTURE # 
##################
HOME=/home/jacob

folders_created_before="
    $HOME/Desktop
    $HOME/Documents
    $HOME/Downloads
    $HOME/Pictures
"

folders_created_after="
    $HOME/Music/.lyrics
    $HOME/.config/mpd/playlists
    $HOME/Pictures/Backgrounds
    $HOME/Pictures/Screenshots
"

dotfiles_url=https://github.com/jacobtung/.dotfiles

tsinghua_bullseye_apt="
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

essential_packages="
    linux-headers-amd64
    intel-microcode
    amd64-microcode
    firmware-linux
    build-essential
    lm-sensors
    nfs-common
    nfs-kernel-server

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
    zsh
    ranger
    mpd
    ncmpcpp
    mpc
    pulseaudio
    pulsemixer
    network-manager

    xorg
    lightdm
    lightdm-gtk-greeter
    lightdm-gtk-greeter-settings
    libghc-xmonad-contrib-dev
    xmonad
    xmobar
    suckless-tools
    dialog
    libnotify-bin
    thunar
    gvfs
    gvfs-backends
    xterm
    imagemagick
    ibus
    ibus-rime
    vim-gtk
    mpv
    sxiv
    feh
    zathura
    zathura-pdf-poppler
    byzanz
    dunst
    fonts-noto-cjk
    fonts-noto-color-emoji
    fonts-cascadia-code
    papirus-icon-theme
    
    libreoffice
    firefox-esr
    chromium
    transmission-gtk
    gimp
    qbittorrent
    obs-studio
    liferea
"

###################
# FUNCTION BLOCKS #
###################

apt_update() {
    sudo apt update -y && sudo apt upgrade -y
}

ch_apt_repo() {
    echo "$tsinghua_bullseye_apt" > /etc/apt/sources.list
    echo apt source changed to tsinghua bullseye repo successfully!
}

system_settings_before() {
    sudo apt install -y apt-transport-https
    mkdir -p $folders_created_before
}

system_settings_after() {
    mkdir -p $folders_created_after
    sudo apt remove fonts-noto-core fonts-noto-extra fonts-noto-mono fonts-noto-ui-core fonts-noto-ui-extra fonts-noto-unhinted
    sudo chown -R jacob.jacob $HOME
    vim -c 'PlugInstall | q | q'
    sudo systemctl disable mpd.service
}

get_spotify() {
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --dearmor > /usr/share/keyrings/spotify.asc
    sudo chmod 644 /usr/share/keyrings/spotify.asc
    echo "deb [signed-by=/usr/share/keyrings/spotify.asc] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update && sudo apt install -y spotify-client
}

# need manully add autostart for ~/.dropbox-dist/dropboxd
get_dropbox() {
    cd $HOME
    wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
}

# not work now, cause not meet dependency of libappindicator1
get_discord() {
    cd $HOME/Downloads
    wget --content-disposition https://discordapp.com/api/download\?platform\=linux\&format\=deb
    sudo dpkg -i ./discord*.deb
    sudo apt -f install
}

get_vscode() {
    cd $HOME/Downloads
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/packages.microsoft.gpg
    sudo chmod 644 /usr/share/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update && sudo apt install -y code
}

get_virtualbox(){
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor > /usr/share/keyrings/oracle_vbox_2016.asc
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc | gpg --dearmor > /usr/share/keyrings/oracle_vbox.asc
    sudo chmod 644 /usr/share/keyrings/oracle_vbox.asc
    /usr/share/keyrings/oracle_vbox_2016.asc
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.asc signed-by=/usr/share/keyrings/oracle_vbox.asc] https://download.virtualbox.org/virtualbox/debian bullseye contrib" >> /etc/apt/sources.list'
    sudo apt update && sudo apt install -y virtualbox-6.1
}

get_fdm() {
    cd $HOME/Downloads
    wget -t 1 --content-disposition https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb
    sudo apt install -y libpulse-mainloop-glib0
    sudo dpkg -i freedownloadmanager.deb
    sudo apt -f install
    sudo ln -s /opt/freedownloadmanager/fdm /usr/bin/fdm
}

get_bitwarden() {
    cd $HOME/Downloads
    wget -t 1 --content-disposition https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=appimage
    chmod u+x ./Bitwarden-*-x86_64.AppImage
    sudo mv ./Bitwarden-*-x86_64.AppImage /usr/bin/
}

get_skype() {
    cd $HOME/Downloads
    wget https://go.skype.com/skypeforlinux-64.deb
    sudo dpkg -i ./skypeforlinux-64.deb
    sudo apt -f install
}

get_typora() {
    curl https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > /usr/share/keyrings/typora.asc
    sudo chmod 644 /usr/share/keyrings/typora.asc
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/typora.asc] https://typora.io/linux ./" | sudo tee /etc/apt/sources.list.d/typora.list
    sudo apt update && sudo apt install -y typora
}

get_sublimetext() {
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor > /usr/share/keyrings/sublimetext.asc
    sudo chmod 644 /usr/share/keyrings/sublimetext.asc
    echo "deb [signed-by=/usr/share/keyrings/sublimetext.asc] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt update && sudo apt install -y sublime-text
}

get_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

get_telegram() {
    sudo apt install -y telegram-desktop/bullseye-backports
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
        12 "telegram" off
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
            12) get_telegram ;;
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
            1)  rm $HOME/.zshrc $HOME/.zsh_history; stow -vt $HOME zsh ;;
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

leave_cleanup() {
    cd $HOME
    rm .wget_hsts .bashrc .profile .bash_history 
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
sudo apt install -y $essential_packages

get_other_packages

depoly_dotfiles

system_settings_after

leave_cleanup

echo "
###########################################################################
                        Post-Installation Completed 
###########################################################################
"
