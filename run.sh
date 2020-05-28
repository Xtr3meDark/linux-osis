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

function output() {
    array=($(echo $1 | tr "|" "\n"))

    for i in "${array[@]}"; do
        "install_$i"
    done
}

#----------#
# PACKAGES #
#----------#

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

#------#
# MAIN #
#------#

# Remove apt lock and update repo
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
sudo apt update -y

zenity \
    --info \
    --no-wrap \
    --text="Note that still only works with Ubuntu"

# browsers -> chrome

# email -> thunderbird, mailspring

# ide -> vscode, android studio

# system -> tweaks

# TORRENT -> transmission
input=$(zenity \
    --list \
    --checklist \
    --title="Packages" \
    --text="Version control" \
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

# video -> vlc, obs, kdelive
