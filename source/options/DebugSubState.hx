package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.math.FlxMath;

class DebugSubState extends BaseOptionsMenu {
	public function new() {
		title = 'Debug Menu';
		rpcTitle = 'Debug Menu'; //for Discord Rich Presence

		var option:Option = new Option('Work in progress', 'This will probably change in a few months but yeh', 'workInProgressThingHaha', '!', ['!']);
		addOption(option);

		var option:Option = new Option('Cooler FPS Counter', 'If checked, the FPS counter will be MUCH cooler!', 'fpsCounterThingie', 'bool', false);
     	addOption(option);

		super();
	}
}
