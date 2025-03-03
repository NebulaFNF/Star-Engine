package;

typedef SwagSection =
{
	public var sectionNotes:Array<Dynamic>;
	public var sectionBeats:Float;
	public var typeOfSection:Int;
	public var mustHitSection:Bool;
	public var gfSection:Bool;
	public var bpm:Float;
	public var changeBPM:Bool;
	public var altAnim:Bool;
}

class Section
{
	public var sectionNotes:Array<Dynamic> = [];

	public var sectionBeats:Float = 4;
	public var gfSection:Bool = false;
	public var typeOfSection:Int = 0;
	public var mustHitSection:Bool = true;

	/**
	 *	Copies the first section into the second section!
	 */
	public static var COPYCAT:Int = 0;

	public function new(sectionBeats:Float = 4)
	{
		this.sectionBeats = sectionBeats;
		trace('test created section: ' + sectionBeats);
	}
}
