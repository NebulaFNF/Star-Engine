package luapps.utils;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Prefs {
	// Settings
	public static var luAppsType:String = "ALL";
	public static var antiAliasing:Bool = true;
	public static var lowDetail:Bool = false;
	public static var framerate:Int = 60;
	public static var screenSize:String = "1280x720";
	public static var shaders:Bool = true;

	public static var allowParticles:Bool = true;
	public static var showFPS:Bool = true;
	public static var notification:Bool = true;

	public static var restartByR:Bool = false;

	private static var flixelThings:Map<String, Array<String>> = [
		"saveBlackList" => ["keyBinds", "defaultKeys"],
		"flixelSound" =>   ["volume", "sound"],
		"loadBlackList" => ["keyBinds", "defaultKeys"],
	];

	public static function saveSettings() {
		for (field in Type.getClassFields(Prefs)) if (Type.typeof(Reflect.field(Prefs, field)) != TFunction && !flixelThings.get("saveBlackList").contains(field)) Reflect.setField(FlxG.save.data, field, Reflect.field(Prefs, field));
		for (flixelS in flixelThings.get("flixelSound")) Reflect.setField(FlxG.save.data, flixelS, Reflect.field(FlxG.sound, flixelS));

		FlxG.save.flush();
	}

	public static function loadPrefs() {
		for (field in Type.getClassFields(Prefs)) {
			if (Type.typeof(Reflect.field(Prefs, field)) != TFunction && !flixelThings.get("loadBlackList").contains(field)) {
				var defaultValue:Dynamic = Reflect.field(Prefs, field);
				var flxProp:Dynamic = Reflect.field(FlxG.save.data, field);
				Reflect.setField(Prefs, field, (flxProp != null ? flxProp : defaultValue));

				if (field == "showFPS" && Main.fpsVar != null) Main.fpsVar.visible = showFPS;

				if (field == "framerate") {
					FlxG.updateFramerate = framerate;
					FlxG.drawFramerate = framerate;
				}
			}
		}

		for (flixelS in flixelThings.get("flixelSound")) {
			var flxProp:Dynamic = Reflect.field(FlxG.save.data, flixelS);
			if (flxProp != null) Reflect.setField(FlxG.sound, flixelS, flxProp);
		}
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}