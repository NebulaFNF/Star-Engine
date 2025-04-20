package luapps.debug;

import flixel.FlxG;
import flixel.util.FlxStringUtil;
import openfl.text.TextField;
import openfl.text.TextFormat;

class FPSCounter extends TextField
{
	public static var currentFPS(default, null):Float;
	public static var curMemory(default, null):String;
	public static var curMaxMemory(default, null):String;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memory(get, never):Float;
	inline function get_memory():Float
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);

	var mempeak:Float = 0;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x00000000) {
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		curMemory = "";
		curMaxMemory = "";
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("nintendo_NTLG-DB_001", 12, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var timeColor:Float = 0.0;

	var deltaTimeout:Float = 0.0;
	public var timeoutDelay:Float = 50;
	var now:Float = 0;
	// Event Handlers
	override function __enterFrame(deltaTime:Float):Void {
		now = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();
		if (deltaTimeout <= timeoutDelay) {
			deltaTimeout += deltaTime;
			return;
		}

		if (memory > mempeak) mempeak = memory;

		currentFPS = Math.round(Math.min(FlxG.drawFramerate, times.length));
		curMemory = FlxStringUtil.formatBytes(memory);
		curMaxMemory = FlxStringUtil.formatBytes(mempeak);
		text = '$currentFPS | $curMemory / $curMaxMemory';

		deltaTimeout = 0.0;
	}
}
