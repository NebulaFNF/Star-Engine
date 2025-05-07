package openfl.display;

import flixel.FlxG;
import openfl.display.Sprite;

/**
 * The FPS background!
 */
class FPSBg extends Sprite
{
	// Credits to HRK_EXEX
	var bgCard:Sprite;
    var isShow:Bool = false;
    public function new()
    {
        super();

		bgCard = new Sprite();
		bgCard.graphics.beginFill(0x000000, 0.5);
		if (ClientPrefs.fpsCounterThingie) {
			bgCard.graphics.drawRect(0, 0, 142, 25);
		} else {
			bgCard.graphics.drawRect(0, 0, 238, 44);
		}
		bgCard.graphics.endFill();
		addChild(bgCard);
    }

	/**
	 * Relocates to X and Y
	 * @param X Value (Float)
	 * @param Y Value (Float)
	 * @param isWide Bool (true or false!)
	 */
	public inline function relocate(X:Float, Y:Float, isWide:Bool = false) {
		if (isWide) {
			x = X; y = Y;
		} else {
			x = FlxG.game.x + X;
			y = FlxG.game.y + Y;
		}
	}
}