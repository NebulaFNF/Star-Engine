package;

import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	//public static var ifIsWinningIcon:Bool = false;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	var initialWidth:Float = 0;
	var initialHeight:Float = 0;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null) {
			if (ClientPrefs.iconBounceBS == 'Vanilla') {
				setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
			} else {
				setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
			}
		}
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			initialWidth = width;
			initialHeight = height;
			var width2 = width;
			if (width == 450) {
				loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); //Then load it fr // winning icons go br
				iconOffsets[0] = (width - 150) / 3;
				iconOffsets[1] = (height - 150) / 3;
			} else if (width == 451) {
				loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); //Then load it fr // winning icons go br
				iconOffsets[0] = (width - 151) / 3;
				iconOffsets[1] = (height - 150) / 3;
			} else {
				loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr // winning icons go br
				iconOffsets[0] = (width - 150) / 2;
				iconOffsets[1] = (height - 150) / 2;
			}
			updateHitbox();

			if (width2 == 450) animation.add(char, [0, 1, 2], 0, false, isPlayer);
			else if (width2 == 300) animation.add(char, [0, 1], 0, false, isPlayer);
			else animation.add(char, [0, 1], 0, false, isPlayer); // this is kinda dumb but ehhh

			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) antialiasing = false;
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		if (ClientPrefs.iconBounceBS == 'Vanilla') {
			// TODO: Make this more legacy-like.
			width = Math.abs(scale.x) * frameWidth;
			height = Math.abs(scale.y) * frameHeight;
			offset.set(-0.5 * (width - frameWidth), -0.5 * (height - frameHeight));
			centerOrigin();
		} else {
			offset.x = iconOffsets[0];
			offset.y = iconOffsets[1];
			if (initialWidth != (150 * animation.frames) || initialHeight != 150) //Fixes weird icon offsets when they're HUMONGUS (sussy)
			{
				offset.x = iconOffsets[0];
				offset.y = iconOffsets[1];
			}
		}
	}

	public function getCharacter():String return char;
}