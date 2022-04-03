package cheknikot.menus;

import flash.net.URLRequest;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.ui.FlxButton;

/**
 * ...
 * @author ...
 */
class LinkButton extends FlxButton
{
	public var link:String = null;

	public function new(X:Float = 0, Y:Float = 0, ?_asset:FlxGraphicAsset, ?_link:String)
	{
		super(X, Y, null, OnClick);
		loadGraphic(_asset);
		link = _link;
	}

	public function OnClick():Void
	{
		flash.Lib.getURL(new URLRequest(link));
	}
}
