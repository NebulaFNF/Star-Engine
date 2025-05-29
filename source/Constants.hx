package;

import flixel.system.FlxBasePreloader;
import flixel.util.FlxColor;
import lime.app.Application;

class Constants
{
	// MORE MIGHT BE ADDED LATER THIS IS JUST SOMETHING!!!!

	/**
	 * Preloader sitelock.
	 * Matching is done by `FlxStringUtil.getDomain`, so any URL on the domain will work.
	 * The first link in this list is the one users will be redirected to if they try to access the game from a different URL.
	 */
	public static final SITE_LOCK:Array<String> = [
		"https://github.com/NebulaFNF/Star-Engine/releases", // GitHub, baybee!
		FlxBasePreloader.LOCAL // localhost for dev stuff
	];

	/**
	 * LANGUAGE
	 */
	// ==============================
	public static final SITE_LOCK_TITLE:String = "You Loser!";

	public static final SITE_LOCK_DESC:String = "Go play Star Engine on here:";

	/**
	 * The generatedBy string embedded in the chart files made by this application.
	 */
	public static var GENERATED_BY(get, never):String;

	static function get_GENERATED_BY():String
	{
		return '${Constants.TITLE} - ${Constants.VERSION}';
	}

	/**
	 * Color for the preloader background
	 */
	public static final COLOR_PRELOADER_BG:FlxColor = 0xFF000000;

	/**
	 * How long to continue the hold note animation after a note is pressed.
	 */
	public static final CONFIRM_HOLD_TIME:Float = 0.1;

	/**
	 * Color for the preloader progress bar
	 */
	public static final COLOR_PRELOADER_BAR:FlxColor = 0xFFA4FF11;

	/**
	 * Color for the preloader site lock background
	 */
	public static final COLOR_PRELOADER_LOCK_BG:FlxColor = 0xFF1B1717;

	/**
	 * Color for the preloader site lock foreground
	 */
	public static final COLOR_PRELOADER_LOCK_FG:FlxColor = 0xB96F10;

	/**
	 * The title of the game, for debug printing purposes.
	 * Change this if you're making an engine.
	 */
	public static final TITLE:String = "Friday Night Funkin': Star Engine";

	/**
	 * The current version number of the game.
	 * Modify this in the `project.hxp` file.
	 */
	public static var VERSION(get, never):String;

	/**
	 * Color for the preloader site lock text
	 */
	public static final COLOR_PRELOADER_LOCK_FONT:FlxColor = 0xCCCCCC;

	/**
	 * Color for the preloader site lock link
	 */
	public static final COLOR_PRELOADER_LOCK_LINK:FlxColor = 0xEEB211;

	/**
	 * A suffix to add to the game version.
	 * Add a suffix to prototype builds and remove it for releases.
	 */
	public static final VERSION_SUFFIX:String = #if debug ' PROTOTYPE' #else '' #end;

	/**
	 * The engine codename.
	 * Adds a suffix to prototype builds and remove it for releases.
	 */
	public static final CODENAME_SUFFIX:String = "Cloudy";

	/**
	 * Each step of the preloader has to be on screen at least this long.
	 *
	 * 0 = The preloader immediately moves to the next step when it's ready.
	 * 1 = The preloader waits for 1 second before moving to the next step.
	 *     The progress bare is automatically rescaled to match.
	 */
	public static final PRELOADER_MIN_STAGE_TIME:Float = 0.1;

	public function getGitCommit():String
	{
		// Cannibalized from GitCommit.hx
		var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
		if (process.exitCode() != 0)
		{
			var message = process.stderr.readAll().toString();
			trace('[ERROR] Could not determine current git commit; is this a proper Git repository?');
		}

		var commitHash:String = process.stdout.readLine();
		var commitHashSplice:String = commitHash.substr(0, 7);

		process.close();

		return commitHashSplice;
	}

	public function getGitBranch():String
	{
		// Cannibalized from GitCommit.hx
		var branchProcess = new sys.io.Process('git', ['rev-parse', '--abbrev-ref', 'HEAD']);

		if (branchProcess.exitCode() != 0)
		{
			var message = branchProcess.stderr.readAll().toString();
			trace('Could not determine current git branch; is this a proper Git repository?');
		}

		var branchName:String = branchProcess.stdout.readLine();

		branchProcess.close();

		return branchName;
	}

	public function getGitModified():Bool
	{
		var branchProcess = new sys.io.Process('git', ['status', '--porcelain']);

		if (branchProcess.exitCode() != 0)
		{
			var message = branchProcess.stderr.readAll().toString();
			trace('Could not determine current git status; is this a proper Git repository?');
		}

		var output:String = '';
		try
		{
			output = branchProcess.stdout.readLine();
		}
		catch (e)
		{
			if (e.message == 'Eof')
			{
				// Do nothing.
				// Eof = No output.
			}
			else
			{
				// Rethrow other exceptions.
				throw e;
			}
		}

		branchProcess.close();

		return output.length > 0;
	}

	/**
	 * Gets the engine version.
	 * @return String : Returns a string.
	 */
	public static function get_VERSION():String
	{
		return 'v${MainMenuState.psychEngineVersion}' + VERSION_SUFFIX;
	}
}
