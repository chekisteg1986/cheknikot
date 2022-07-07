package cheknikot.controllers;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class MyJoystick2 extends FlxSpriteGroup
{
	public var pushed:Bool = false;
	public var backSpr:FlxSprite;
	public var joystick:FlxSprite;

	public var up:Bool = false;
	public var down:Bool = false;
	public var left:Bool = false;
	public var right:Bool = false;
	public var way_angle:Float = 0;
	public var way_speed:Float = 0;

	public function new(MaxSize:Int = 0)
	{
		super(MaxSize);
		backSpr = new FlxSprite();
		/*backSpr.loadGraphic(AssetPaths.joystick_back__png);*/
		joystick = new FlxSprite();
		/*joystick.loadGraphic(AssetPaths.center_arrow__png);*/

		joystick.offset.set(3, 3);

		add(backSpr);
		add(joystick);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var just_pressed:Bool = false;
		var pressed:Bool = false;
		var mouse_p:FlxPoint = null;
		#if !FLX_NO_MOUSE
		just_pressed = FlxG.mouse.justPressed;
		pressed = FlxG.mouse.pressed;
		mouse_p = FlxG.mouse.getScreenPosition();
		#else
		var touch:FlxTouch = FlxG.touches.getFirst();
		just_pressed = (FlxG.touches.justStarted().length > 0);
		pressed = (touch != null);
		if (touch != null)
			mouse_p = touch.getScreenPosition();
		#end

		backSpr.x = x;
		backSpr.y = y;
		joystick.x = x + 25;
		joystick.y = y + 25;

		if (just_pressed)
			#if !FLX_NO_MOUSE
			if (FlxG.mouse.overlaps(backSpr))
			#else
			if (touch.overlaps(backSpr))
			#end
		{
			pushed = true;
		}

		if (!pressed)
		{
			pushed = false;
		}

		up = down = left = right = false;
		if (pushed)
		{
			// var _center:Int = 25;
			// var d:Int = 5;

			// trace('mouse);

			mouse_p.x -= this.x;
			mouse_p.y -= this.y;

			if (mouse_p.x < 0)
				mouse_p.x = 0;
			if (mouse_p.x > 50)
				mouse_p.x = 50;
			if (mouse_p.y < 0)
				mouse_p.y = 0;
			if (mouse_p.y > 50)
				mouse_p.y = 50;

			joystick.x = x + mouse_p.x;
			joystick.y = y + mouse_p.y;

			if (mouse_p.x < 23)
				left = true;
			if (mouse_p.x > 27)
				right = true;
			if (mouse_p.y < 23)
				down = true;
			if (mouse_p.y > 27)
				up = true;

			way_angle = backSpr.getMidpoint().angleBetween(joystick.getMidpoint());
		}
	}
}
