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
cls

title Setting bullshit
haxelib set discord_rpc 1.0.0
haxelib set flixel-addons 2.11.0
haxelib set flixel-demos 2.9.0
haxelib set flixel-ui 2.4.0
haxelib set flixel 5.2.2
haxelib git flxanimate https://github.com/Dot-Stuff/flxanimate 768740a56b26aa0c072720e0d1236b94afe68e3e
haxelib install format 3.5.0
haxelib git hscript-iris https://github.com/pisayesiwsi/hscript-iris dev
haxelib git hxCodec https://github.com/SyncGit12/hxCodec
haxelib git openfl https://github.com/SyncGit12/openfl
haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp master
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git away3d https://github.com/moxie-coder/away3d
haxelib git hxCodec https://github.com/SyncGit12/hxCodec
haxelib git lime https://github.com/FunkinCrew/lime fe3368f611a84a19afc03011353945ae4da8fffd
haxelib install hxp 1.3.0
haxelib install hxvlc 1.9.2
haxelib git hscript-iris https://github.com/pisayesiwsi/hscript-iris dev
haxelib git hxCodec https://github.com/SyncGit12/hxCodec
haxelib git openfl https://github.com/SyncGit12/openfl
haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp master
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git away3d https://github.com/moxie-coder/away3d
haxelib git hxCodec https://github.com/SyncGit12/hxCodec
haxelib git lime https://github.com/FunkinCrew/lime fe3368f611a84a19afc03011353945ae4da8fffd
haxelib install thx.core
haxelib install thx.semver
haxelib git haxeui-flixel https://github.com/haxeui/haxeui-flixel da27e833947f32ef007ed11f523aa5524f5a5d54
haxelib git haxeui-core https://github.com/haxeui/haxeui-core 51c23588614397089a5ce182cddea729f0be6fa0
haxelib git flixel-text-input https://github.com/FunkinCrew/flixel-text-input 951a0103a17bfa55eed86703ce50b4fb0d7590bc
haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp master
haxelib git crashdumper http://github.com/larsiusprime/crashdumper
haxelib git funkin.vis https://github.com/FunkinCrew/funkVis 22b1ce089dd924f15cdc4632397ef3504d464e90
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git cbf91e2180fd2e374924fe74844086aab7891666
haxelib set flixel 5.2.2
echo fucking done folks
exit
