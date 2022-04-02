package cheknikot;

import flixel.text.FlxText;

// import flixel.addons.text.FlxTypeText;

/**
 * ...
 * @author ...
 */
class MyFlxText extends FlxText
{
	// public static var FONT:String = "assets/fonts/half_bold_pixel.ttf";
	public static var FONT:String = "assets/fonts/consolas.ttf";

	// public static var FONT:String = null;
	public static var default_size:Int = 20;

	public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, Text:Array<String> = null, Size:Int = -1)
	{
		if (Size == -1)
			Size = default_size;
		new_text(Text);

		super(X, Y, Math.floor(FieldWidth), text, Size, true);

		if (FONT != null)
			set_font(FONT);
		// borderStyle = FlxTextBorderStyle.OUTLINE;
		// borderSize = 1;
		// color =  FlxColor.WHITE;
		// borderColor = BORDER_COLOR;
	}

	public function change_text(s:String):Void
	{
		if (text != s)
			text = s;
	}

	public function new_text(_arr:Array<String>):Void
	{
		var _s:String = AF.get_text(_arr);
		if (_s != text)
			text = _s;
	}

	public function add_text(_arr:Array<String>):Void
	{
		var _str:String = '';
		if (GameParams.LANGUAGE < _arr.length)
			_str = _arr[GameParams.LANGUAGE];
		else if (_arr.length > 0)
			_str = _arr[0];
		text += _str;
	}
}
