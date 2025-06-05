package funkin.shaders;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;
import funkin.backend.shader.FlxFixedShader;
import funkin.shaders.Effect;
import funkin.shaders.WiggleEffect.WiggleEffectType;
import funkin.shaders.WiggleEffect.WiggleShader;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;

class ChromaticAberrationShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

		uniform float rOffset;
		uniform float gOffset;
		uniform float bOffset;

		void main()
		{
			vec4 col1 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(rOffset, 0.0));
			vec4 col2 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(gOffset, 0.0));
			vec4 col3 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(bOffset, 0.0));
			vec4 toUse = texture2D(bitmap, openfl_TextureCoordv);
			toUse.r = col1.r;
			toUse.g = col2.g;
			toUse.b = col3.b;
			//float someshit = col4.r + col4.g + col4.b;

			gl_FragColor = toUse;
		}')
	public function new()
	{
		super();
	}
}

class ChromaticAberrationEffect extends Effect
{
	public var shader:ChromaticAberrationShader;

	public function new(offset:Float = 0.00)
	{
		shader = new ChromaticAberrationShader();
		shader.rOffset.value = [offset];
		shader.gOffset.value = [0.0];
		shader.bOffset.value = [-offset];
	}

	public function setChrome(chromeOffset:Float):Void
	{
		shader.rOffset.value = [chromeOffset];
		shader.gOffset.value = [0.0];
		shader.bOffset.value = [chromeOffset * -1];
	}
}
