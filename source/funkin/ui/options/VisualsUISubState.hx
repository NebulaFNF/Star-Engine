package funkin.ui.options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; // for Discord Rich Presence

		var option:Option = new Option('Note Splashes', "If unchecked, hitting \"Sick!\" notes won't show particles.", 'noteSplashes', 'bool', true);
		addOption(option);

		var option:Option = new Option('Hide HUD', 'If checked, hides most HUD elements.', 'hideHud', 'bool', false);
		addOption(option);

		var option:Option = new Option('Botplay Watermark', 'If unchecked, hides the Botplay watermark.', 'botplayWatermark', 'bool', false);
		addOption(option);

		var option:Option = new Option('Show Watermark', 'If checked, the game will show the Star Engine watermark.', 'seWatermarkLmfao', 'bool', false);
		addOption(option);

		var option:Option = new Option('Strums Offset', 'If checked, offsets the strums like in Kade Engine.', 'strumsAreFuckingOffset', 'bool', false);
		addOption(option);

		var option:Option = new Option('Time Bar:', "What should the Time Bar display?", 'timeBarType', 'string', 'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Lane Underlay', "If checked, a black line will appear behind the notes, making them easier to read.", 'laneUnderlay',
			'bool', false);
		addOption(option);

		var option:Option = new Option('Lane Underlay Transparency',
			'How transparent do you want the lane underlay to be? (0% = transparent, 100% = fully opaque)', 'laneUnderlayAlpha', 'percent', 1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Flashing Lights', "Uncheck this if you're sensitive to flashing lights!", 'flashing', 'bool', true);
		addOption(option);

		var option:Option = new Option('Icon Bounce:', "What icon bounce type would you like?", 'iconBounceBS', 'string', 'V-Slice', [
			'V-Slice',
			'Vanilla',
			'Plank Engine',
			'Golden Apple',
			'Psych',
			'Strident Crisis',
			'SB Engine'
		]);
		addOption(option);

		var option:Option = new Option('Camera Zooms', "If unchecked, the camera won't zoom in on a beat hit.", 'camZooms', 'bool', true);
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit', "If unchecked, disables the Score text zooming\neverytime you hit a note.", 'scoreZoom',
			'bool', true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency', 'How much transparent should the health bar and icons be.', 'healthBarAlpha', 'percent', 1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Health Bar Style', 'How do you like your health bar?', 'healthBarStyle', 'string', 'Legacy',
			['Psych', 'Legacy', 'Cooler']);
		addOption(option);

		#if !mobile
		var option:Option = new Option('FPS Counter', 'If unchecked, hides FPS Counter.', 'showFPS', 'bool', true);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end

		var option:Option = new Option('Pause Screen Song:', "What song do you prefer for the Pause Screen?", 'pauseMusic', 'string', 'Tea Time',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;

		var option:Option = new Option('ScoreTxt Style: ', "How would you like your ScoreTxt?", 'funnyScoreTextImVeryFunny', 'string', 'Vanilla',
			['Default', 'V-Slice', 'Psych Engine', 'Vanilla', 'Kade']);
		addOption(option);

		var option:Option = new Option('Smooth Health', 'If checked, enables smooth health.', 'smoothHealth', 'bool', true);
		addOption(option);

		var option:Option = new Option('Health Bar Overlapping', 'If checked, enables health bar overlapping.\n(You need Smooth Health to this to work!!)',
			'smoothHPBug', 'bool', true);
		addOption(option);

		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates', 'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates', 'bool', true);
		addOption(option);
		#end

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read", 'comboStacking', 'bool', true);
		addOption(option);

		super();
	}

	var changedMusic:Bool = false;

	function onChangePauseMusic()
	{
		if (ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if (changedMusic)
			FlxG.sound.playMusic(Paths.music(TitleState.mustUpdate ? 'finalHours' : 'freakyMenu'));
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if (Main.fpsVar == null)
			return;

		Main.fpsVar.visible = ClientPrefs.showFPS;
		Main.fpsBg.visible = ClientPrefs.showFPS;
	}
	#end
}
