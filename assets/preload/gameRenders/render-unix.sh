#!/bin/bash

echo "hello there!"
echo "PS: this will only work if you have ffmpeg installed."

echo "Enter the name of the song you'd like to render! (this is the folder that you'll use)"
read -r renderFolder

echo

echo "What would you like to name your rendered video?"
read -r renderName

echo

echo "What is the framerate of your images/video? (defaults to 60)"
read -r vidFPS
vidFPS=${vidFPS:-60}  # Default to 60 if empty

echo

echo "Lastly, are you rendering your video in a lossless format? (y/n, default n, makes the renderer find pngs instead of jpgs)"
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

ffmpeg -r "$vidFPS" -i "$PWD/$renderFolder/%07d.$fExt" "$renderName.mp4"

exit 0
