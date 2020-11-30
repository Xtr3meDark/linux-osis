#!/bin/bash
clear

sudo sysctl vm.swappiness=5
sudo sysctl vm.vfs_cache_pressure=50

echo "" | sudo tee /etc/sysctl.d/99-sysctl.conf -a
echo "vm.swappiness=5" | sudo tee /etc/sysctl.d/99-sysctl.conf -a
echo "vm.vfs_cache_pressure=50" | sudo tee /etc/sysctl.d/99-sysctl.conf -a

clear
echo Swappiness and cache reduced to 5 and 50
