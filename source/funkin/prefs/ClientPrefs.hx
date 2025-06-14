package funkin.prefs;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;
import funkin.achievements.Achievements;
import funkin.misc.PlayerSettings;
import funkin.play.controls.Controls;
import funkin.ui.menu.TitleState;

/**
 * Handles settings.
 */
class ClientPrefs
{
	public static var vSliceNoteDelay:Bool = true;
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var opponentStrums:Bool = true;
	public static var showFPS:Bool = true;
	public static var funnyScoreTextImVeryFunny:String = 'V-Slice';
	public static var iconBounceBS:String = 'V-Slice';
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var shaders:Bool = true;
	public static var framerate:Int = 60;
	public static var seWatermarkLmfao:Bool = true;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var deactivateComboLimit:Bool = true;
	public static var noHitFuncs:Bool = true;
	public static var noSpawnFunc:Bool = true;
	public static var camZooms:Bool = true;
	public static var missSoundShit:Bool = false;
	public static var hideHud:Bool = false;
	public static var botplayScoreTxt:Bool = true;
	public static var noBotLag:Bool = true;
	public static var disableGC:Bool = true;
	public static var smoothHealth:Bool = true;
	public static var smoothHPBug:Bool = true;
	public static var laneUnderlay:Bool = false;
	public static var laneUnderlayAlpha:Float = 1;
	public static var noteComboBullshit:Bool = false;
	public static var fpsCounterThingie:Bool = false;
	public static var returnMemoryToFlxStringUtil:Bool = false;
	public static var workInProgressThingHaha:String = "!";
	public static var strumsAreFuckingOffset:Bool = true;
	public static var peOGCrash:Bool = false;

	// V-Slice compatitbility
	public static var FLASHBANG(get, never):Bool;

	public static function get_FLASHBANG():Bool
	{
		return flashing;
	}

	public static var ANTIALIASING(get, never):Bool;

	public static function get_ANTIALIASING():Bool
	{
		return globalAntialiasing;
	}

	public static var LOW_QUALITY(get, never):Bool;

	public static function get_LOW_QUALITY():Bool
	{
		return lowQuality;
	}

	public static var CAM_ZOOMING(get, never):Bool;

	public static function get_CAM_ZOOMING():Bool
	{
		return camZooms;
	}

	public static var SHADERS(get, never):Bool;

	public static function get_SHADERS():Bool
	{
		return shaders;
	}

	// Video Renderer
	public static var ffmpegMode:Bool = false;
	public static var ffmpegInfo:Bool = false;
	public static var targetFPS:Float = 60;
	public static var unlockFPS:Bool = false;
	public static var lossless:Bool = false;
	public static var quality:Int = 80;
	public static var noCapture:Bool = false;

	public static var botLightStrum:Bool = false;
	public static var oppoLightStrum:Bool = false;
	public static var playerLightStrum:Bool = true;
	public static var healthBarStyle:String = 'Legacy';
	public static var botplayWatermark:Bool = true;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var ghostTapping:Bool = true;
	public static var shakingScreen:Bool = true;
	public static var timeBarType:String = 'Disabled';
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var healthBarAlpha:Float = 1;
	public static var controllerMode:Bool = false;
	public static var hitsoundVolume:Float = 0;
	public static var pauseMusic:String = 'Tea Time';
	public static var checkForUpdates:Bool = true;
	public static var comboStacking = true;
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative',
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var ratingOffset:Int = 0;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	// Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		// Key Bind, Name for ControlsSubState
		'note_left' => [A, LEFT],
		'note_down' => [S, DOWN],
		'note_up' => [W, UP],
		'note_right' => [D, RIGHT],
		'ui_left' => [A, LEFT],
		'ui_down' => [S, DOWN],
		'ui_up' => [W, UP],
		'ui_right' => [D, RIGHT],
		'accept' => [SPACE, ENTER],
		'back' => [BACKSPACE, ESCAPE],
		'pause' => [ENTER, ESCAPE],
		'reset' => [R, NONE],
		'volume_mute' => [ZERO, NONE],
		'volume_up' => [NUMPADPLUS, PLUS],
		'volume_down' => [NUMPADMINUS, MINUS],
		'debug_1' => [SEVEN, NONE],
		'debug_2' => [EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys()
	{
		defaultKeys = keyBinds.copy();
		// trace(defaultKeys);
	}

	public static function saveSettings()
	{
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.opponentStrums = opponentStrums;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.shaders = shaders;
		FlxG.save.data.funnyScoreTextImVeryFunny = funnyScoreTextImVeryFunny;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.noHitFuncs = noHitFuncs;
		FlxG.save.data.noSpawnFunc = noSpawnFunc;
		FlxG.save.data.healthBarStyle = healthBarStyle;
		FlxG.save.data.iconBounceBS = iconBounceBS;
		FlxG.save.data.laneUnderlay = laneUnderlay;
		FlxG.save.data.laneUnderlayAlpha = laneUnderlayAlpha;
		FlxG.save.data.missSoundShit = missSoundShit;
		FlxG.save.data.seWatermarkLmfao = seWatermarkLmfao;
		FlxG.save.data.playerLightStrum = playerLightStrum;
		FlxG.save.data.oppoLightStrum = oppoLightStrum;
		FlxG.save.data.botLightStrum = botLightStrum;
		FlxG.save.data.noBotlag = noBotLag;
		FlxG.save.data.smoothHealth = smoothHealth;
		FlxG.save.data.strumsAreFuckingOffset = strumsAreFuckingOffset;
		// RENDERING SETTINGS
		FlxG.save.data.ffmpegMode = ffmpegMode;
		FlxG.save.data.ffmpegInfo = ffmpegInfo;
		FlxG.save.data.targetFPS = targetFPS;
		FlxG.save.data.unlockFPS = unlockFPS;
		FlxG.save.data.lossless = lossless;
		FlxG.save.data.quality = quality;
		FlxG.save.data.noCapture = noCapture;
		// FlxG.save.data.cursing = cursing;
		// FlxG.save.data.violence = violence;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.deactivateComboLimit = deactivateComboLimit;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.botplayScoreTxt = botplayScoreTxt;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
		FlxG.save.data.shakingScreen = shakingScreen;
		FlxG.save.data.smoothHPBug = smoothHPBug;
		FlxG.save.data.comboOffset = comboOffset;
		FlxG.save.data.achievementsMap = Achievements.achievementsMap;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.returnMemoryToFlxStringUtil = returnMemoryToFlxStringUtil;
		FlxG.save.data.controllerMode = controllerMode;
		FlxG.save.data.hitsoundVolume = hitsoundVolume;
		FlxG.save.data.pauseMusic = pauseMusic;
		FlxG.save.data.checkForUpdates = checkForUpdates;
		FlxG.save.data.comboStacking = comboStacking;
		FlxG.save.data.botplayWatermark = botplayWatermark;

		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99'); // Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs()
	{
		if (FlxG.save.data.downScroll != null)
		{
			downScroll = FlxG.save.data.downScroll;
		}
		if (FlxG.save.data.downScroll != null)
		{
			downScroll = FlxG.save.data.downScroll;
		}
		if (FlxG.save.data.middleScroll != null)
		{
			middleScroll = FlxG.save.data.middleScroll;
		}
		if (FlxG.save.data.botplayWatermark != null)
		{
			botplayWatermark = FlxG.save.data.botplayWatermark;
		}
		if (FlxG.save.data.returnMemoryToFlxStringUtil != null)
		{
			returnMemoryToFlxStringUtil = FlxG.save.data.returnMemoryToFlxStringUtil;
		}
		if (FlxG.save.data.seWatermarkLmfao != null)
		{
			seWatermarkLmfao = FlxG.save.data.seWatermarkLmfao;
		}
		if (FlxG.save.data.laneUnderlay != null)
		{
			laneUnderlay = FlxG.save.data.laneUnderlay;
		}
		if (FlxG.save.data.laneUnderlayAlpha != null)
		{
			laneUnderlayAlpha = FlxG.save.data.laneUnderlayAlpha;
		}
		if (FlxG.save.data.missSoundShit != null)
		{
			missSoundShit = FlxG.save.data.missSoundShit;
		}
		if (FlxG.save.data.shakingScreen != null)
		{
			shakingScreen = FlxG.save.data.shakingScreen;
		}
		if (FlxG.save.data.funnyScoreTextImVeryFunny != null)
		{
			funnyScoreTextImVeryFunny = FlxG.save.data.funnyScoreTextImVeryFunny;
		}
		if (FlxG.save.data.opponentStrums != null)
		{
			opponentStrums = FlxG.save.data.opponentStrums;
		}
		if (FlxG.save.data.strumsAreFuckingOffset != null)
		{
			strumsAreFuckingOffset = FlxG.save.data.strumsAreFuckingOffset;
		}
		if (FlxG.save.data.healthBarStyle != null)
		{
			healthBarStyle = FlxG.save.data.healthBarStyle;
		}
		if (FlxG.save.data.smoothHealth != null)
		{
			smoothHealth = FlxG.save.data.smoothHealth;
		}
		if (FlxG.save.data.smoothHPBug != null)
		{
			smoothHPBug = FlxG.save.data.smoothHPBug;
		}
		if (FlxG.save.data.botLightStrum != null)
		{
			botLightStrum = FlxG.save.data.botLightStrum;
		}
		if (FlxG.save.data.playerLightStrum != null)
		{
			playerLightStrum = FlxG.save.data.playerLightStrum;
		}
		if (FlxG.save.data.oppoLightStrum != null)
		{
			oppoLightStrum = FlxG.save.data.oppoLightStrum;
		}
		if (FlxG.save.data.noBotLag != null)
		{
			noBotLag = FlxG.save.data.noBotLag;
		}
		if (FlxG.save.data.noHitFuncs != null)
		{
			noHitFuncs = FlxG.save.data.noHitFuncs;
		}
		if (FlxG.save.data.noSpawnFunc != null)
		{
			noSpawnFunc = FlxG.save.data.noSpawnFunc;
		}
		if (FlxG.save.data.deactivateComboLimit != null)
		{
			deactivateComboLimit = FlxG.save.data.deactivateComboLimit;
		}
		if (FlxG.save.data.showFPS != null)
		{
			showFPS = FlxG.save.data.showFPS;
			if (Main.fpsVar != null)
			{
				Main.fpsVar.visible = showFPS;
				Main.fpsBg.visible = showFPS;
			}
		}
		if (FlxG.save.data.flashing != null)
		{
			flashing = FlxG.save.data.flashing;
		}
		if (FlxG.save.data.globalAntialiasing != null)
		{
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if (FlxG.save.data.noteSplashes != null)
		{
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if (FlxG.save.data.lowQuality != null)
		{
			lowQuality = FlxG.save.data.lowQuality;
		}
		if (FlxG.save.data.shaders != null)
		{
			shaders = FlxG.save.data.shaders;
		}
		if (FlxG.save.data.framerate != null)
		{
			framerate = FlxG.save.data.framerate;
			if (framerate > FlxG.drawFramerate)
			{
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			}
		}
		// rendering stuff
		if (FlxG.save.data.ffmpegMode != null)
		{
			ffmpegMode = FlxG.save.data.ffmpegMode;
		}

		if (FlxG.save.data.ffmpegInfo != null)
		{
			ffmpegInfo = FlxG.save.data.ffmpegInfo;
		}

		if (FlxG.save.data.targetFPS != null)
		{
			targetFPS = FlxG.save.data.targetFPS;
		}

		if (FlxG.save.data.unlockFPS != null)
		{
			unlockFPS = FlxG.save.data.unlockFPS;
		}

		if (FlxG.save.data.lossless != null)
		{
			lossless = FlxG.save.data.lossless;
		}

		if (FlxG.save.data.quality != null)
		{
			quality = FlxG.save.data.quality;
		}

		if (FlxG.save.data.noCapture != null)
		{
			noCapture = FlxG.save.data.noCapture;
		}
		if (FlxG.save.data.botplayScoreTxt != null)
		{
			botplayScoreTxt = FlxG.save.data.botplayScoreTxt;
		}
		if (FlxG.save.data.camZooms != null)
		{
			camZooms = FlxG.save.data.camZooms;
		}
		if (FlxG.save.data.hideHud != null)
		{
			hideHud = FlxG.save.data.hideHud;
		}
		if (FlxG.save.data.noteOffset != null)
		{
			noteOffset = FlxG.save.data.noteOffset;
		}
		if (FlxG.save.data.arrowHSV != null)
		{
			arrowHSV = FlxG.save.data.arrowHSV;
		}
		if (FlxG.save.data.ghostTapping != null)
		{
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if (FlxG.save.data.timeBarType != null)
		{
			timeBarType = FlxG.save.data.timeBarType;
		}
		if (FlxG.save.data.scoreZoom != null)
		{
			scoreZoom = FlxG.save.data.scoreZoom;
		}
		if (FlxG.save.data.noReset != null)
		{
			noReset = FlxG.save.data.noReset;
		}
		if (FlxG.save.data.healthBarAlpha != null)
		{
			healthBarAlpha = FlxG.save.data.healthBarAlpha;
		}
		if (FlxG.save.data.comboOffset != null)
		{
			comboOffset = FlxG.save.data.comboOffset;
		}

		if (FlxG.save.data.ratingOffset != null)
		{
			ratingOffset = FlxG.save.data.ratingOffset;
		}
		if (FlxG.save.data.sickWindow != null)
		{
			sickWindow = FlxG.save.data.sickWindow;
		}
		if (FlxG.save.data.goodWindow != null)
		{
			goodWindow = FlxG.save.data.goodWindow;
		}
		if (FlxG.save.data.badWindow != null)
		{
			badWindow = FlxG.save.data.badWindow;
		}
		if (FlxG.save.data.iconBounceBS != null)
		{
			iconBounceBS = FlxG.save.data.iconBounceBS;
		}
		if (FlxG.save.data.safeFrames != null)
		{
			safeFrames = FlxG.save.data.safeFrames;
		}
		if (FlxG.save.data.controllerMode != null)
		{
			controllerMode = FlxG.save.data.controllerMode;
		}
		if (FlxG.save.data.hitsoundVolume != null)
		{
			hitsoundVolume = FlxG.save.data.hitsoundVolume;
		}
		if (FlxG.save.data.pauseMusic != null)
		{
			pauseMusic = FlxG.save.data.pauseMusic;
		}
		if (FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}

		// flixel automatically saves your volume!
		if (FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute;
		}
		if (FlxG.save.data.checkForUpdates != null)
		{
			checkForUpdates = FlxG.save.data.checkForUpdates;
		}
		if (FlxG.save.data.comboStacking != null)
			comboStacking = FlxG.save.data.comboStacking;

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99');
		if (save != null && save.data.customControls != null)
		{
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls)
			{
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic
	{
		return /*PlayState.isStoryMode ? defaultValue : */ (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls()
	{
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey>
	{
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len)
		{
			if (copiedArray[i] == NONE)
			{
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
	/*public static function saveSetting(name:String)
		{
			FlxG.save.data.name = name;
	}*/
}
