#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "Please 'sudo ./run.sh'"
    exit 1
fi
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
        $i
    done
}

function git() {
    install git

    git config --global core.fileMode false
    git config --global credential.helper store

    getInput "GIT" "Default commit NAME"
    git config --global user.name "$globalInput"
    getInput "GIT" "Default commit EMAIL"
    git config --global user.email "$globalInput"
}

function git-flow() {
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
