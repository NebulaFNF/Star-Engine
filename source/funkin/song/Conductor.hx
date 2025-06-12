package funkin.song;

import flixel.FlxG;
import funkin.play.note.Note;
import funkin.prefs.ClientPrefs;
import funkin.song.Song.SwagSong;

/**
 * ...
 * @author
 */
typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
	@:optional var stepCrochet:Float;
}

/**
 * Which system to use when scoring and judging notes.
 */
enum abstract ScoringSystem(String)
{
	/**
	 * The scoring system used in versions of the game Week 6 and older.
	 * Scores the player based on judgement, represented by a step function.
	 */
	var LEGACY;

	/**
	 * The scoring system used in Week 7. It has tighter scoring windows than Legacy.
	 * Scores the player based on judgement, represented by a step function.
	 */
	var WEEK7;

	/**
	 * Points based on timing scoring system, version 1
	 * Scores the player based on the offset based on timing, represented by a sigmoid function.
	 */
	var PBOT1;
}

class Conductor
{
	/**
	 * The default BPM of the song.
	 */
	public static var bpm:Float = 100;

	/**
	 * The amount of beats in milliseconds.
	 */
	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds

	/**
	 * The amount of steps in milliseconds.
	 */
	public static var stepCrochet:Float = crochet / 4; // steps in milliseconds

	/**
	 * Current position in the song, in beats.
	 */
	public var currentBeat(default, null):Int = 0;

	/**
	 * Unused variables.
	 */
	public static var songPosition:Float = 0;

	public static var lastSongPos:Float;
	public static var offset:Float = 0;

	/**
	 * The score a note receives when missed.
	 */
	public static final LEGACY_MISS_SCORE:Int = -10;

	public static final WEEK7_MISS_SCORE:Int = -10;

	/**
	 * The maximum score a note can receive.
	 */
	public static final PBOT1_MAX_SCORE:Int = 500;

	/**
	 * The offset of the sigmoid curve for the scoring function.
	 */
	public static final PBOT1_SCORING_OFFSET:Float = 54.99;

	/**
	 * The slope of the sigmoid curve for the scoring function.
	 */
	public static final PBOT1_SCORING_SLOPE:Float = 0.080;

	/**
	 * The minimum score a note can receive while still being considered a hit.
	 */
	public static final PBOT1_MIN_SCORE:Float = 9.0;

	/**
	 * The score a note receives when it is missed.
	 */
	public static final PBOT1_MISS_SCORE:Int = -100;

	/**
	 * The threshold at which a note hit is considered perfect and always given the max score.
	 */
	public static final PBOT1_PERFECT_THRESHOLD:Float = 5.0; // 5ms

	/**
	 * The threshold at which a note hit is considered missed.
	 * `160ms`
	 */
	public static final PBOT1_MISS_THRESHOLD:Float = 160.0;

	/**
	 * The time within which a note is considered to have been hit with the Killer judgement.
	 *
	 * Star Engine developer note: Killer judgement reall1>!?!!?!?1?1?
	 * `~7.5% of the hit window, or 12.5ms`
	 */
	public static final PBOT1_KILLER_THRESHOLD:Float = 12.5;

	/**
	 * The time within which a note is considered to have been hit with the Sick judgement.
	 * `~25% of the hit window, or 45ms`
	 */
	public static final PBOT1_SICK_THRESHOLD:Float = 45.0;

	/**
	 * The time within which a note is considered to have been hit with the Good judgement.
	 * `~55% of the hit window, or 90ms`
	 */
	public static final PBOT1_GOOD_THRESHOLD:Float = 90.0;

	/**
	 * The time within which a note is considered to have been hit with the Bad judgement.
	 * `~85% of the hit window, or 135ms`
	 */
	public static final PBOT1_BAD_THRESHOLD:Float = 135.0;

	/**
	 * The time within which a note is considered to have been hit with the Shit judgement.
	 * `100% of the hit window, or 160ms`
	 */
	public static final PBOT1_SHIT_THRESHOLD:Float = 160.0;

	// public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (ClientPrefs.safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds

	public static var bpmChangeMap:Array<BPMChangeEvent> = [];
	public static var timeScale:Float = Conductor.safeZoneOffset / 166;

	public function new() {}

	public static function scoreNotePBOT1(msTiming:Float):Int
	{
		// Absolute value because otherwise late hits are always given the max score.
		var absTiming:Float = Math.abs(msTiming);

		return switch (absTiming)
		{
			case(_ > PBOT1_MISS_THRESHOLD) => true:
				PBOT1_MISS_SCORE;
			case(_ < PBOT1_PERFECT_THRESHOLD) => true:
				PBOT1_MAX_SCORE;
			default:
				// Fancy equation.
				var factor:Float = 1.0 - (1.0 / (1.0 + Math.exp(-PBOT1_SCORING_SLOPE * (absTiming - PBOT1_SCORING_OFFSET))));
				var score:Int = Std.int(PBOT1_MAX_SCORE * factor + PBOT1_MIN_SCORE);

				score;
		}
	}

	static function judgeNotePBOT1(msTiming:Float):String
	{
		var absTiming:Float = Math.abs(msTiming);

		return switch (absTiming)
		{
			// case(_ < PBOT1_KILLER_THRESHOLD) => true:
			//  'killer';
			case(_ < PBOT1_SICK_THRESHOLD) => true:
				'sick';
			case(_ < PBOT1_GOOD_THRESHOLD) => true:
				'good';
			case(_ < PBOT1_BAD_THRESHOLD) => true:
				'bad';
			case(_ < PBOT1_SHIT_THRESHOLD) => true:
				'shit';
			default:
				FlxG.log.warn('Missed note: Bad timing ($absTiming < $PBOT1_SHIT_THRESHOLD)');
				'miss';
		}
	}

	public static function getMissScore(scoringSystem:ScoringSystem = PBOT1):Int
	{
		return switch (scoringSystem)
		{
			case LEGACY: LEGACY_MISS_SCORE;
			case WEEK7: WEEK7_MISS_SCORE;
			case PBOT1: PBOT1_MISS_SCORE;
			default:
				FlxG.log.error('Unknown scoring system: ${scoringSystem}');
				0;
		}
	}

	// old judging (real!111rER5YE NT6KOPUJIOPSR)
	public static function judgeNote(note:Note, diff:Float = 0):Rating // die
	{
		var data:Array<Rating> = funkin.play.PlayState.instance.ratingsData; // shortening cuz fuck u
		for (i in 0...data.length - 1)
			if (diff <= data[i].hitWindow)
				return data[i];
		return data[data.length - 1];
	}

	public static function getCrotchetAtTime(time:Float)
	{
		var lastChange = getBPMFromSeconds(time);
		return lastChange.stepCrochet * 4;
	}

	public static function getBPMFromSeconds(time:Float)
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: bpm,
			stepCrochet: stepCrochet
		}
		for (i in 0...Conductor.bpmChangeMap.length)
			if (time >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];

		return lastChange;
	}

	public static function getBPMFromStep(step:Float)
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: bpm,
			stepCrochet: stepCrochet
		}
		for (i in 0...Conductor.bpmChangeMap.length)
			if (Conductor.bpmChangeMap[i].stepTime <= step)
				lastChange = Conductor.bpmChangeMap[i];

		return lastChange;
	}

	public static function beatToSeconds(beat:Float):Float
	{
		var step = beat * 4;
		var lastChange = getBPMFromStep(step);
		return lastChange.songTime
			+ ((step - lastChange.stepTime) / (lastChange.bpm / 60) / 4) * 1000; // TODO: make less shit and take BPM into account PROPERLY
	}

	public static function getStep(time:Float)
	{
		var lastChange = getBPMFromSeconds(time);
		return lastChange.stepTime + (time - lastChange.songTime) / lastChange.stepCrochet;
	}

	public static function getStepRounded(time:Float)
	{
		var lastChange = getBPMFromSeconds(time);
		return lastChange.stepTime + Math.floor(time - lastChange.songTime) / lastChange.stepCrochet;
	}

	public static function getBeat(time:Float)
		return getStep(time) / 4;

	public static function getBeatRounded(time:Float):Int
		return Math.floor(getStepRounded(time) / 4);

	public static function mapBPMChanges(song:SwagSong)
	{
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length)
		{
			if (song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM,
					stepCrochet: calculateCrochet(curBPM) / 4
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = Math.round(getSectionBeats(song, i) * 4);
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		trace('New BPM map: $bpmChangeMap');
	}

	static function getSectionBeats(song:SwagSong, section:Int)
	{
		var val:Null<Float> = null;
		if (song.notes[section] != null)
			val = song.notes[section].sectionBeats;
		return val != null ? val : 4;
	}

	inline public static function calculateCrochet(bpm:Float)
		return (60 / bpm) * 1000;

	public static function changeBPM(newBpm:Float)
	{
		bpm = newBpm;

		crochet = calculateCrochet(bpm);
		stepCrochet = crochet / 4;
	}
}

class Rating
{
	public var name:String = '';
	public var image:String = '';
	public var counter:String = '';
	public var hitWindow:Null<Int> = 0; // ms
	public var ratingMod:Float = 1;
	public var score:Int = 350;
	public var noteSplash:Bool = true;

	public function new(name:String)
	{
		this.name = name;
		this.image = name;
		this.counter = name + 's';
		this.hitWindow = Reflect.field(ClientPrefs, name + 'Window');
		if (hitWindow == null)
			hitWindow = 0;
	}

	public function increase(blah:Int = 1)
		Reflect.setField(funkin.play.PlayState.instance, counter, Reflect.field(funkin.play.PlayState.instance, counter) + blah);
}
