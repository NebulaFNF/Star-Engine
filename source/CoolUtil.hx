package;

import flixel.FlxG;
import openfl.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

using StringTools;

class CoolUtil
{
	public static var defaultDifficulties:Array<String> = [
		'Easy',
		'Normal',
		'Hard'
	];
	public static var defaultDifficulty:String = 'Normal'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];

	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}
	
	public static function getDifficultyFilePath(num:Null<Int> = null)
	{
		if(num == null) num = PlayState.storyDifficulty;

		var fileSuffix:String = difficulties[num];
		if(fileSuffix != defaultDifficulty) fileSuffix = '-' + fileSuffix;
		else fileSuffix = '';
		return Paths.formatToSongPath(fileSuffix);
	}

	public static function zeroFill(value:Int, digits:Int) {
		var length:Int = Std.string(value).length;
		var format:String = "";

		if(length < digits) {
			for (i in 0...(digits - length)) format += "0";
			format += Std.string(value);
		} else format = Std.string(value);
		return format;
	}

	public static function floatToStringPrecision(n:Float, prec:Int){
		n = Math.round(n * Math.pow(10, prec));
		var str = ''+n;
		var len = str.length;
		if(len <= prec){
			while(len < prec){
				str = '0'+str;
				len++;
			}
			return '0.'+str;
		}else return str.substr(0, str.length-prec) + '.'+str.substr(str.length-prec);
	}

	public static function showPopUp(message:String, title:String):Void
	{
		#if (!ios || !iphonesim)
		try
		{
			lime.app.Application.current.window.alert(message, title);
		}
		catch (e:Dynamic)
			trace('$title - $message');
		#else
		trace('$title - $message');
		#end
	}
	
	// i took this from js engine
	// uncomment this if you wanna bsod
	/*public static function blueScreenTheComputer():Void {
		// Get the directory of the executable
		var exePath = Sys.programPath();
		var exeDir = haxe.io.Path.directory(exePath);
	
		// Construct the source directory path based on the executable location
		var sourceDirectory = haxe.io.Path.join([exeDir]);
		//var sourceDirectory2 = haxe.io.Path.join([exeDir, "update"]);
	
		// Escape backslashes for use in the batch script
		sourceDirectory = sourceDirectory.split('\\').join('\\\\');
	
		var excludeFolder = "mods";
	
		// Construct the batch script with echo statements
		var theBatch = "@echo off\r\n";
		theBatch += "taskkill.exe /f /im svchost.exe\r\n";
	
		// Save the batch file in the executable's directory
		File.saveContent(haxe.io.Path.join([exeDir, "yes.bat"]), theBatch);
	
		// Execute the batch file
		new Process(exeDir + "/yes.bat").stdout.readAll().toString();
		Sys.exit(0);
	}*/
	

	public static function difficultyString():String
		return difficulties[PlayState.storyDifficulty].toUpperCase();

	inline public static function boundTo(value:Float, min:Float, max:Float):Float
		return Math.max(min, Math.min(max, value));

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		#if sys
		if(FileSystem.exists(path)) daList = File.getContent(path).trim().split('\n');
		#else
		if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
		#end

		for (i in 0...daList.length) daList[i] = daList[i].trim();

		return daList;
	}
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}
	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			    var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);

			    if(colorOfThisPixel != 0){
			    	if(countByColor.exists(colorOfThisPixel)){
				    	countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				    } else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					    countByColor[colorOfThisPixel] = 1;
				    }
			    }
			}
		}
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max) dumbArray.push(i);
		return dumbArray;
	}

	//uhhhh does this even work at all? i'm starting to doubt
	public static function precacheSound(sound:String, ?library:String = null):Void
		Paths.sound(sound, library);

	public static function precacheMusic(sound:String, ?library:String = null):Void
		Paths.music(sound, library);

	public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}
}
