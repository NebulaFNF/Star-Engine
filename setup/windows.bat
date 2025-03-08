@echo off
title Installing bullshit
echo this might take a lil while :DDDD
haxelib setup
haxelib install discord_rpc 1.0.0
haxelib install flixel-addons 2.11.0
haxelib install flixel-demos 2.9.0
haxelib install flixel-ui 2.4.0
haxelib install flixel 5.2.2
haxelib install flxanimate 3.0.4
haxelib install hxCodec 2.5.1
haxelib install openfl 9.3.0
haxelib install lime
haxelib run lime setup flixel
haxelib run lime setup
clear

title Setting bullshit
haxelib set discord_rpc 1.0.0
haxelib set flixel-addons 2.11.0
haxelib set flixel-demos 2.9.0
haxelib set flixel-ui 2.4.0
haxelib set flixel 5.2.2
haxelib set flxanimate 3.0.4
haxelib git hscript-iris https://github.com/pisayesiwsi/hscript-iris dev
haxelib git hxCodec https://github.com/SyncGit12/hxCodec
haxelib git openfl https://github.com/SyncGit12/openfl
haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git away3d https://github.com/moxie-coder/away3d
haxelib git hxCodec https://github.com/SyncGit12/hxCodec
haxelib install hxvlc 1.9.2
echo fucking done folks
exit
