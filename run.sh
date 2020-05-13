#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Please 'sudo ./run.sh'" 
   exit 1
fi