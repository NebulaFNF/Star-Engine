package funkin.play.note;

import flixel.FlxG;
import flixel.FlxSprite;
import funkin.shaders.ColorSwap;

/**
 * This is the class that handles the note splash when you hit a SICK! on a note.
 */
class NoteSplash extends FlxSprite
{
	/**
	 * The color swap shader.
	 */
	public var colorSwap:ColorSwap = null;

	/**
	 * The idle animation.
	 */
	private var idleAnim:String;

	/**
	 * The texture loaded.
	 */
	private var textureLoaded:String = null;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0)
	{
		super(x, y);

		var skin:String = 'noteSplashes';
		if (PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0)
			skin = PlayState.SONG.splashSkin;

		loadAnims(skin);

		colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		setupNoteSplash(x, y, note);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	/**
	 * Sets up the Note Splash on screen.
	 * @param x - The X direction of the splash.
	 * @param y - The Y direction of the splash
	 * @param note - What type of note it is. (More documentation on funkin.play.note.StrumlineNote!)
	 * @param texture - What texture it is.
	 * @param hueColor - What hue would you like?
	 * @param satColor - What saturation would you like?
	 * @param brtColor - What brightness would you like?
	 */
	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null, hueColor:Float = 0, satColor:Float = 0, brtColor:Float = 0)
	{
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		alpha = 0.6;

		if (texture == null)
		{
			texture = 'noteSplashes';
			if (PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0)
				texture = PlayState.SONG.splashSkin;
		}

		if (textureLoaded != texture)
			loadAnims(texture);
		colorSwap.hue = hueColor;
		colorSwap.saturation = satColor;
		colorSwap.brightness = brtColor;
		offset.set(10, 10);

		var animNum:Int = FlxG.random.int(1, 2);
		animation.play('note' + note + '-' + animNum, true);
		if (animation.curAnim != null)
			animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
	}

	function loadAnims(skin:String)
	{
		frames = Paths.getSparrowAtlas(skin);
		for (i in 1...3)
		{
			animation.addByPrefix("note1-" + i, "note splash blue " + i, 24, false);
			animation.addByPrefix("note2-" + i, "note splash green " + i, 24, false);
			animation.addByPrefix("note0-" + i, "note splash purple " + i, 24, false);
			animation.addByPrefix("note3-" + i, "note splash red " + i, 24, false);
		}
	}

	override function update(elapsed:Float)
	{
		if (animation.curAnim != null)
			if (animation.curAnim.finished)
				kill();

		super.update(elapsed);
	}
}
