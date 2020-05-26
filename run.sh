#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "Please 'sudo ./run.sh'"
    exit 1
fi

function output() {
    array=($(echo $1 | tr "|" "\n"))

    for i in "${array[@]}"; do
        $i
    done
}

zenity \
    --info \
    --no-wrap \
    --text="Note that still only works with Ubuntu"

function git() {
    echo "git installation"
}

function git-flow() {
    echo "git-flow installation"
}

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
