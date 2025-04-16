package luapps.state;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import haxe.Timer;
import luapps.engine.LuaEngine;
import luapps.state.DummyState;
import luapps.utils.Prefs;
import luapps.utils.Shaders;
import luapps.utils.Utils;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.media.Sound;
import sys.FileSystem;
import sys.io.File;

using StringTools;

var luaLists:Array<Array<String>> = [];

class LuAppsState extends FlxState {
	public static var author:String;
	public static var modName:String;
	public static var modRaw:String;

	var spriteIDList:Array<Array<FlxSprite>> = [];
	var spriteYPos:Array<Float> = [];
	var textIDList:Array<Array<FlxText>> = [];
	var textYPos:Array<Float> = [];

	var optionsBG:FlxSprite = new FlxSprite();
	var optionsText:FlxText = new FlxText(1095, 642, 1920, "Options", 16);
	var options:FlxSprite = new FlxSprite();
	var mouseDistance:FlxSprite = new FlxSprite();
	var noApps:FlxText = new FlxText(0, 0, 1280, "There is no applications installed! Press R to refresh the list.", 32);
	var background:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
	var GMB:GlowingMarblingBlack = new GlowingMarblingBlack();
	var camNotifs:FlxCamera = new FlxCamera(); // i'm so pissed
	var curNotifSpr:Array<Array<FlxSprite>> = [];
	var curNotifTxt:Array<Array<FlxText>>   = [];

	var allowTween:Bool = false;
	var yPos:Float = -5;
	var maxYPos:Float = 0;
	var oldYPos:Float = 0;
	var mouseYPos:Float = 0;
	var mouseScroll:Float = 0;
	var wheelSpeed:Float = 0;
	var oldTime:Float = 0;
	var tickLeft:Int = 5;
	var choice:Int = 0;
	var disableMoving:Bool = false;
	var hasNoApps:Bool = false;
	var notifsSent:Int = 0;
	var notifsGone:Int = 0;
	
	override public function create() {
		Main.changeWindowName("Applications");

		if (modRaw != "") {
			modRaw = "";
			if (FlxG.sound.music != null) FlxG.sound.music.stop();
			FlxG.resetState();
		}

		FlxG.autoPause = false;
		if (!FlxG.fullscreen) Utils.setDefaultResolution();
		FlxG.sound.muted = false;
		FlxG.mouse.enabled = true;
		FlxG.mouse.visible = true;
		FlxG.sound.playMusic("assets/music/menu.ogg", 1, true);
		FlxG.cameras.add(camNotifs);
		add(camNotifs);

		oldTime = Timer.stamp();

		if (!FileSystem.exists("mods/")) FileSystem.createDirectory("mods/");

		var gray:FlxSprite = new FlxSprite().makeGraphic(1920, 1080, Std.parseInt('0xFF222222'));
		if (Prefs.shaders) gray.shader = GMB;
		add(gray);

		// From JS Engine.
		if (Prefs.allowParticles) {
			background.color = 0xff467172;
			background.blend = BlendMode.LAYER;
			background.scrollFactor.set(0, 0.07);
			background.alpha = 0.33;
			background.updateHitbox();
			add(background);
		}

		noApps.setFormat("assets/fonts/main.ttf", 36, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		noApps.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 4);
		noApps.screenCenter();
		FlxTween.tween(noApps, {alpha: 0}, 1.5, {type: PINGPONG});
		noApps.visible = false;
		add(noApps);

		for (i in 0...50) {
			var spr:FlxSprite = new FlxSprite().makeGraphic(1280, 320, FlxColor.BLACK);
			spr.alpha = 0.0175;
			spr.y = 460 + (5.2 * i);
			add(spr);
		}

		optionsBG.makeGraphic(165, 60, Std.parseInt('0xFFA78080'));
		optionsBG.x = 1080;
		optionsBG.y = 635;
		add(optionsBG);

		options.makeGraphic(155, 50, Std.parseInt('0xFF534040'));
		options.x = 1085;
		options.y = 640;
		add(options);

		optionsText.setFormat("assets/fonts/main.ttf", 32, FlxColor.WHITE);
		optionsText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 8, 8);
		add(optionsText);

		generate();

		var version:FlxText = new FlxText(20, 680, 1920, 'You are running v${Main.luversion}');
		version.setFormat("assets/fonts/vcryey.ttf", 20, Std.parseInt('0xFF4D4242'));
		version.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 8, 8);
		version.bold = true;
		//version.underline = true;
		new FlxTimer().start(5, function(e) {
			FlxTween.tween(version, {y: 720, alpha: 0, "scale.y": 0.6}, 2, {ease: FlxEase.circIn, onComplete: function(e) {
				version.destroy();
			}});
		});
		add(version);

		sendNotification("This is a alpha state, changes won't be this but something else.");
		
		var funny:FlxSprite = new FlxSprite().makeGraphic(1920, 1080, FlxColor.BLACK);
		FlxTween.tween(funny, {alpha: 0}, 0.5, {onComplete: function(e) {
			funny.destroy();
		}});
		add(funny);

		super.create();
	}

	function generate() {
		for (table in spriteIDList) for (sprite in table) sprite.destroy();
		for (table in textIDList) for (text in table) text.destroy();

		function dumb(Value:Float):Void yPos = Value;

		disableMoving = true;
		FlxTween.num(yPos, 0, 0.6, {ease: FlxEase.backOut, onComplete: function(e) {
			disableMoving = false;
		}}, dumb);

		textIDList = [];
		textYPos = [];
		spriteIDList = [];
		spriteYPos = [];
		luaLists = [];

		var checks:Array<String> = FileSystem.readDirectory('mods/');
		var done:Int = 0;
		for (folder in checks) {
			var fileName:String = "mods/" + folder + "/";
			if (FileSystem.exists('${fileName}source/main.lua')) {
				var name:String = folder;
				var cred:String = "Unknown";
				var type:String = "ALL";
				var ver:String = "";
				var pngExist:Bool = FileSystem.exists('${fileName}pack.png');

				if (FileSystem.exists('${fileName}pack.json')) {
					try {
						var extract = Json.parse(File.getContent('${fileName}pack.json'));

						name = extract.name;
						cred = extract.author;
						type = extract.appType;
						ver  = extract.version;
					} catch(e) trace('JSON for $folder is not formatted correctly.\nError: $e');
				}

				if (ver == null) ver = "Unknown";
				luaLists.push([name, '${fileName}source/main.lua', folder, cred, type, ver]);
				if ((!Prefs.luAppsType.startsWith(type) && Prefs.luAppsType != "ALL") && File.getContent('${fileName}source/main.lua').length != 0) continue;

				spriteIDList.push([]);
				var l:Int = spriteIDList.length-1;
				var sprID:Int = 0;
				for (i in 0...(Prefs.lowDetail ? 1 : 2)) {
					spriteIDList[l].push(new FlxSprite().makeGraphic(816 + (14 * i), 126 + (14 * i), (i == 0 ? Std.parseInt('0xFF454545') : Std.parseInt('0xFF777777'))));
					spriteIDList[l][i].screenCenter();
					spriteIDList[l][i].alpha = 0.25;
					spriteIDList[l][i].y = 70 + (160 * done) - (i == 1 ? 7 : 0);
					add(spriteIDList[l][i]);
					sprID++;
				}

				textIDList.push([]);
				textIDList[done].push(new FlxText(-245, 75 + (160 * done), 1280, name));
				textIDList[done][0].setFormat("assets/fonts/main.ttf", 40, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
				add(textIDList[done][0]);

				textIDList[done].push(new FlxText(-245, 116 + (160 * done), 1280, cred));
				textIDList[done][1].setFormat("assets/fonts/main.ttf", 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
				add(textIDList[done][1]);

				textIDList[done].push(new FlxText(-245, 155 + (160 * done), 1280, '$ver - ${FlxStringUtil.formatBytes(Utils.getDirectorySize(fileName))}'));
				textIDList[done][2].setFormat("assets/fonts/main.ttf", 22, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
				//textIDList[done][2].underline = true;
				add(textIDList[done][2]);

				var image:BitmapData = null;
				if (pngExist) image = BitmapData.fromFile('${fileName}pack.png');

				spriteIDList[l].push(new FlxSprite().loadGraphic(pngExist ? image : "assets/images/unknown.png"));
				spriteIDList[l][sprID].scale.x = 0.75;
				spriteIDList[l][sprID].scale.y = 0.75;
				spriteIDList[l][sprID].x = 230;
				spriteIDList[l][sprID].y = 58 + (160 * done);
				add(spriteIDList[l][sprID]);

				done++;
			}
		}

		maxYPos = 0;
		if (done >= 4) maxYPos = -160 * (done - 4);

		hasNoApps = done == 0;
		noApps.visible = done == 0;

		for (table in spriteIDList) for (sprite in table) spriteYPos.push(sprite.y);
		for (table in textIDList) for (text in table) textYPos.push(text.y);

		sendNotification('Fetched $done app(s).');
		/*var text:FlxText = new FlxText(20, 20, 1920, 'Fetched $done app(s).', 16);
		text.setFormat("assets/fonts/main.ttf", 20, FlxColor.GREEN);
		text.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 8, 8);
		text.alpha = 0;
		FlxTween.tween(text, {alpha: 1, y: 20}, 1, {ease: FlxEase.circOut});
		new FlxTimer().start(3, function(e) {
			FlxTween.tween(text, {alpha: 0, y: 0}, 1, {ease: FlxEase.backOut, onComplete: function(e) {
				text.destroy();
			}});
		});
		add(text);*/

		choice = 0;
	}

	override public function update(elapsed:Float) {
		if (Prefs.shaders) GMB.update(elapsed);

		if (Math.abs(wheelSpeed) > .0001) wheelSpeed = wheelSpeed/(1 + (0.2 / (Prefs.framerate / 60)));

		for (sprite in members) {
			var sprite:Dynamic = sprite;
			var sprite:FlxSprite = sprite;
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) sprite.antialiasing = Prefs.antiAliasing;
		}

		if (!disableMoving && maxYPos != 0) {
			if (FlxG.mouse.justPressed || FlxG.mouse.wheel != 0) {
				mouseYPos = FlxG.mouse.y;
				oldYPos = yPos;
			}

			if (FlxG.mouse.pressed || FlxG.mouse.wheel != 0) {
				var y:Int = FlxG.mouse.y;
				wheelSpeed += FlxG.mouse.wheel * 10;
				yPos = oldYPos + (y - mouseYPos);
				if (tickLeft == 0) {
					tickLeft = 5;
					mouseScroll = (mouseDistance.y - y)/4;
					mouseDistance.y = y;
				}
				tickLeft--;
			} else if (mouseScroll != 0) {
				yPos -= mouseScroll;
				mouseScroll += mouseScroll > 0 ? -0.25 : 0.25;
			}
			yPos += wheelSpeed;

			if (yPos < maxYPos) {
				yPos = maxYPos;
				mouseScroll = 0;
			} else if (yPos > -5) {
				yPos = -5;
				mouseScroll = 0;
			}
		}

		if (!hasNoApps) {
			if (!disableMoving) {
				choice = -1;
				var heldID:Int = 0;
				for (sprite in spriteIDList) {
					if (FlxG.mouse.overlaps(sprite[0])) {
						choice = heldID;
						break;
					}
					heldID++;
				}
			}

			var id:Int = 0;
			for (table in spriteIDList) {
				for (sprite in table) {
					sprite.y = spriteYPos[id] + yPos;
					id++;
				}
			}

			id = 0;
			for (table in textIDList) {
				for (text in table) {
					text.y = textYPos[id] + yPos;
					id++;
				}
			}

			var numChosen:Int = -1;
			for (tab in textIDList) {
				numChosen++;
				for (i in 0...3) tab[i].color = numChosen == choice ? FlxColor.YELLOW : FlxColor.WHITE;
			}

			if (FlxG.mouse.justReleased && choice != -1 && !disableMoving) {
				disableMoving = true;
				var sprite:FlxSprite = new FlxSprite().makeGraphic(1920, 1080, FlxColor.BLACK);
				sprite.alpha = 0;
				FlxG.sound.music.fadeOut(0.5, 0);
				FlxTween.tween(sprite, {alpha: 1}, 1, {onComplete: function(e) {
					modName = luaLists[choice][2];
					modRaw = 'mods/${luaLists[choice][2]}/';
					author = luaLists[choice][3];
					Dummy.luaArray.push(new LuaEngine(luaLists[choice][1]));
					Main.changeWindowName('$modName - $author');
					FlxG.sound.destroy(true);
					FlxG.switchState(new Dummy());
				}});
				add(sprite);

				var choose:Sound = Sound.fromFile('assets/sounds/choose.ogg');
				choose.play();
			}
		}

		if (FlxG.mouse.overlaps(options)) {
			if (allowTween) {
				FlxTween.tween(optionsText, {alpha: 1}, 0.3);
				FlxTween.tween(optionsBG,   {alpha: 1}, 0.3);
				FlxTween.tween(options,     {alpha: 1}, 0.3);
				allowTween = false;
			}

			if (FlxG.mouse.justPressed) {
				var movement:FlxSprite = new FlxSprite().makeGraphic(1920, 1080, FlxColor.BLACK);
				movement.alpha = 0;
				FlxG.sound.music.fadeOut(0.5, 0);
				FlxTween.tween(movement, {alpha: 1}, 0.5, {onComplete: function(e) {
					FlxG.switchState(new LuaOptionsState());
				}});
				add(movement);

				var choose:Sound = Sound.fromFile('assets/sounds/choose.ogg');
				choose.play();
			}
		} else if (!allowTween) {
			FlxTween.tween(optionsText, {alpha: 0.5}, 0.3);
			FlxTween.tween(optionsBG,   {alpha: 0.5}, 0.3);
			FlxTween.tween(options,     {alpha: 0.5}, 0.3);
			allowTween = true;
		}

		if (FlxG.mouse.justMoved) oldTime = Timer.stamp();

		if (FlxG.keys.justPressed.R) generate();

		background.x += 0.45 / (Prefs.framerate / 60);
		background.y += (0.45 / (Prefs.framerate / 60)) - ((mouseScroll + -wheelSpeed)/2);

		super.update(elapsed);
	}

	function sendNotification(title:String) {
		if (!Prefs.notification) return;

		var l:Int = curNotifTxt.length;
		curNotifSpr.push([new FlxSprite(1276, 636 - (88 * notifsSent)).makeGraphic(303, 76, 0xff7e7e7e)]);
		curNotifSpr[l][0].alpha = 0;
		curNotifSpr[l][0].camera = camNotifs;
		FlxTween.tween(curNotifSpr[l][0], {alpha: 1, x: 956}, 2, {ease: FlxEase.elasticOut});
		add(curNotifSpr[l][0]);

		if (!Prefs.lowDetail) {
			curNotifSpr[l].push(new FlxSprite(1280, 640 - (88 * notifsSent)).makeGraphic(295, 68, 0xff585858));
			curNotifSpr[l][1].alpha = 0;
			curNotifSpr[l][1].camera = camNotifs;
			FlxTween.tween(curNotifSpr[l][1], {alpha: 1, x: 960}, 2, {ease: FlxEase.elasticOut});
			add(curNotifSpr[l][1]);
	
			/*curNotifSpr[l].push(new FlxSprite(1276, 708 - (88 * notifsSent)).makeGraphic(303, 4, 0xff000000));
			curNotifSpr[l][2].alpha = 0;
			curNotifSpr[l][2].camera = camNotifs;
			FlxTween.tween(curNotifSpr[l][2], {alpha: 1, x: 956}, 2, {ease: FlxEase.elasticOut});
			add(curNotifSpr[l][2]);*/
			// no idea how i'm suppose to do this
		}

		curNotifTxt.push([new FlxText(1290, 648 - (88 * notifsSent), 275, title)]);
		curNotifTxt[l][0].setFormat('assets/fonts/main.ttf', 16, FlxColor.WHITE);
		curNotifTxt[l][0].setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 8, 8);
		curNotifTxt[l][0].alpha = 0;
		curNotifTxt[l][0].camera = camNotifs;
		FlxTween.tween(curNotifTxt[l][0], {alpha: 1, x: 970}, 2, {ease: FlxEase.elasticOut});
		add(curNotifTxt[l][0]);

		new FlxTimer().start(5, {e -> {
			for (i in 0...curNotifSpr[l].length) FlxTween.tween(curNotifSpr[l][i], {alpha: 0}, 0.5, {onComplete: e -> curNotifSpr[l][i].destroy()});
			FlxTween.tween(curNotifTxt[l][0], {alpha: 0}, 0.5, {onComplete: e -> {
				curNotifTxt[l][0].destroy();
				notifsGone++;
				notifsSent--;

				var nums:Array<Int> = [636, 640, 648];
				for (i in 0...curNotifSpr.length) {
					for (j in 0...curNotifSpr[i].length) FlxTween.tween(curNotifSpr[i][j], {y: nums[j] - (88 * (i - notifsGone))}, .66, {ease: FlxEase.backOut});
					FlxTween.tween(curNotifTxt[i][0], {y: nums[2] - (88 * (i - notifsGone))}, .66, {ease: FlxEase.backOut});
				}
			}});
		}});

		notifsSent++;
	}
}