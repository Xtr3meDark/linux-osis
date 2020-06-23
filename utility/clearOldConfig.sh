#!/bin/bash

# If it says that needs at least one package, it means that you don't need it now

sudo dpkg -l | grep "^rc" | awk '{print $2}' | sudo xargs dpkg -P