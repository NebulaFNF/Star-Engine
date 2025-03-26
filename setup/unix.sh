#!/bin/sh
# SETUP FOR MAC AND LINUX SYSTEMS!!!
# REMINDER THAT YOU NEED HAXE INSTALLED PRIOR TO USING THIS
# https://haxe.org/download
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
sudo apt install libgl1-mesa-dev libglu1-mesa-dev g++ g++-multilib gcc-multilib libasound2-dev libx11-dev libxext-dev libxi-dev libxrandr-dev libxinerama-dev libpulse-dev sdl2_ttf-debugsource
sudo apt install libvlc-dev libvlccore-dev libvlccore9
haxelib setup
haxelib install discord_rpc 1.0.0
haxelib install flixel-addons 2.11.0
haxelib install flixel-demos 2.9.0
haxelib install flixel-ui 2.4.0
haxelib install flixel 5.2.2
haxelib install flxanimate 3.0.4
haxelib install openfl 9.3.0
haxelib install lime
haxelib run lime setup flixel
haxelib run lime setup
haxelib set discord_rpc 1.0.0
haxelib set flixel-addons 2.11.0
haxelib set flixel-demos 2.9.0
haxelib set flixel-ui 2.4.0
haxelib set flixel 5.2.2
haxelib git flxanimate https://github.com/NothinCrew/flxanimate
haxelib install format 3.5.0
haxelib git hscript-iris https://github.com/pisayesiwsi/hscript-iris dev
haxelib git openfl https://github.com/SyncGit12/openfl
haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git away3d https://github.com/moxie-coder/away3d
haxelib git lime https://github.com/FunkinCrew/lime fe3368f611a84a19afc03011353945ae4da8fffd
haxelib install hxp 1.3.0
haxelib install hxvlc 1.9.2
haxelib git haxeui-flixel https://github.com/haxeui/haxeui-flixel da27e833947f32ef007ed11f523aa5524f5a5d54
haxelib git haxeui-core https://github.com/haxeui/haxeui-core 51c23588614397089a5ce182cddea729f0be6fa0
haxelib git flixel-text-input https://github.com/FunkinCrew/flixel-text-input 951a0103a17bfa55eed86703ce50b4fb0d7590bc
haxelib install thx.core
haxelib install thx.semver
echo Finished!
