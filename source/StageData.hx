package;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end
import haxe.Json;
import Song;

using StringTools;

typedef StageFile = {
	var directory:String;
	var defaultZoom:Float;
	var isPixelStage:Bool;

	var boyfriend:Array<Dynamic>;
	var girlfriend:Array<Dynamic>;
	var opponent:Array<Dynamic>;
	var hide_girlfriend:Bool;

	var camera_boyfriend:Array<Float>;
	var camera_opponent:Array<Float>;
	var camera_girlfriend:Array<Float>;
	var camera_speed:Null<Float>;
}

class StageData {
	public static var forceNextDirectory:String = null;
	public static var instance:StageData;

	var characters:Map<String, Character> = new Map<String, Character>();
	public static function loadDirectory(SONG:SwagSong) {
		var stage:String = '';
		if(SONG.stage != null) {
			stage = SONG.stage;
		} else if(SONG.song != null) {
			switch (SONG.song.toLowerCase().replace(' ', '-'))
			{
				case 'spookeez' | 'south' | 'monster':
					stage = 'spooky';
				case 'pico' | 'blammed' | 'philly' | 'philly-nice':
					stage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					stage = 'limo';
				case 'cocoa' | 'eggnog':
					stage = 'mall';
				case 'winter-horrorland':
					stage = 'mallEvil';
				case 'senpai' | 'roses':
					stage = 'school';
				case 'thorns':
					stage = 'schoolEvil';
				case 'ugh' | 'guns' | 'stress':
					stage = 'tank';
				case 'darnell' | 'lit-up' | '2hot':
					stage = 'phillyStreets';
				default:
					stage = 'stage';
			}
		} else {
			stage = 'stage';
		}

		var stageFile:StageFile = getStageFile(stage);
		if(stageFile == null) { //preventing crashes
			forceNextDirectory = '';
		} else {
			forceNextDirectory = stageFile.directory;
		}
	}

	public static function getStageFile(stage:String):StageFile {
		var rawJson:String = null;
		var path:String = Paths.getPreloadPath('stages/' + stage + '.json');

		#if MODS_ALLOWED
		var modPath:String = Paths.modFolders('stages/' + stage + '.json');
		if(FileSystem.exists(modPath)) {
			rawJson = File.getContent(modPath);
		} else if(FileSystem.exists(path)) {
			rawJson = File.getContent(path);
		}
		#else
		if(Assets.exists(path)) {
			rawJson = Assets.getText(path);
		}
		#end
		else
		{
			return null;
		}
		return cast Json.parse(rawJson);
	}

	/**
   * Retrieves a given character from the stage.
   */
   /*public function getCharacter(id:String):Character
	{
	  return this.characters.get(id);
	}
  
	/**
	 * Retrieve the Boyfriend character.
	 * @param pop If true, the character will be removed from the stage as well.
	 * @return The Boyfriend character.
	public function getBoyfriend(pop:Bool = false):Character
	{
	  if (pop)
	  {
		var boyfriend:Character = getCharacter('bf');
  
		// Remove the character from the stage.
		this.remove(boyfriend);
		this.characters.remove('bf');
  
		return boyfriend;
	  }
	  else
	  {
		return getCharacter('bf');
	  }
	}
  
	/**
	 * Retrieve the player/Boyfriend character.
	 * @param pop If true, the character will be removed from the stage as well.
	 * @return The player/Boyfriend character.
	public function getPlayer(pop:Bool = false):Character
	{
	  return getBoyfriend(pop);
	}
  
	/**
	 * Retrieve the Girlfriend character.
	 * @param pop If true, the character will be removed from the stage as well.
	 * @return The Girlfriend character.
	public function getGirlfriend(pop:Bool = false):Character
	{
	  if (pop)
	  {
		var girlfriend:Character = getCharacter('gf');
  
		// Remove the character from the stage.
		this.remove(girlfriend);
		this.characters.remove('gf');
  
		return girlfriend;
	  }
	  else
	  {
		return getCharacter('gf');
	  }
	}
  
	/**
	 * Retrieve the Dad character.
	 * @param pop If true, the character will be removed from the stage as well.
	 * @return The Dad character.
	public function getDad(pop:Bool = false):Character
	{
	  if (pop)
	  {
		var dad:Character = getCharacter('dad');
  
		// Remove the character from the stage.
		this.remove(dad);
		this.characters.remove('dad');
  
		return dad;
	  }
	  else
	  {
		return getCharacter('dad');
	  }
	}
  
	/**
	 * Retrieve the opponent/Dad character.
	 * @param pop If true, the character will be removed from the stage as well.
	 * @return The opponent character.
	public function getOpponent(pop:Bool = false):Character
	{
	  return getDad(pop);
	}*/
}