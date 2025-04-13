package options;

#if desktop
import Discord.DiscordClient;
#end
import Controls;
import backend.PsychCamera;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = [
		'Note Colors',
		'Controls',
		'Game Rendering',
		'Optimization',
		'Adjust Delay and Combo',
		'Graphics',
		'Visuals and UI',
		'Gameplay'
	];
	private var grpOptions:FlxTypedGroup<Alphabet>;

	private static var curSelected:Int = 0;

	private var mainCamera:FlxCamera;
	private var subCamera:FlxCamera;
	private var otherCamera:FlxCamera;

	public static var menuBG:FlxSprite;

	function openSelectedSubstate(label:String)
	{
		switch (label)
		{
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Optimization':
				openSubState(new options.OptimizationSubstate());
			case 'Game Rendering':
				openSubState(new options.GameRendererSettingsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	override function create()
	{
		trace('I created myself! - Create function');
		mainCamera = initPsychCamera();
		subCamera = new FlxCamera();
		otherCamera = new FlxCamera();
		subCamera.bgColor.alpha = 0;
		otherCamera.bgColor.alpha = 0;

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		trace(camFollowPos + ' - it is a camera!');
		trace(camFollow + ' - it is a camera!');
		trace(mainCamera + ' - it is a camera!');
		trace(subCamera + ' - it is a camera!');
		trace(subCamera + ' - it is a camera!');
		//FlxG.cameras.list[FlxG.cameras.list.indexOf(subCamera)].follow(camFollowPos);

		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var yScroll:Float = Math.max(0.25 - (0.05 * (options.length - options.length)), 0.1);
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.scrollFactor.set(0, yScroll * 1.5);
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		selectorLeft.scrollFactor.set(0, yScroll * 1.5);
		selectorLeft.cameras = [subCamera];
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		selectorRight.scrollFactor.set(0, yScroll * 1.5);
		selectorRight.cameras = [subCamera];
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState()
	{
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float)
	{
		//trace('I created myself! - Update function');
		super.update(elapsed);

		if (controls.UI_UP_P)
			changeSelection(-1);
		if (controls.UI_DOWN_P)
			changeSelection(1);

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if (PauseSubState.inPause)
			{
				PauseSubState.inPause = false;
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else
				MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.RESET)
		{
			openSubState(new options.DebugSubState());
		}

		if (controls.ACCEPT)
			openSelectedSubstate(options[curSelected]);
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
			{
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		camFollow.setPosition(FlxG.width / 2, (curSelected * (grpOptions.members.length * 10)));

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
