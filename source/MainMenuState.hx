package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;
import flixel.util.FlxAxes;
import flixel.addons.display.FlxGridOverlay;
import flxanimate.FlxAnimate;
import flxanimate.animate.FlxAnim;
import flixel.util.FlxTimer;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.3.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public var changeX:Bool = true;
	public var changeY:Bool = true;

	public var x:Float;
	public var targetY:Int = 0;
	public var y:Float;

	var tipTextMargin:Float = 10;
	var tipTextScrolling:Bool = false;
	var tipBackground:FlxSprite;
	var tipText:FlxText;
	var isTweening:Bool = false;
	var lastString:String = '';

	public var distancePerItem:FlxPoint = new FlxPoint(20, 120);
	public var startPosition:FlxPoint = new FlxPoint(0, 0); //for the calculations

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end // who needs this?
		'credits',
		//#if !switch 'donate', #end
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	public function snapToPosition()
	{
		if(changeX)
			x = (targetY * distancePerItem.x) + startPosition.x;
		if(changeY)
			y = (targetY * 1.3 * distancePerItem.y) + startPosition.y;
	}

	override function create()
	{
		//beatHit();
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("aboutMenu", "preload"));
		var freeplayBoyfriend:FlxAnimate = new FlxAnimate(90, 60, "assets/images/freeplay-boyfriend");
		var anim:FlxAnim;
		freeplayBoyfriend.anim.addBySymbol("boyfriend freeplay animations v5", "Boyfriend DJ", 90, 60, 24);
		freeplayBoyfriend.antialiasing = true;
		freeplayBoyfriend.screenCenter();
		freeplayBoyfriend.setGraphicSize(Std.int(freeplayBoyfriend.width * 1.5));
		freeplayBoyfriend.scrollFactor.set(0, 0);
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.color = 0xFFFF8C19;
		add(bg);
		freeplayBoyfriend.anim.play("Boyfriend DJ");

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		
		// universe engine code
		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 20);
		grid.alpha = 0;

		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);
		add(freeplayBoyfriend);

		var freeplayBoyfriend:FlxAnimate = new FlxAnimate(90, 60, "assets/images/freeplay-boyfriend");
		freeplayBoyfriend.anim.addBySymbol("boyfriend freeplay animations v5", "Boyfriend DJ", 90, 60, 24);
		freeplayBoyfriend.antialiasing = true;
		freeplayBoyfriend.screenCenter();
		freeplayBoyfriend.setGraphicSize(Std.int(freeplayBoyfriend.width * 1.5));
		freeplayBoyfriend.scrollFactor.set(0, 0);
		magenta = new FlxSprite(-80).loadGraphic(Paths.image('aboutMenu', 'preload'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		freeplayBoyfriend.anim.play("Boyfriend DJ");

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 20);
		grid.alpha = 0;
		add(grid);
		add(freeplayBoyfriend);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
	
		for (i in 0...optionShit.length)
		{
			var maxWidth = 980;
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.x = 100;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Star Engine : " + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		tipBackground = new FlxSprite();
		tipBackground.scrollFactor.set();
		tipBackground.alpha = 0.7;
		tipBackground.visible = true;
		add(tipBackground);

		tipText = new FlxText(0, 0, 0, "");
		tipText.scrollFactor.set();
		tipText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER);
		tipText.updateHitbox();
		tipText.visible = true;
		add(tipText);
		tipBackground.makeGraphic(FlxG.width, Std.int((tipTextMargin * 2) + tipText.height), FlxColor.BLACK);

		changeItem();
		tipTextStartScrolling();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	//credit to stefan2008 and sb engine for this code



	function tipTextStartScrolling()
	{
			tipText.x = tipTextMargin;
			tipText.y = -tipText.height;
			new FlxTimer().start(1.0, function(timer:FlxTimer)
			{
			FlxTween.tween(tipText, {y: tipTextMargin}, 0.3);
			new FlxTimer().start(2.25, function(timer:FlxTimer)
			{
				tipTextScrolling = true;
			});
		});
	}
	
	function changeTipText() {
			var selectedText:String = '';
			var textArray:Array<String> = CoolUtil.coolTextFile(SUtil.getPath() + Paths.txt('lmfaoTheseTips'));
			tipText.alpha = 1;
			isTweening = true;
			selectedText = textArray[FlxG.random.int(0, (textArray.length - 1))].replace('--', '\n');
			FlxTween.tween(tipText, {alpha: 0}, 1, {
				ease: FlxEase.linear,
				onComplete: function(freak:FlxTween) {
					if (selectedText != lastString) {
						tipText.text = selectedText;
						lastString = selectedText;
					} else {
						selectedText = textArray[FlxG.random.int(0, (textArray.length - 1))].replace('--', '\n');
						tipText.text = selectedText;
					}
					tipText.alpha = 0;
					FlxTween.tween(tipText, {alpha: 1}, 1, {
						ease: FlxEase.linear,
						onComplete: function(freak:FlxTween) {
						isTweening = false;
					}
				});
			}
		});
	}

	override function beatHit()
	{
		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		super.beatHit();
		grid.alpha == 1;
		FlxG.camera.zoom += 0.2;
		FlxTween.tween(FlxG.camera, {zoom: 1}, Conductor.crochet / 1200, {ease: FlxEase.expoOut});
	}

	override function update(elapsed:Float)
	{
		if (tipTextScrolling)
		{
			tipText.x -= elapsed * 130;
			if (tipText.x < -tipText.width)
			{
				tipTextScrolling = false;
				tipTextStartScrolling();
				changeTipText();
			}
		}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
