#!/bin/bash

set -e

echo "This will only work if you have ffmpeg installed."

echo "Enter the name of the song you'd like to render."
read -r renderFolder

if [[ ! -d "$renderFolder" ]]; then
    echo "Error: Folder '$renderFolder' not found. Exiting."
    exit 1
fi

echo

echo "What would you like to name your rendered video?"
read -r renderName

if [[ -z "$renderName" ]]; then
    echo "Error: Render name cannot be empty. Exiting."
    exit 1
fi

echo

echo "What is the framerate of your images/video? (Default: 60)"
read -r vidFPS
vidFPS=${vidFPS:-60} 

echo

echo "Lastly, are you rendering your video in a lossless format? (y/N)"
read -r useLossless
useLossless=${useLossless:-n}  # Default to 'n' if empty

echo

echo "Starting..."
echo

if [[ "$useLossless" =~ ^[Yy]$ ]]; then
    fExt="png"
else
    fExt="jpg"
fi

if [[ -z $(ls "$renderFolder"/*.$fExt 2>/dev/null) ]]; then
    echo "Error: No *.$fExt files found in '$renderFolder'. Exiting."
    exit 1
fi

ffmpeg -r "$vidFPS" -i "$renderFolder/%07d.$fExt" "$renderName.mp4"

echo "Rendering complete! Output file: $renderName.mp4"
exit 0
