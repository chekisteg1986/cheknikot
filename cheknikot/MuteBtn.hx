package cheknikot;

import flixel.FlxG;
import flixel.ui.FlxButton;

/**
 * ...
 * @author ...
 */
class MuteBtn extends FlxButton 
{

	public function new(X:Float=0, Y:Float=0) 
	{
		
		super(X, Y, '',click);
		loadGraphic(AssetPaths.mute__png,true,10,10);
		animation.add('0', [0]);
		animation.add('1', [1]);
		animation.play('0');
	}
	
	private var muted:Bool = false;
	private function click():Void
	{
		FlxG.sound.muted = !FlxG.sound.muted;
		
		
	}
	override public function update(elapsed:Float):Void 
	{
		if (muted != FlxG.sound.muted)
		{
			muted = FlxG.sound.muted;
			if (FlxG.sound.muted)
			{
				animation.play('1');
			}
			else
			{
				animation.play('0');
			}
		}
		
		super.update(elapsed);
	}
	
}