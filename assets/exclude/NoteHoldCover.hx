import flixel.FlxSprite;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import funkin.play.note.Note.NoteDirection;

using StringTools;

class NoteHoldCover extends FlxTypedSpriteGroup<FlxSprite>
{
  static final FRAMERATE_DEFAULT:Int = 24;

  public var holdNote:SustainTrail;

  public var glow:FlxSprite;

  var sparks:FlxSprite;

  public function new()
  {
    super(0, 0);
  }

  /**
   * Add ALL the animations to this sprite. We will recycle and reuse the FlxSprite multiple times.
   */
  function setupHoldNoteCover():Void
  {
    glow = new FlxSprite();
    add(glow);

    // TODO: null check here like how NoteSplash does
    //noteStyle.buildHoldCoverSprite(this);

    glow.animation.onFinish.add(this.onAnimationFinished);

    if (glow.animation.getAnimationList().length < 3 * 4)
    {
      trace('WARNING: NoteHoldCover failed to initialize all animations.');
    }
  }

  public override function update(elapsed):Void
  {
    super.update(elapsed);
  }

  public function playStart():Void
  {
    var leNoteData:Int = Note.noteData;
    glow.animation.play('holdCoverStart${NoteDirection.get_colorName(leNoteData).toUpperCase()}');
  }

  public function playContinue():Void
  {
    var leNoteData:Int = Note.noteData;
    glow.animation.play('holdCover${NoteDirection.get_colorName(leNoteData).toUpperCase()}');
  }

  public function playEnd():Void
  {
    var leNoteData:Int = Note.noteData;
    glow.animation.play('holdCoverEnd${NoteDirection.get_colorName(leNoteData).toUpperCase()}');
  }

  public override function kill():Void
  {
    super.kill();

    this.visible = false;

    if (glow != null) glow.visible = false;
    if (sparks != null) sparks.visible = false;
  }

  public override function revive():Void
  {
    super.revive();

    this.visible = true;
    this.alpha = 1.0;

    if (glow != null) glow.visible = true;
    if (sparks != null) sparks.visible = true;
  }

  public function onAnimationFinished(animationName:String):Void
  {
    if (animationName.startsWith('holdCoverStart'))
    {
      playContinue();
    }
    if (animationName.startsWith('holdCoverEnd'))
    {
      // *lightning* *zap* *crackle*
      this.visible = false;
      this.kill();
    }
  }
}
