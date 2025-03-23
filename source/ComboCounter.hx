package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxTimer;
import flixel.FlxG;

class ComboCounter extends FlxTypedSpriteGroup<FlxSprite>
{
	var effectStuff:FlxSprite;

	var wasComboSetup:Bool = false;
	var daCombo:Int = 0;

	var grpNumbers:FlxTypedGroup<ComboNumber>;

	var onScreenTime:Float = 0;

	public function new(x:Float, y:Float, daCombo:Int = 0)
	{
		super(x, y);

		this.daCombo = daCombo;

		effectStuff = new FlxSprite(0, 0);
		effectStuff.frames = Paths.getSparrowAtlas('noteCombo');
		effectStuff.animation.addByPrefix('funny', 'NOTE COMBO animation', 24, false);
		effectStuff.animation.play('funny');
		effectStuff.antialiasing = true;
		effectStuff.animation.finishCallback = function(nameThing)
		{
			kill();
		};
		add(effectStuff);

		grpNumbers = new FlxTypedGroup<ComboNumber>();
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
		else
			effectStuff.animation.play('funny', true, false, 18);
	}
	override function update(elapsed:Float) {
		onScreenTime += elapsed;
	
		// Ensure effectStuff and its animation exist before accessing them
		if (effectStuff.animation != null && effectStuff.animation.curAnim != null) 
		{
			var curFrame = effectStuff.animation.curAnim.curFrame;
	
			if (curFrame == 17) 
				effectStuff.animation.pause();
	
			if (curFrame == 2 && !wasComboSetup) 
			{
				setupCombo(daCombo);
				wasComboSetup = true; // Prevents it from running repeatedly
			}
	
			if (curFrame == 18)
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
	
			if (curFrame == 20)
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
