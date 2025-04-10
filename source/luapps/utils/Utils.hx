package luapps.utils;

import flixel.FlxG;
import sys.FileSystem;

class Utils {
	public static function setDefaultResolution() {
		var resV = cast(Prefs.screenSize, String);
		
    	if (resV != null) {
			var parts = resV.split('x');
			var res:Array<Int> = [for (i in 0...2) Std.parseInt(parts[i])];
			
    		FlxG.resizeGame(res[0], res[1]);
			lime.app.Application.current.window.width = res[0];
			lime.app.Application.current.window.height = res[1];
    	}
	}

	public static function getDirectorySize(path:String):Float {
        var size:Float = 0;

        if (!FileSystem.exists(path)) return 0;

        for (item in FileSystem.readDirectory(path)) {
            var fullPath = path + "/" + item;
            if (FileSystem.isDirectory(fullPath)) size += getDirectorySize(fullPath); else {
                try {
                    size += FileSystem.stat(fullPath).size;
                } catch (e:Dynamic) trace('Failed to get size of $fullPath: $e');
            }
        }

        return size;
    }
}