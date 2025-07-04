package openfl.display;

import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
import funkin.api.mem.GetTotalMemory;
import funkin.backend.memory.Memory;
import funkin.prefs.ClientPrefs;
import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end
#if openfl
import openfl.system.System;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	public var memoryUsage:String = '';
	public var memoryShit:Float;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("Px437 IBM VGA 8x16", 16, color);
		autoSize = LEFT;
		multiline = true;
		if (!ClientPrefs.fpsCounterThingie)
			text = "FPS: ";
		else
			text = "";
		if (ClientPrefs.ffmpegMode)
			text += " | Rendering Mode";
		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		if (currentFPS > ClientPrefs.framerate)
			currentFPS = ClientPrefs.framerate;

		// if (Memory.getMemory() > memPeak) memPeak = GetTotalMemory.getPeakRSS();

		if (currentCount != cacheCount /*&& visible*/)
		{
			memoryShit = System.totalMemory;

			if (!ClientPrefs.fpsCounterThingie)
				text = "FPS: " + currentFPS;
			else
				text = "" + currentFPS + ' | ' + Memory.getMemory() + " / " + FlxStringUtil.formatBytes(GetTotalMemory.getCurrentRSS());
			var memoryMegas:Float = 0;

			#if openfl
			memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));

			if (!ClientPrefs.fpsCounterThingie)
				text += "\nMEM: "
					+ FlxStringUtil.formatBytes(GetTotalMemory.getCurrentRSS())
					+ " / "
					+ FlxStringUtil.formatBytes(GetTotalMemory.getPeakRSS());
			else
				text += "";
			#end

			textColor = 0xFFFFFFFF;

			if (memoryMegas > 3072 || currentFPS <= ClientPrefs.framerate / 2)
			{
				textColor = 0xFFFF0000;
			}

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end

			text += "\n";
		}

		cacheCount = currentCount;
	}
}
