package luapps.state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Timer;
import lime.app.Application;
import lime.system.Clipboard;
import luapps.debug.FPSCounter;
import luapps.engine.LuaEngine;
import luapps.state.LuAppsState;
import luapps.utils.Prefs;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

class Dummy extends FlxState {
	public static var instance:Dummy;

	public var sprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var texts:Map<String, FlxText> = new Map<String, FlxText>();
	public var variables:Map<String, Dynamic> = new Map();
	public var tweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var timers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public static var luaArray:Array<LuaEngine> = [];
	public static var debugger:Array<FlxText> = [];

	public static var channels:Array<SoundChannel> = [];
	public static var positions:Array<Float> = [];
    public static var sounds:Array<Sound> = [];
	
	var oldTime:Float = 0;

	override public function create() {
		oldTime = Timer.stamp();
		instance = this;

		updateVars();
		callOnLuas("create");
		super.create();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		updateVars();

		for (text in debugger) add(text);
		callOnLuas("update", [elapsed]);

		if (FlxG.keys.justPressed.ESCAPE) openSubState(new Pause());

		if (FlxG.keys.justPressed.R && Prefs.restartByR) {
			sprites = [];
			texts = [];
			variables = [];
			tweens = [];
			luaArray = [];
			debugger = [];
			Pause.killSounds();

			luaArray.push(new LuaEngine(LuAppsState.modRaw + "source/main.lua"));
			FlxG.switchState(new Dummy());
		}

		for (channel in channels) {
            if (channel != null) {
                var transform:SoundTransform = channel.soundTransform;
                transform.volume = FlxG.sound.volume; // Apply new volume
                channel.soundTransform = transform;
            }
        }
	}

	public static function playSound(path:String) {
        var sound:Sound = Sound.fromFile(path);
        var channel:SoundChannel = sound.play();
        if (channel != null) {
            var transform:SoundTransform = channel.soundTransform;
            transform.volume = FlxG.sound.volume;
            channel.soundTransform = transform;
            
            channels.push(channel);
            positions.push(0); // Start at position 0
            sounds.push(sound);
        }
    }

	public static function exit(restartOnly:Bool = false) {
		try {
			Dummy.instance.sprites.clear();
			Dummy.instance.texts.clear();
			Dummy.instance.variables.clear();
			Dummy.instance.tweens.clear();
			Dummy.instance.timers.clear();
			Dummy.luaArray = [];
			debugger = [];
		} catch(e:Dynamic) {} // Failed to do those, prevent a crash.

		if (!restartOnly) FlxG.resetGame();
	}

	public static function debugPrint(text:String, warn:Bool = false) {
		var l:Int = debugger.length;
		text = (warn ? "[WARN] " : "") + text;

		if (l == 37) {
			debugger[0].destroy();
			debugger.remove(debugger[0]);

			var i:Int = 0;
			for (tex in debugger) {
				tex.y = 20 * i;
				i++;
			}

			l--;
		}

		if (text.length > 91) {
			Sys.println('${LuAppsState.modName}: $text');
			text = text.substr(0, 88);
			text += "...\n(Full Debug if the terminal is launched!)";
		}

		var curText:Array<String> = text.split("\n");
		for (text in curText) {
			debugger.push(new FlxText(0, 16 * l, 1280, text));
			debugger[l].setFormat('assets/fonts/debug.ttf', 14, warn ? FlxColor.YELLOW : FlxColor.WHITE);
			l = debugger.length;
		}
	}

	public function updateVars() {
		set('author',        LuAppsState.author);
		set('clipboardItem', Clipboard.text);
		set('fps',           FPSCounter.currentFPS);
		set('fullscreen',    FlxG.fullscreen);
		set('height',        Application.current.window.height);
		set('lowDetail',     Prefs.lowDetail);
		set('memory',        FPSCounter.curMemory);
		set('mempeak',       FPSCounter.curMaxMemory);
		set('modName',       LuAppsState.modName);
		set('modRaw',        LuAppsState.modRaw);
		set('mouseMoved',    FlxG.mouse.justMoved);
		set('mouseX',        FlxG.mouse.x);
		set('mouseY',        FlxG.mouse.y);
		set('time',          Timer.stamp() - oldTime);
		set('version',       Main.luversion);
		set('width',         Application.current.window.width);
	}

	public static function clearLog() {
		for (text in Dummy.debugger) text.destroy();
			
		Dummy.debugger = [];
	}

	public function callOnLuas(event:String, args:Array<Dynamic> = null, ignoreStops = true, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		var returnVal = LuaEngine.Function_Continue;
		if(args == null) args = [];
		if(exclusions == null) exclusions = [];
		if(excludeValues == null) excludeValues = [];

		for (script in luaArray) {
			if(exclusions.contains(script.scriptName)) continue;

			final myValue = script.call(event, args);
			if(myValue == LuaEngine.Function_StopLua && !ignoreStops) break;
			if(myValue != null && myValue != LuaEngine.Function_Continue) returnVal = myValue;
		}
		return returnVal;
	}

	public function set(variable:String, arg:Dynamic) for (i in 0...luaArray.length) luaArray[i].set(variable, arg);

	public function getLuaObject(tag:String, text:Bool=true):FlxSprite {
		if (sprites.exists(tag)) return sprites.get(tag);
		if (text && texts.exists(tag)) return texts.get(tag);
		if (variables.exists(tag)) return variables.get(tag);
		return null;
	}
}

class Pause extends FlxSubState {
	public function new() super(0x00000000);

	var isMouseHidden:Bool = FlxG.mouse.enabled;

	private var pauseText:FlxText = new FlxText(0, 0, 1280, "Pause.", 24);
	private var buttonSpr:Array<FlxSprite> = [];
	private var buttonTxt:Array<FlxText> = [];

	private var music:FlxSound = new FlxSound();
	private var blackBG:FlxSprite = new FlxSprite();

	var isGoing:Bool = true;

	override public function create() {
		blackBG.makeGraphic(1920, 1080, FlxColor.BLACK);
		blackBG.alpha = 0;
		FlxTween.tween(blackBG, {alpha: 0.6}, 0.5);
		add(blackBG);

		if (FlxG.sound.music != null) FlxG.sound.music.pause();

		FlxG.mouse.enabled = true;
		FlxG.mouse.visible = true;

		pauseText.setFormat('assets/fonts/main.ttf', 96, FlxColor.WHITE, FlxTextAlign.CENTER);
		pauseText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 4, 4);
		pauseText.screenCenter();
		pauseText.y = 26;
		pauseText.alpha = 0;
		FlxTween.tween(pauseText, {alpha: 1}, 0.5, {onComplete: e -> {
			isGoing = false;
		}});
		add(pauseText);

		var stuffies:Array<String> = ["Exit App", "Continue"];
		for (stuff in stuffies) {
			var i:Int = buttonSpr.length;
			buttonSpr.push(new FlxSprite().makeGraphic(260, 80, FlxColor.RED));
			buttonSpr[i].screenCenter();
			buttonSpr[i].x += (-(stuffies.length*200) + (i * 400)) + 200;
			buttonSpr[i].y = 550;
			buttonSpr[i].alpha = 0;
			FlxTween.tween(buttonSpr[i], {alpha: 1}, 0.5);
			add(buttonSpr[i]);

			buttonTxt.push(new FlxText(0, 0, 1280, stuff, 48));
			buttonTxt[i].setFormat('assets/fonts/main.ttf', 48, FlxColor.WHITE, FlxTextAlign.CENTER);
			buttonTxt[i].screenCenter();
			buttonTxt[i].x += (-(stuffies.length*200) + (i * 400)) + 200;
			buttonTxt[i].y = 555;
			buttonTxt[i].alpha = 0;
			FlxTween.tween(buttonTxt[i], {alpha: 1}, 0.5);
			add(buttonTxt[i]);
		}

		var modN:FlxText = new FlxText(0, 0, 1280, LuAppsState.modName, 36);
		modN.setFormat('assets/fonts/main.ttf', 36);
		modN.alignment = FlxTextAlign.RIGHT;
		modN.bold = true;
		modN.alpha = 0;
		modN.x = -15;
		modN.y = -20;
		new FlxTimer().start(0.35, e -> {
			FlxTween.tween(modN, {y: 10, alpha: 1}, 0.25);
		});
		add(modN);

		var modA:FlxText = new FlxText(0, 0, 1280, LuAppsState.author, 36);
		modA.setFormat('assets/fonts/main.ttf', 36);
		modA.alignment = FlxTextAlign.RIGHT;
		modA.bold = true;
		modA.alpha = 0;
		modA.x = -15;
		modA.y = 20;
		new FlxTimer().start(0.55, e -> {
			FlxTween.tween(modA, {y: 50, alpha: 1}, 0.25);
		});
		add(modA);

		music.loadEmbedded('assets/music/settings.ogg');
		music.fadeIn(8);
		music.looped = true;
		music.play();

		killSounds();

		super.create();
	}

	override public function update(elapsed:Float) {
		var i:Int = 0;
		if (!isGoing) {
			for (sprite in buttonSpr) {
				if (FlxG.mouse.overlaps(sprite) && FlxG.mouse.justPressed) {
					isGoing = true;
					music.fadeOut(0.5);
	
					switch(buttonTxt[i].text) {
						case "Continue":
							music.stop();
							FlxG.mouse.enabled = isMouseHidden;
							FlxG.mouse.visible = isMouseHidden;

							for (sprite in members)
								FlxTween.tween(sprite, {alpha: 0}, 0.5, {onComplete: e -> {
									for (i in 0...Dummy.sounds.length) {
										if (Dummy.sounds[i] != null) {
											if (Dummy.channels[i] != null) Dummy.channels[i].stop();
											var channel:SoundChannel = Dummy.sounds[i].play(Dummy.positions[i]); // Resume from saved position
											if (channel != null) {
												var transform:SoundTransform = channel.soundTransform;
												transform.volume = FlxG.sound.volume;
												channel.soundTransform = transform;
												
												Dummy.channels[i] = channel;
											}
										}
									}

									close();
								}});
	
						case "Exit App":
							for (sprite in members) FlxTween.tween(sprite, {alpha: 0}, 0.5);

							FlxTween.tween(blackBG, {alpha: 1}, 0.5, {onComplete: e -> {
								Dummy.exit();
							}});
					}
				}
	
				i++;
			}
		}
	}

	public static function killSounds() {
		for (i in 0...Dummy.channels.length) {
            if (Dummy.channels[i] != null) {
                Dummy.positions[i] = Dummy.channels[i].position; // Save position
                Dummy.channels[i].stop(); // Stop the sound
                Dummy.channels[i] = null;
				Dummy.sounds[i] = null;
            }
        }
	}
}