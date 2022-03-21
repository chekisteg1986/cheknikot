package cheknikot.effects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class LoneParticle extends FlxSprite 
{

	public var lifetime:Float;
	public function new(?X:Float=0, ?Y:Float=0, _color:FlxColor,_lifetime:Float) 
	{
		super(X, Y);
		makeGraphic(1, 1, _color);
		MyGameObjectLayer.state.effects.add(this);
		lifetime = _lifetime;
		
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		lifetime -= elapsed;
		if (lifetime < 0)
		{
			//trace('REMOVE LONE PARTICLE');
			MyGameObjectLayer.state.effects.remove(this, true);
			this.kill();
		}
	}
	
}