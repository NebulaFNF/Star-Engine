package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;

class DebugSubState extends BaseOptionsMenu {
	public function new() {
		title = 'Debug Menu';
		rpcTitle = 'Debug Menu'; //for Discord Rich Presence

		var option:Option = new Option('Work in progress', 'This will probably change in a few months but yeah', 'workInProgressThingHaha', '!', ['!']);
		addOption(option);

		var option:Option = new Option('Cooler FPS Counter', 'If checked, the FPS counter will be MUCH cooler!', 'fpsCounterThingie', 'bool', false);
     	addOption(option);
		
		//var option:Option = new Option('Shaking Window', 'If checked, is allowed to move the window', 'shakingScreen', 'bool', false);
     	//addOption(option);

		var option:Option = new Option(
			'returnMemoryToFlxStringUtil', 
			'If checked, handles calculating the memory usage like in 0.3.0.', 
			'returnMemoryToFlxStringUtil', 
			'bool', 
		false);
		addOption(option);

		var option:Option = new Option
		(
			'V-Slice Note Delay',
			'If checked, delays the BOTPLAY and OPPONENT end animation like in V-Slice',
			'vSliceNoteDelay',
			'bool',
			false
		);
		addOption(option);

		super();
	}
}
