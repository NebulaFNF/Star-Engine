package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxTimer;
import flixel.FlxG;

class ComboCounter extends FlxTypedSpriteGroup<FlxSprite>
{
	public var effectStuff:FlxSprite;

	var wasComboSetup:Bool = false;
	var daCombo:Int = 0;

	var grpNumbers:FlxTypedGroup<ComboNumber>;

	var onScreenTime:Float = 0;

	public static var playShit:Bool = false;

	public function new()
	{
		super();

		addComboShit();
	}

	public function addComboShit() {
		playShit = true;
		changeStuff('funny', 'NOTE COMBO animation', 24);
	}

	public function changeStuff(animName:String, animSparrowName:String, framerate:Int) {
		effectStuff = new FlxSprite(-100, 300);
		effectStuff.frames = Paths.getSparrowAtlas('noteCombo');
		effectStuff.animation.addByPrefix(animName, animSparrowName, framerate, false);
		effectStuff.antialiasing = true;
		effectStuff.animation.finishCallback = function(nameThing)
		{
			kill();
		};

		if (playShit) {
			effectStuff.animation.play(animName, true, false, framerate);
		}
	}

	public function forceFinish():Void
	{
		if (onScreenTime < 0.9)
		{
			new FlxTimer().start((Conductor.crochet / 1000) * 0.25, function(tmr)
			{
				forceFinish();
			});
		}
		else {
			playShit = true;
			changeStuff('funny', 'NOTE COMBO animation', 18);
		}	    
	}

	override function update(elapsed:Float) {
		onScreenTime += elapsed;
		var comboFrame = effectStuff.animation.curAnim.curFrame;
	
		// Ensure effectStuff and its animation exist before accessing them
		if (effectStuff.animation != null && effectStuff.animation.curAnim != null) 
		{
			if (comboFrame == 17 && playShit) {
				playShit = false;
				effectStuff.animation.pause();
			}
	
			if (comboFrame == 2 && !wasComboSetup) 
			{
				setupCombo(daCombo);
				wasComboSetup = true; // Prevents it from running repeatedly
			}
	
			if (comboFrame == 18)
			{
				// Ensure grpNumbers exists before iterating
				if (grpNumbers != null) 
				{
					grpNumbers.forEach(function(spr:ComboNumber)
					{
						if (spr.animation != null)
							spr.animation.reset();
					});
				}
			}
	
			if (comboFrame == 20)
			{
				if (grpNumbers != null)
				{
					var toKill:Array<ComboNumber> = [];
					grpNumbers.forEach(function(spr:ComboNumber)
					{
						toKill.push(spr);
					});
	
					for (spr in toKill)
					{
						spr.kill();
					}
				}
			}
		}
	
		super.update(elapsed);
	}

	function setupCombo(daCombo:Int)
	{
		FlxG.sound.play(Paths.sound('comboSound'));

		wasComboSetup = true;
		var loopNum:Int = 0;

		while (daCombo > 0)
		{
			var comboNumber:ComboNumber = new ComboNumber(420 - (130 * loopNum), 44 * loopNum, daCombo % 10);
			grpNumbers.add(comboNumber);
			add(comboNumber);

			loopNum += 1;

			daCombo = Math.floor(daCombo / 10);
		}
	}
}

class ComboNumber extends FlxSprite
{
	public function new(x:Float, y:Float, digit:Int)
	{
		super(x - 20, y);

		var stringNum:String = Std.string(digit);
		frames = Paths.getSparrowAtlas('noteComboNumbers');
		animation.addByPrefix(stringNum, stringNum, 24, false);
		animation.play(stringNum);
		antialiasing = true;
		updateHitbox();
	}

	var shiftedX:Bool = false;

	override function update(elapsed:Float)
	{
		if (animation.curAnim.curFrame == 2 && !shiftedX)
		{
			shiftedX = true;
			x += 20;
		}

		super.update(elapsed);
	}
}
