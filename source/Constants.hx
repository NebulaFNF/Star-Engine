package;

import flixel.system.FlxBasePreloader;
import flixel.util.FlxColor;
import lime.app.Application;

class Constants
{
	// MORE MIGHT BE ADDED LATER THIS IS JUST SOMETHING!!!!

	/**
	 * A suffix to add to the game version.
	 * Add a suffix to prototype builds and remove it for releases.
	 */
	public static final VERSION_SUFFIX:String = #if debug ' PROTOTYPE' #else '' #end;

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
