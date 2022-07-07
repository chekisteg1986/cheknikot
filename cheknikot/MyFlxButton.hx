package cheknikot;

import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class MyFlxButton extends FlxButton
{
	public static var SIZE:Int = 20;

	public function new(X:Float = 0, Y:Float = 0, ?Text:Array<String>, ?OnClick:Void->Void, _new_graphic:Bool = true)
	{
		super(X, Y, AF.get_text(Text), OnClick);
		// loadGraphic(AssetPaths.mybutton__png, true, 100, 25);
		if (_new_graphic)
		{
			trace('BTN SIZE,', label.fieldWidth, SIZE);
			makeGraphic(Math.ceil(label.fieldWidth * 2), SIZE * 2, FlxColor.BLACK);
		}

		if (label != null)
		{
			label.setFormat(MyFlxText.FONT, SIZE, FlxColor.CYAN, CENTER);
			label.borderStyle = FlxTextBorderStyle.SHADOW;
			label.borderSize = 1;
			label.borderColor = FlxColor.BLACK;

			label.fieldWidth = 0;
		}
		updateHitbox();

		// trace(frameWidth, frameHeight);
	}

	public function new_text(_arr:Array<String>):Void
	{
		text = AF.get_text(_arr);
	}
}
