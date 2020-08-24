#!/bin/bash

sudo sysctl vm.swappiness=10
clear
echo Swappiness reduced to: 
cat /proc/sys/vm/swappiness