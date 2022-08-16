package cheknikot.controllers;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
// import flixel.FlxSprite;
#if !android
import flixel.input.touch.FlxTouch;
#end

/**
 * ...
 * @author ...
 */
class MouseBase
{
	public static var left_click:Bool = false;
	public static var right_click:Bool = false;
	public static var click_point:FlxPoint = null;

	public static function click_overlaps_gui(_gui:FlxGroup):Bool
	{
		if (FlxG.mouse.overlaps(_gui))
			return true;
		return false;
	}

	public static function mouse_actions(_gui:FlxGroup):Void
	{
		// var click_point:FlxPoint = null;
		// var clicked:Bool = false;

		left_click = false;
		right_click = false;
		click_point = null;

		if (_gui != null)
			if (click_overlaps_gui(_gui))
				return;

		#if !android
		click_point = FlxG.mouse.getWorldPosition(FlxG.camera);
		right_click = FlxG.mouse.justPressedRight;
		left_click = FlxG.mouse.justPressed;
		#else
		var t:FlxTouch;
		// show_location_name('touches '+FlxG.touches.list.length);
		for (t in FlxG.touches.list)
		{
			if (t.justPressed)
			{
				click_point = t.getWorldPosition(FlxG.camera);
				// PlayState.emitter_explode_pt(t.getScreenPosition());
				clicked = true;
			}
		}
		#end

		#if !FLX_NO_MOUSE
		if (FlxG.mouse.justPressedRight)
		{
			right_click = true;
		}
		#end
	}
}
