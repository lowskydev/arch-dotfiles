#!/usr/bin/env bash

# Get all audio sinks from PipeWire/PulseAudio and store names and descriptions
# in separate arrays (indices match: names[0] corresponds to descs[0])
names=()
descs=()

# Read pactl output line by line
# Lines with Name: contain the internal sink identifier
# Lines with Description: contain the human readable name
while IFS= read -r line; do
    if [[ "$line" =~ $'\t'Name:\ (.*) ]]; then
        names+=("${BASH_REMATCH[1]}")
    elif [[ "$line" =~ $'\t'Description:\ (.*) ]]; then
        descs+=("${BASH_REMATCH[1]}")
    fi
done < <(pactl list sinks)

# Build the menu string from human readable descriptions
# printf with %s\n puts each description on its own line
menu=$(printf '%s\n' "${descs[@]}")

# Show rofi dmenu with the list of descriptions
# User sees friendly names like "WH-1000XM5" not "bluez_output.AC_80_0A..."
# Returns the description the user selected, or empty string if cancelled
chosen=$(echo "$menu" | rofi -dmenu -p "Audio Output" -theme ~/.config/rofi/launcher.rasi)

# Exit silently if user pressed Escape or closed rofi
[ -z "$chosen" ] && exit

# Find the internal sink name that matches the chosen description
# We need the internal name because pactl commands use it, not the description
sink_name=""
for i in "${!descs[@]}"; do
    if [[ "${descs[$i]}" == "$chosen" ]]; then
        sink_name="${names[$i]}"
        break
    fi
done

# Exit if no match found (shouldn't happen but defensive programming)
[ -z "$sink_name" ] && exit

# Set the chosen sink as the system default
# New audio streams will automatically go to this sink
pactl set-default-sink "$sink_name"

# Move all currently active audio streams to the new sink
# Without this, Spotify and other playing apps would continue
# on the old sink until restarted
# pactl list sink-inputs short gives: id state sink name ...
# awk extracts just the id (first column)
pactl list sink-inputs short | awk '{print $1}' | while read -r stream; do
    pactl move-sink-input "$stream" "$sink_name"
done
