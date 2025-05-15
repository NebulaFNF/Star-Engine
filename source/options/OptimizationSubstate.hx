package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

using StringTools;

class OptimizationSubstate extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Optimization';
		rpcTitle = 'Optimization Settings Menu'; // for Discord Rich Presence

		// I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Work in Progress', // Name
			'Check shit at your own risk.', // Description
			'workInProgressThingHaha', // Save data variable name
			'string', '!', ['!']);
		addOption(option);

		// I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Disable GC', // Name
			'Disables garbage collecting, which improves performance.\nTurn it off/on if youre experiencing lag.\n(Requires restart!!)', // I CANT PUT A ' :crying_face:
			'disableGC', // Save data variable name
			'bool', // Variable type
			false); // Default value
		addOption(option);

		var option:Option = new Option('noHitFuncs', 'I dont know what this does, but i guess enable it.', 'noHitFuncs', 'bool', false);
		addOption(option);

		var option:Option = new Option('noSpawnFunc', 'I dont know what this does, but i guess enable it.', 'noSpawnFunc', 'bool', false);
		addOption(option);

		var option:Option = new Option('No Botplay Lag', 'Reduces botplay lag.', 'noBotLag', 'bool', false);
		addOption(option);

		var option:Option = new Option('Light Bot Strums', 'If unchecked, disables note strum animation for botplay.', 'botLightStrum', 'bool', false);
		addOption(option);

		var option:Option = new Option('Light Player Strums', 'If unchecked, disables note strum animation.', 'playerLightStrum', 'bool', false);
		addOption(option);

		var option:Option = new Option('Light Opponent Strums', 'If unchecked, disables note strum animation.', 'oppoLightStrum', 'bool', false);
		addOption(option);

		var option:Option = new Option('Disable Note Combo Limits', 'It disables the Note Combo limit to prevent crashing.', 'deactivateComboLimit', 'bool',
			false);
		addOption(option);

		/*option.minValue = 60;
			option.maxValue = 240;
			option.displayFormat = '%v FPS';
			option.onChange = onChangeFramerate;
			#end */

		super();
	}
}
