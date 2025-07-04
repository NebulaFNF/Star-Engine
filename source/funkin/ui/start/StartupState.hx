package funkin.ui.start;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import funkin.utils.MusicBeatState;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
#if VIDEOS_ALLOWED
import funkin.video.VideoSprite;
#end

class StartupState extends MusicBeatState
{
	var logo:FlxSprite;
	var skipTxt:FlxText;

	var theIntro:Int = FlxG.random.int(0, 2);

	private var vidSprite:VideoSprite = null;

	private function startVideo(name:String, ?library:String = null, ?callback:Void->Void = null, canSkip:Bool = true, loop:Bool = false,
			playOnLoad:Bool = true)
	{
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = Paths.video(name);

		#if sys
		if (FileSystem.exists(fileName))
		#else
		if (OpenFlAssets.exists(fileName))
		#end
		foundFile = true;

		if (foundFile)
		{
			vidSprite = new VideoSprite(fileName, false, canSkip, loop);

			// Finish callback
			function onVideoEnd()
				MusicBeatState.switchState(new funkin.ui.menu.TitleState());
			vidSprite.finishCallback = (callback != null) ? callback.bind() : onVideoEnd;
			vidSprite.onSkip = (callback != null) ? callback.bind() : onVideoEnd;
			insert(0, vidSprite);

			if (playOnLoad)
				vidSprite.videoSprite.play();
			return vidSprite;
		}
		else
		{
			FlxG.log.error("Video not found: " + fileName);
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new funkin.ui.menu.TitleState());
			});
		}
		#else
		FlxG.log.warn('Platform not supported!');
		#end
		return null;
	}

	override public function create():Void
	{
		FlxG.mouse.visible = true;
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		logo = new FlxSprite().loadGraphic(Paths.image('StarEngineLogoHah'));
		logo.scrollFactor.set();
		logo.screenCenter();
		logo.alpha = 0;
		logo.active = true;
		add(logo);

		skipTxt = new FlxText(0, FlxG.height, 0, 'Press ENTER To Skip', 16);
		skipTxt.setFormat("Comic Sans MS Bold", 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		skipTxt.borderSize = 1.5;
		skipTxt.antialiasing = true;
		skipTxt.scrollFactor.set();
		skipTxt.alpha = 0;
		skipTxt.y -= skipTxt.textField.textHeight;
		add(skipTxt);

		FlxTween.tween(skipTxt, {alpha: 1}, 1);

		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			switch (theIntro)
			{
				case 0:
					FlxG.sound.play(Paths.sound('confirmMenuOld'));
					logo.scale.set(0.1, 0.1);
					logo.updateHitbox();
					logo.screenCenter();
					FlxTween.tween(logo, {alpha: 1, "scale.x": 1, "scale.y": 1}, 0.95, {ease: FlxEase.expoOut, onComplete: _ -> onIntroDone()});
				case 1:
					#if VIDEOS_ALLOWED
					startVideo('startupAltLmao');
					#end
				case 2:
					#if VIDEOS_ALLOWED
					startVideo('coinStart');
					#end
			}
		});

		super.create();
	}

	function onIntroDone()
	{
		FlxTween.tween(logo, {alpha: 0}, 1, {
			ease: FlxEase.linear,
			onComplete: function(_)
			{
				MusicBeatState.switchState(new funkin.ui.menu.TitleState());
			}
		});
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
			MusicBeatState.switchState(new funkin.ui.menu.TitleState());

		super.update(elapsed);
	}
}
