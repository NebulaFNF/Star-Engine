package;

import AnsiTrace;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.FPSBg;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;

using StringTools;

// credits to hrk ex ex !!!!
#if desktop
import backend.ALSoftConfig; // Just to make sure DCE doesn't remove this, since it's not directly referenced anywhere else.
#end
// crash handler stuff
#if CRASH_HANDLER
import haxe.CallStack;
import lime.app.Application;
#end

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = StartupState; // default state it starts up in
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	var curVersion:String = "";

	public static var fpsVar:FPS;
	public static var fpsBg:FPSBg;

	public static var luversion:String = '0.0.1';

	public static final __superCoolErrorMessagesArray:Array<String> = [
		"A fatal error has occ- wait what?",
		"missigno.",
		"oopsie daisies!! you did a fucky wucky!!",
		"i think you fogot a semicolon",
		"null balls reference",
		"get friday night funkd'",
		"engine skipped a heartbeat",
		"Impossible...",
		"Patience is key for success... Don't give up.",
		"It's no longer in its early stages... is it?",
		"It took me half a day to code that in",
		"You should make an issue... NOW!!",
		"> Crash Handler written by: yoshicrafter29",
		"broken ch-... wait what are we talking about",
		"could not access variable you.dad",
		"What have you done...",
		"THERE ARENT COUGARS IN SCRIPTING!!! I HEARD IT!!",
		"no, thats not from system.windows.forms",
		"you better link a screenshot if you make an issue, or at least the crash.txt",
		"stack trace more like dunno i dont have any jokes",
		"oh the misery. everybody wants to be my enemy",
		"have you heard of soulles dx",
		"i thought it was invincible",
		"did you deleted coconut.png",
		"have you heard of missing json's cousin null function reference",
		"sad that linux users wont see this banger of a crash handler",
		"woopsie",
		"oopsie",
		"woops",
		"silly me",
		"my bad",
		"first time, huh?",
		"did somebody say yoga",
		"we forget a thousand things everyday... make sure this is one of them.",
		"SAY GOODBYE TO YOUR KNEECAPS, CHUCKLEHEAD",
		"motherfucking ordinal 344 (TaskDialog) forcing me to create a even fancier window",
		"Died due to missing a sawblade. (Press Space to dodge!)",
		"yes rico, kaboom.",
		"hey, while in freeplay, press shift while pressing space",
		"goofy ahh engine",
		"pssst, try typing debug7 in the options menu",
		"this crash handler is sponsored by rai-",
		"",
		"did you know a jiffy is an actual measurement of time",
		"how many hurt notes did you put",
		"FPS: 0",
		"\r\ni am a secret message",
		"this is garnet",
		"Error: Sorry i already have a girlfriend",
		"did you know theres a total of 51 silly messages",
		"whoopsies looks like i forgot to fix this",
		"Game used Crash. It's super effective!",
		"What in the fucking shit fuck dick!",
		"The engine got constipated. Sad.",
		"shit.",
		"NULL",
		"Five big booms. BOOM, BOOM, BOOM, BOOM, BOOM!!!!!!!!!!",
		"uhhhhhhhhhhhhhhhh... i dont think this is normal...",
		"lobotomy moment",
		"ARK: Survival Evolved"
	];

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		#if debug
		haxe.Log.trace = AnsiTrace.trace;
		AnsiTrace.traceBF();
		#end

		CrashHandler.init();

		#if DEBUG_TRACY
		CoolUtil.initTracy();
		#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	public static function changeWindowName(name:String = "")
	{
		// kinda dumb but whatev
		Application.current.window.title = "Friday Night Funkin'" + ": " + "Star Engine - LuApps v" + luversion + '${name != "" ? '- $name' : ''}';
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		#if hxcpp_debug_server
		trace('hxcpp_debug_server is enabled! You can now connect to the game with a debugger.');
		#else
		trace('hxcpp_debug_server is disabled! This build does not support debugging.');
		#end

		#if windows
		WindowColorMode.setDarkMode();
		if (CoolUtil.hasVersion("Windows 10"))
			WindowColorMode.redrawWindowHeader();
		#end

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		ClientPrefs.loadDefaultKeys();
		inline cpp.vm.Gc.enable(!ClientPrefs.disableGC);
		addChild(new FlxGame(gameWidth, gameHeight, initialState, #if (flixel < "5.0.0") zoom, #end framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		fpsBg = new FPSBg();
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsBg);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if (fpsVar != null)
		{
			fpsVar.visible = ClientPrefs.showFPS;
			fpsBg.visible = ClientPrefs.showFPS;
		}
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}
}
