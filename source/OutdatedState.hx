package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class OutdatedState extends FlxState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		FlxG.sound.playMusic(Paths.music('lastDay'), 0); //Shoutouts to Koji Kondo!

		if(FlxG.sound.music == null) { //Shoutouts to Koji Kondo!
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		warnText = new FlxText(0, 0, FlxG.width,
			'Sup bro, looks like you\'re running an outdated version of\nStar Engine (${MainMenuState.psychEngineVersion})\n
			-----------------------------------------------\n
			Press ESCAPE to proceed anyway.\n
			-----------------------------------------------\n
			Thank you for using the Engine!',
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
						FlxG.switchState(MainMenuState.new);
					}
				});
			}
		}
		super.update(elapsed);
	}
}
