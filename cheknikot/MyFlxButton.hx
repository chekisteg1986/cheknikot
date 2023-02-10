package cheknikot;

import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author ...
 */
class MyFlxButton extends FlxButton
{
	public static var SIZE:Int = 20;

	public function new(X:Float = 0, Y:Float = 0, ?Text:Array<String>, ?OnClick:Void->Void, _fieldWidth:Int = 0, _new_graphic:Bool = true)
	{
		super(X, Y, AF.get_text(Text), OnClick);
		// loadGraphic(AssetPaths.mybutton__png, true, 100, 25);

		if (label != null)
		{
			label.setFormat(MyFlxText.FONT, SIZE, FlxColor.CYAN, CENTER);
			label.borderStyle = FlxTextBorderStyle.SHADOW;
			label.borderSize = 1;
			label.borderColor = FlxColor.BLACK;
			label.fieldWidth = _fieldWidth;
		}
		if (_new_graphic)
		{
			new_graphic = true;
			updateGraphic();
			// trace('BTN SIZE,', label.fieldWidth, SIZE);
		}

		updateHitbox();

		// trace(frameWidth, frameHeight);
	}

	private var new_graphic:Bool = false;

	public function updateGraphic():Void
	{
		makeGraphic(Math.ceil(label.fieldWidth + 1), SIZE * 2, FlxColor.GRAY);
		FlxSpriteUtil.drawRect(this, 1, 1, this.frameWidth - 2, this.frameHeight - 2, FlxColor.BLACK);
	}

	public function new_text(_arr:Array<String>):Void
	{
		label.fieldWidth = 0;
		text = AF.get_text(_arr);

		if (new_graphic)
			updateGraphic();
	}
}
