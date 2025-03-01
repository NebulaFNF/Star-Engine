package shaderslmfao;

import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import backend.FlxFixedShader;
import openfl.display.ShaderInput;
import flixel.FlxG;
import openfl.Lib;

import shaderslmfao.WiggleEffect.WiggleEffectType;
import shaderslmfao.WiggleEffect.WiggleShader;

/*typedef ShaderEffect = {
	var shader:Dynamic;
}*/

class Effect {
	public function setValue(shader:FlxShader, variable:String, value:Float) {
		Reflect.setProperty(Reflect.getProperty(shader, variable), 'value', [value]);
	}
}
