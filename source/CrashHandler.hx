package;

// an fully working crash handler on ALL platforms
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.CallStack;
import haxe.io.Path;
import openfl.Lib;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;

using StringTools;

/**
 * Crash Handler.
 * @author YoshiCrafter29, Ne_Eo. MAJigsaw77 and mcagabe19
 */
class CrashHandler
{
	public static var errorMessage:String = "";

	public static function init():Void
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		untyped __global__.__hxcpp_set_critical_error_handler(onError);
	}

	private static function onUncaughtError(e:UncaughtErrorEvent):Void
	{
		try
		{
			e.preventDefault();
			e.stopPropagation();
			e.stopImmediatePropagation();

			errorMessage = "";

			var m:String = e.error;
			if (Std.isOfType(e.error, Error))
			{
				var err = cast(e.error, Error);
				m = '${err.message}';
			}
			else if (Std.isOfType(e.error, ErrorEvent))
			{
				var err = cast(e.error, ErrorEvent);
				m = '${err.text}';
			}
			final stack = CallStack.exceptionStack();
			final stackLabelArr:Array<String> = [];
			var stackLabel:String = "";
			// legacy code below for the messages
			var path:String;
			var dateNow:String = Date.now().toString();
			dateNow = dateNow.replace(" ", "_");
			dateNow = dateNow.replace(":", "'");

			path = "crash/StarEngine_" + dateNow + ".log";

			for (stackItem in stack)
			{
				switch (stackItem)
				{
					case CFunction:
						stackLabelArr.push("Non-Haxe (C) Function");
					case Module(c):
						stackLabelArr.push('Module ${c}');
					case FilePos(parent, file, line, col):
						switch (parent)
						{
							case Method(cla, func): stackLabelArr.push('${file.replace('.hx', '')}.$func() [line $line]');
							case _: stackLabelArr.push('${file.replace('.hx', '')} [line $line]');
						}
					case LocalFunction(v):
						stackLabelArr.push('Local Function ${v}');
					case Method(cl, m):
						stackLabelArr.push('${cl} - ${m}');
				}
			}
			stackLabel = stackLabelArr.join('\r\n');

			errorMessage += 'Uncaught Error: $m\n\n$stackLabel';
			trace(errorMessage);

			try
			{
				if (!FileSystem.exists("crash/"))
					FileSystem.createDirectory("crash/");
				File.saveContent(path, '$errorMessage\n\nCrash happened on Star Engine v${MainMenuState.psychEngineVersion}!');
			}
			catch (e)
				trace('Couldn\'t save error message. (${e.message})');

			Sys.println(errorMessage);
			Sys.println("Crash dump saved in " + Path.normalize(path));
		}
		catch (e:Dynamic)
			trace(e);

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = false;

		if (ClientPrefs.peOGCrash)
		{
			errorMessage += "\n\nPlease report this error to the GitHub page: https://github.com/NebulaFNF/Star-Engine"
				+ "\nThe engine has saved a crash log inside the crash folder, If you're making a GitHub issue you might want to send that!";

			CoolUtil.showPopUp(errorMessage,
				"Error! Star Engine v"
				+ MainMenuState.psychEngineVersion
				+ " ("
				+ Main.__superCoolErrorMessagesArray[FlxG.random.int(0, Main.__superCoolErrorMessagesArray.length)]
				+ ")");

			lime.system.System.exit(1);
		}
		else
			FlxG.switchState(new Crash());
	}

	private static function onError(message:Dynamic):Void
		throw Std.string(message);
}

class Crash extends FlxState
{
	override public function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		var stripClub:Array<String> = CrashHandler.errorMessage.split("\n");
		var i:Int = -1;
		var ohNo:FlxText = new FlxText(0, 0, 1280,
			'Star Engine v${MainMenuState.psychEngineVersion} has crashed!\n\n'
			+ Main.__superCoolErrorMessagesArray[FlxG.random.int(0, Main.__superCoolErrorMessagesArray.length)]
			+ '\n\n'
			+ stripClub
			+ '\n\nCrash Handler by YoshiCrafter29, Ne_Eo. MAJigsaw77 and mcagabe19
		Crash UI State by Nael2xd and lunaruniv
		If you are reporting this bug, Go to crash/ folder and copy the contents from the recent file.
		Press any key to continue (Press ENTER to report this bug)');

		ohNo.setFormat(Paths.font('debug.ttf'), 20, FlxColor.WHITE, FlxTextAlign.LEFT);
		ohNo.antialiasing = false;
		ohNo.alpha = 1;
		ohNo.screenCenter();
		ohNo.y = 0;
		ohNo.x = 0;
		add(ohNo);

		var crash:Array<FlxText> = [];
		for (spr in crash)
			FlxTween.tween(spr, {alpha: 1}, 0.5);

		var error:FlxSound = FlxG.sound.load(Paths.sound('chord'));
		error.play();

		super.create();
	}

	// Do note that if you use "resetGame" star engine will be in a crash loop because music is missing.
	// Even with my coding skills and trying to make it work it just doesn't, i'm probably stupid.
	// Also yes i tried FlxG.sound.playMusic and yet it doesn't do what it's suppose to do.
	// -nael2xd
	var countDown:Int = 10;
	var clicked:Bool = false;

	override public function update(elapsed:Float)
		if (FlxG.keys.justPressed.ANY && !clicked)
		{
			FlxTransitionableState.skipNextTransIn = false;
			if (FlxG.keys.justPressed.ENTER)
			{
				clicked = true;
				for (sprite in members)
					if (sprite is FlxSprite || sprite is FlxText)
						FlxTween.tween(sprite, {alpha: 0.5}, 0.5);
				var coolBg:FlxSprite = new FlxSprite().makeGraphic(840, 260, 0xFF404040);
				coolBg.screenCenter();
				add(coolBg);
				var coolInfo:FlxSprite = new FlxSprite().makeGraphic(830, 250, 0xFF636363);
				coolInfo.screenCenter();
				add(coolInfo);
				var heyText:FlxText = new FlxText(0, 0, 820,
					"Before you report the crash, Please check if one of those crash exists. If it does exist yet you make the issue, it will be marked as duplicate!");
				heyText.setFormat(Paths.font('vcryey.ttf'), 34, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				heyText.screenCenter();
				heyText.y -= 50;
				add(heyText);
				var countText:FlxText = new FlxText(0, 0, 640, "" + countDown);
				countText.setFormat(Paths.font('vcryey.ttf'), 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				countText.screenCenter();
				countText.y += 73;
				add(countText);
				new FlxTimer().start(1, e ->
				{
					countDown--;
					countText.text = countDown + "";
					if (countDown == 0)
					{
						CoolUtil.browserLoad("https://github.com/NebulaFNF/Star-Engine/issues/new?template=bugs.yml");
						FlxG.switchState(new MainMenuState());
					}
				}, 10);
			}
			else if (!FlxG.keys.justPressed.F2)
				FlxG.switchState(new MainMenuState());
		}
}
