package funkin.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		if(FlxG.sound.music == null) { //Shoutouts to Koji Kondo!
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		warnText = new FlxText(0, 0, FlxG.width,
			"You're using an\n
			outdated version of Star Engine (" + MainMenuState.psychEngineVersion + "),\n
			please update to " + TitleState.updateVersion + " if you want to!\n
			Press ESCAPE to proceed anyway.\n
			\n
			Thank you for using the Engine!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

		FlxG.sound.playMusic(Paths.music('finalHours'));
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/SyncGit12/Star-Engine/releases");
			}
			else if(controls.BACK) leftState = true;

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
