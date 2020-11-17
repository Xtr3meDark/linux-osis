#!/bin/bash

# If it says that needs at least one package, it means that you don't need it now

sudo dpkg -l | grep "^rc" | awk '{print $2}' | sudo xargs dpkg -P

# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu

LANG=C snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done
