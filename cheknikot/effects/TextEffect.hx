package cheknikot.effects;

import flixel.group.FlxGroup;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class TextEffect extends FlxText
{
	private var group:FlxGroup;

	public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, _color:FlxColor = 0, _group:FlxGroup,
			duration:Float = 0.5, dy:Int = -30)
	{
		// trace(Text);

		super(X, Y, FieldWidth, Text, Size);

		this.color = _color;
		this.borderColor = FlxColor.BLACK;
		this.borderSize = 1;
		this.borderStyle = FlxTextBorderStyle.OUTLINE_FAST;
		FlxTween.tween(this, {alpha: 0, y: y + dy}, duration, {ease: FlxEase.circOut, onComplete: remove});

		group = _group;
		group.add(this);
	}

	public function remove(_):Void
	{
		group.remove(this, true);
		destroy();
		// trace('REMOVE');
	}
}
