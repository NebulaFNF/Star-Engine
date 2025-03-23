#!/bin/bash

set -e

if ! command -v ffmpeg &> /dev/null; then
    echo "Error: FFmpeg is not installed. Please install it and try again."
    exit 1
fi

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
useLossless=${useLossless:-n}

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

# Check if output file already exists
if [[ -f "$renderName.mp4" ]]; then
    echo "Warning: '$renderName.mp4' already exists. Overwrite? (y/N)"
    read -r overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        echo "Exiting without overwriting."
        exit 1
    fi
fi

ffmpeg -r "$vidFPS" -i "$renderFolder/%d.$fExt" -c:v libx264 -crf 18 -preset slow "$renderName.mp4"

echo "Rendering complete! Output file: $renderName.mp4"
exit 0
