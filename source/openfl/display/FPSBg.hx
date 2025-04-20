package openfl.display;

import openfl.display.Sprite;
import flixel.FlxG;

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
			bgCard.graphics.drawRect(0, 0, 187, 44);
		}
		bgCard.graphics.endFill();
		addChild(bgCard);
		//relocate(0, 0, wideScreen); // i don't think this is needed
    }

	public inline function relocate(X:Float, Y:Float, isWide:Bool = false) {
		if (isWide) {
			x = X; y = Y;
		} else {
			x = FlxG.game.x + X;
			y = FlxG.game.y + Y;
		}
	}
}