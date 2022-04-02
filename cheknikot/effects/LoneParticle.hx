package cheknikot.effects;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class LoneParticle extends FlxSprite
{
	public static var state:FlxGroup;

	public var lifetime:Float;

	public function new(?X:Float = 0, ?Y:Float = 0, _color:FlxColor, _lifetime:Float, _size:Int = 1)
	{
		super(X, Y);
		makeGraphic(_size, _size, _color);
		state.add(this);
		lifetime = _lifetime;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		lifetime -= elapsed;
		if (lifetime < 0)
		{
			// trace('REMOVE LONE PARTICLE');
			state.remove(this, true);
			this.kill();
		}
	}
}
