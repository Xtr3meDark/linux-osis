#!/bin/bash
echo "Removing Config..."
rm ~/.config/pulse/*

echo "Exit PulseEffects"
pulseeffects -q

echo "Exit PulseAudio"
pulseaudio -k

echo "Init EQ..."
sleep 2
pulseeffects --gapplication-service&

echo "Reset PulseEffects"
sleep 2
# Chage the "PulseEffects" string to your preset
pulseeffects -l "PulseEffects"

echo "Done"
