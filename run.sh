#!/bin/bash

#-----#
# VAR #
#-----#
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
#  UPDATE  #
#----------#

function update() {
	sudo apt-get update
}

#----------#
# PACKAGES #
#----------#

# IDE

function install_android-studio() {
    installSnap android-studio
    install "qemu-kvm bridge-utils"
}

function install_vscode() {
    installSnap code
    code --instal-extension Shan.code-settings-sync
}

# PROGRAMMING

function install_flutter() {
    cd $HOME
    git clone https://github.com/flutter/flutter.git
    echo "" >> .bashrc
    echo "export PATH=\$PATH:\$HOME/Android/Sdk/platform-tools:\$HOME/flutter/bin" >> .bashrc
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

function install_vlc() {
    install vlc
}

#------#
# MAIN #
#------#

# Remove apt lock and update repo
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
update

zenity \
    --info \
    --no-wrap \
    --text="Note that still only works with Ubuntu"

# browsers -> chrome

# email -> thunderbird, mailspring

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

# PHOTO -> gimp

# PROGRAMMING -> java, flutter, node

input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Programming" \
    --column="Check" \
    --column="Package name" \
    false flutter)
output $input

# system -> tweaks

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

# VIDEO -> obs, kdelive

input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Video" \
    --column="Check" \
    --column="Package name" \
    false vlc)
output $input
