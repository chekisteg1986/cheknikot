package cheknikot.shaders;

import flixel.system.FlxAssets.FlxShader;
import openfl.display.Shader;
import openfl.display.ShaderParameter;

class LightingShader extends FlxShader
{
	// public static var SHADER:LightingShader = new LightingShader();
	@:glFragmentSource("
		#pragma header
       
        uniform float light;
        
		void main(void)
		{
			vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = vec4(color.r*light, color.g*light, color.b*light, color.a);
	}")
	public function new()
	{
		trace('CREATE SHADER');
		#if (openfl_legacy || nme)
		trace('Dynamic');
		#elseif FLX_DRAW_QUADS
		trace('flixel.graphics.tile.FlxGraphicsShader');
		#else
		trace('openfl.display.Shader');
		#end

		// this.data.maxRow.value = 6;

		this.data.light = new ShaderParameter<Float>();
		// this.data.light.value = 1.0;
		super();

		// var _p:ShaderParameter<Float> = new ShaderParameter<Float>();
		// _p.value = [1.0];
		// this.data.light = _p;
	}
}
