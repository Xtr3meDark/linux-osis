#!/bin/bash

#-----#
# VAR #
#-----#
DOWNLOADS="$HOME/Downloads/OSIS"
globalInput=""

#-----------#
# FUNCTIONS #
#-----------#
function getInput() {
    globalInput=$(zenity \
        --entry \
        --title="$1" \
        --text="$2")
}

function install() {
    sudo apt-get --yes install $@
}

function installSnap() {
    sudo snap install $@
}

function output() {
    array=($(echo $1 | tr "|" "\n"))

    for i in "${array[@]}"; do
        "install_$i"
    done
}

#----------#
# PACKAGES #
#----------#

# BOOT

function install_ventoy() {
    cd $DOWNLOADS
    curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest \
    | grep "browser_download_url" \
    | grep "linux" \
    | cut -d '"' -f 4 \
    | wget -i -
}

function install_woeusb() {
    sudo add-apt-repository ppa:nilarimogard/webupd8
    instal woeusb
}

# BROWSER

function install_chrome() {
    wget -c "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -P "$DOWNLOADS"
}

# EMAIL
function install_mailspring() {
    installSnap mailspring
}

# IDE

function install_android-studio() {
    installSnap "android-studio --classic"
    install "qemu-kvm bridge-utils"
}

function install_vscode() {
    installSnap "code --classic"
    code --install-extension Shan.code-settings-sync
}

# PASSWORD MANAGER

function install_myki() {
    wget -c "https://static.myki.com/releases/da/MYKI-latest-amd64.deb" -P "$DOWNLOADS"
}

# PROGRAMMING

function install_flutter() {
    cd $HOME
    install git
    git clone https://github.com/flutter/flutter.git
    echo "" >>.bashrc
    echo "export PATH=\$PATH:\$HOME/Android/Sdk/platform-tools:\$HOME/flutter/bin" >>.bashrc
}

# REMOTE

function install_anydesk() {
    sudo wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
    sudo echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list
    sudo apt update
    install anydesk
}

# TORRENT

function install_transmission() {
    install transmission
}

# VCS

function install_git() {
    install git

    git config --global core.fileMode false
    git config --global credential.helper store

    getInput "GIT" "Default commit NAME"
    git config --global user.name "$globalInput"
    getInput "GIT" "Default commit EMAIL"
    git config --global user.email "$globalInput"
}

function install_git-flow() {
    install git-flow
}

# VIDEO

function install_obs-studio() {
    installSnap obs-studio
}

function install_vlc() {
    install vlc
}

#------#
# MAIN #
#------#

# Make dir
mkdir "$DOWNLOADS"

# Remove apt lock and update repo
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
sudo apt update -y

zenity \
    --info \
    --no-wrap \
    --text="Note that still only works with Ubuntu"

# BOOT
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="BOOT" \
    --column="Check" \
    --column="Package name" \
    false ventoy \
    false woeusb)
output $input

# BROWSER
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Browser" \
    --column="Check" \
    --column="Package name" \
    false chrome)
output $input

# EMAIL -> thunderbird
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Email" \
    --column="Check" \
    --column="Package name" \
    false mailspring)
output $input

# IDE
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="IDE" \
    --column="Check" \
    --column="Package name" \
    false android-studio \
    false vscode)
output $input

# PASSWORD MANAGER
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Password manager" \
    --column="Check" \
    --column="Package name" \
    false myki)
output $input

# PHOTO -> gimp

# PROGRAMMING -> java, node
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Programming" \
    --column="Check" \
    --column="Package name" \
    false flutter)
output $input

# REMOTE
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Remote" \
    --column="Check" \
    --column="Package name" \
    false anydesk)
output $input

# SYSTEM -> tweaks

# TORRENT
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Torrent" \
    --column="Check" \
    --column="Package name" \
    false transmission)
output $input

# VCS
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Version control" \
    --column="Check" \
    --column="Package name" \
    false git \
    false git-flow)
output $input

# VIDEO -> kdelive
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Video" \
    --column="Check" \
    --column="Package name" \
    false obs-studio \
    false vlc)
output $input

# wget install
sudo dpkg -i $DOWNLOADS/*.deb
rm $DOWNLOADS/*.deb
