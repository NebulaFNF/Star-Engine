package;

import flixel.FlxSubState;

class MusicBeatSubstate extends FlxSubState
{
	public static var skibidi:MusicBeatState; // so haxe does not shit itself // haxe shit itself
	public function new() super();

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;
	public var stages:Array<BaseStage> = [];
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		stagesFunc(function(stage:BaseStage) {
			stage.update(elapsed);
		});

		if (oldStep != curStep && curStep > 0) stepHit();

		super.update(elapsed);
	}

	public function stagesFunc(func:BaseStage->Void)
	{
		for (stage in stages)
			if(stage != null && stage.exists && stage.active) func(stage);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public function stepHit():Void if (curStep % 4 == 0) beatHit();

	public function beatHit():Void
	{
		// skibidi
	}
}
