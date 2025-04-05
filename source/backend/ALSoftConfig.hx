package backend;

import haxe.io.Path;
import flixel.FlxG;
#if sys
import sys.FileSystem;
#elseif openfl
import openfl.utils.Assets as OpenFlAssets;
#end

/*
A class that simply points OpenALSoft to a custom configuration file when the game starts up.
The config overrides a few global OpenALSoft settings with the aim of improving audio quality on desktop targets.
*/
@:keep class ALSoftConfig
{
	#if desktop
	static function __init__():Void
	{
		var origin:String = #if hl Sys.getCwd() #else Sys.programPath() #end;

		var configPath:String = Path.directory(Path.withoutExtension(origin));
		#if windows
		configPath += "/alsoft.ini";
		#elseif mac
		configPath = Path.directory(configPath) + "/Resources/alsoft.conf";
		#else
		configPath += "/alsoft.conf";
		#end

		#if sys
		if (!FileSystem.exists(configPath)) {
			trace('Could not find alsoft.ini!' + '\nIs the file missing?');
			FlxG.log.warn('Could not find alsoft.ini! Expect bad video and audio quality!');
		}
		#elseif openfl
		if (!OpenFLAssets.exists(configPath)) {
			trace('Could not find alsoft.ini!' + '\nIs the file missing?');
			FlxG.log.warn('Could not find alsoft.ini! Expect bad video and audio quality!');
		}
		#end
		Sys.putEnv("ALSOFT_CONF", configPath);
	}
	#end
}