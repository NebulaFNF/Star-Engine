package;

import flixel.system.FlxBasePreloader;
import flixel.util.FlxColor;
import lime.app.Application;

class Constants {
   // MORE MIGHT BE ADDED LATER THIS IS JUST SOMETHING!!!!

   /**
   * A suffix to add to the game version.
   * Add a suffix to prototype builds and remove it for releases.
   */
   public static final VERSION_SUFFIX:String = #if debug ' PROTOTYPE' #else '' #end;

   public static function get_VERSION():String
   {
        return 'v${MainMenuState.psychEngineVersion}' + VERSION_SUFFIX;
   }
}