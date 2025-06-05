package funkin.shaders;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;
import funkin.backend.shader.FlxFixedShader;
import funkin.shaders.WiggleEffect.WiggleEffectType;
import funkin.shaders.WiggleEffect.WiggleShader;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;

class Effect
{
	public function setValue(shader:FlxShader, variable:String, value:Float)
	{
		Reflect.setProperty(Reflect.getProperty(shader, variable), 'value', [value]);
	}
}
