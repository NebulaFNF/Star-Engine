package funkin.backend.alsoft;

import flixel.FlxG;
import haxe.io.Path;

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
		Sys.putEnv("ALSOFT_CONF", configPath);
	}
	#end
}
