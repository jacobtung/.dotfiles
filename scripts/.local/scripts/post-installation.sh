#!/bin/bash

###############################################################################
#                                  VARIABLES                                  #
###############################################################################

HOME=/home/jacob

dotfiles_url=https://github.com/jacobtung/.dotfiles

tsinghua_buster_apt_sourcelist="
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
"

tsinghua_bullseye_apt_sourcelist="
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
"
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

###############################################################################
#                                  FUNCTIONS                                  #
###############################################################################

apt_update() {
    sudo apt-get update -y && sudo apt-get upgrade -y
}

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
    mkdir -p ${HOME}/Pictures/Backgrounds
    mkdir -p ${HOME}/Pictures/Screenshots
    mkdir -p ${HOME}/.local/bin
}
system_settings_after() {
    sudo chown -R jacob.jacob ${HOME}
    vim -c 'PlugInstall | q | q'
}

depoly_dotfiles() {
    cd ${HOME}
    git clone dotfiles_url
    cd .dotfiles
    cmd=(dialog --separate-output --checklist "Please Select dotfiles you wanna
    to stow:" 22 76 16)
    options=(
        1  "zsh" off
        2  "vim" off
        3  "scripts" off
        4  "aria2" off
    ) 
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear
    for choice in $choices
    do
        case $choice in
            1)  stow -vt ${HOME} zsh ;;
            2)  stow -vt ${HOME} vim ;;
            3)  stow -vt ${HOME} scripts ;;
            4)  stow -vt ${HOME} aria2 ;;
        esac
    done
}

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

depoly_dotfiles

system_settings_after

echo "
###########################################################################
                        Post-Installation Completed 
###########################################################################
"
