#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Please 'sudo ./run.sh'" 
   exit 1
fi

zenity --list --checklist --title="Packages"\
    --text="Select what you want to install "\
    --column=""\
    --column="Package name"\
    false A\
    false B\