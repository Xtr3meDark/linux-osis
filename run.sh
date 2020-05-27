#!/bin/bash

globalInput=""

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
    echo "git-flow installation"
}

#------#
# MAIN #
#------#

zenity \
    --info \
    --no-wrap \
    --text="Note that still only works with Ubuntu"

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
