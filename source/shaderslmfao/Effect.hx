package shaderslmfao;

import backend.FlxFixedShader;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import shaderslmfao.WiggleEffect.WiggleEffectType;
import shaderslmfao.WiggleEffect.WiggleShader;

class Effect
{
	public function setValue(shader:FlxShader, variable:String, value:Float)
	{
		Reflect.setProperty(Reflect.getProperty(shader, variable), 'value', [value]);
	}
}
