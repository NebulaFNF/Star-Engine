package funkin.utils;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import funkin.crash.CrashHandler;
import funkin.play.note.Note.EventNote;
import openfl.utils.Assets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

class CoolUtil
{
	public static var defaultDifficulties:Array<String> = ['Easy', 'Normal', 'Hard'];
	public static var defaultDifficulty:String = 'Normal'; // The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];

	inline public static function quantize(f:Float, snap:Float)
	{
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}

	public static function getDifficultyFilePath(num:Null<Int> = null)
	{
		if (num == null)
			num = funkin.play.PlayState.storyDifficulty;

		var fileSuffix:String = difficulties[num];
		if (fileSuffix != defaultDifficulty)
			fileSuffix = '-' + fileSuffix;
		else
			fileSuffix = '';
		return Paths.formatToSongPath(fileSuffix);
	}

	public static function zeroFill(value:Int, digits:Int)
	{
		var length:Int = Std.string(value).length;
		var format:String = "";

		if (length < digits)
		{
			for (i in 0...(digits - length))
				format += "0";
			format += Std.string(value);
		}
		else
			format = Std.string(value);
		return format;
	}

	public static function floatToStringPrecision(n:Float, prec:Int)
	{
		n = Math.round(n * Math.pow(10, prec));
		var str = '' + n;
		var len = str.length;
		if (len <= prec)
		{
			while (len < prec)
			{
				str = '0' + str;
				len++;
			}
			return '0.' + str;
		}
		else
			return str.substr(0, str.length - prec) + '.' + str.substr(str.length - prec);
	}

	#if FEATURE_DEBUG_TRACY
	/**
	 * Initialize Tracy.
	 * NOTE: Call this from the main thread ONLY!
	 */
	public static function initTracy():Void
	{
		// Apply a marker to indicate frame end for the Tracy profiler.
		// Do this only if Tracy is configured to prevent lag.
		openfl.Lib.current.stage.addEventListener(openfl.events.Event.EXIT_FRAME, (e:openfl.events.Event) ->
		{
			cpp.vm.tracy.TracyProfiler.frameMark();
		});

		var appInfoMessage = CrashHandler.buildSystemInfo();

		trace("Friday Night Funkin' Star Engine: Connection to Tracy profiler successful.");

		// Post system info like Git hash
		cpp.vm.tracy.TracyProfiler.messageAppInfo(appInfoMessage);

		cpp.vm.tracy.TracyProfiler.setThreadName("main");
	}
	#end

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

	/**
	 * Can be used to check if your using a specific version of an OS (or if your using a certain OS).
	 */
	public static function hasVersion(vers:String)
		return lime.system.System.platformLabel.toLowerCase().indexOf(vers.toLowerCase()) != -1;

	public static function difficultyString():String
		return difficulties[PlayState.storyDifficulty].toUpperCase();

	@:deprecated("boundTo is deprecated, use MathUtil.mathBound")
	inline public static function boundTo(value:Float, min:Float, max:Float):Float
		return Math.max(min, Math.min(max, value));

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		#if sys
		if (FileSystem.exists(path))
			daList = File.getContent(path).trim().split('\n');
		#else
		if (Assets.exists(path))
			daList = Assets.getText(path).trim().split('\n');
		#end

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

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

	public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);

				if (colorOfThisPixel != 0)
				{
					if (countByColor.exists(colorOfThisPixel))
					{
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					}
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
					{
						countByColor[colorOfThisPixel] = 1;
					}
				}
			}
		}
		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
		for (key in countByColor.keys())
		{
			if (countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
			dumbArray.push(i);
		return dumbArray;
	}

	// uhhhh does this even work at all? i'm starting to doubt
	public static function precacheSound(sound:String, ?library:String = null):Void
		Paths.sound(sound, library);

	public static function precacheMusic(sound:String, ?library:String = null):Void
		Paths.music(sound, library);

	public static function browserLoad(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}
}
