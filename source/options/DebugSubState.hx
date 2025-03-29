package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.math.FlxMath;

class GameRendererSettingsSubState extends BaseOptionsMenu {
	public function new() {
		title = 'Debug Menu';
		rpcTitle = 'Debug Menu'; //for Discord Rich Presence

		var option:Option = new Option('Sorry, for now there is nothing', 'This will probably change in a few months but yeh', 'workInProgressThingHaha', '!', ['!']);
		addOption(option);

		super();
	}
}
