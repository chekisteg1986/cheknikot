package cheknikot;

import flixel.ui.FlxButton;
import flixel.util.FlxColor;

import flixel.text.FlxText.FlxTextBorderStyle;
/**
 * ...
 * @author ...
 */
class MyFlxButton extends FlxButton 
{
	
	
	public static var SIZE:Int = 14;

	public function new(X:Float=0, Y:Float=0, ?Text:Array<String>, ?OnClick:Void->Void) 
	{
		super(X, Y, AF.get_text(Text), OnClick);
		//loadGraphic(AssetPaths.mybutton__png, true, 100, 25);
		makeGraphic(100, 25, FlxColor.TRANSPARENT);
		//graphic.destroy();
		if (label != null)
		{
			
			label.setFormat(MyFlxText.FONT, SIZE, FlxColor.CYAN, CENTER);			
			label.borderStyle = FlxTextBorderStyle.SHADOW;
			label.borderSize = 1;
			//color =  FlxColor.WHITE;
			label.borderColor = FlxColor.BLACK;
			label.fieldWidth = 0;
			
			
			
			//label.fieldWidth = 0;
			
			//makeGraphic(label.frameWidth, label.frameWidth, FlxColor.GRAY);
			
		}
		
		//trace(frameWidth, frameHeight);
	}
	public function new_text(_arr:Array<String>):Void
	{
		text = AF.get_text(_arr);
	}
	
	
}