package cheknikot.controllers;

import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.ui.FlxButton;

/**
 * ...
 * @author ...
 */
class MobileMoving extends FlxGroup
{
	public var w_btn:FlxButton;
	public var a_btn:FlxButton;
	public var s_btn:FlxButton;
	public var d_btn:FlxButton;
	public var q_btn:FlxButton;
	public var e_btn:FlxButton;

	public function new(_asset:FlxGraphicAsset)
	{
		super();
		q_btn = new FlxButton(0, 0, null, onClick);
		w_btn = new FlxButton(0, 0, null, onClick);
		e_btn = new FlxButton(0, 0, null, onClick);
		a_btn = new FlxButton(0, 0, null, onClick);
		s_btn = new FlxButton(0, 0, null, onClick);
		d_btn = new FlxButton(0, 0, null, onClick);

		var _i:Int = 0;
		for (btn in [q_btn, w_btn, e_btn, a_btn, s_btn, d_btn])
		{
			btn.loadGraphic(_asset, true, 45, 45);
			add(btn);
			cast(btn, FlxButton).animation.add('q', [0]);
			cast(btn, FlxButton).animation.add('w', [1]);
			cast(btn, FlxButton).animation.add('e', [2]);
			cast(btn, FlxButton).animation.add('a', [3]);
			cast(btn, FlxButton).animation.add('s', [4]);
			cast(btn, FlxButton).animation.add('d', [5]);
			cast(btn, FlxButton).animation.add('1', [_i]);
			btn.statusAnimations = ['1', '1', '1'];
			btn.animation.play('1');
			_i++;
		}

		// q_btn.statusAnimations = ['1', '1', '1'];
		// q_btn.animation.play('1');
		// e_btn.statusAnimations = ['2', '2', '2'];
		// e_btn.animation.play('2');

		// a_btn.angle = -90;

		// d_btn.angle = 90;

		// s_btn.angle = 180;

		setting_positions();
	}

	public function setting_scale(_scale:Float = 1):Void
	{
		for (btn in [q_btn, w_btn, e_btn, a_btn, s_btn, d_btn])
		{
			btn.scale.set(_scale, _scale);
			btn.updateHitbox();
		}
		setting_positions(X, Y);
	}

	public var X:Float;
	public var Y:Float;

	public function setting_positions(_x:Float = 0, _y:Float = 0):Void
	{
		X = _x;
		Y = _y;
		var _dx:Float = (q_btn.frameWidth) * q_btn.scale.x + 1;
		trace('setting positions', _dx);
		w_btn.x = s_btn.x = _dx + X;
		e_btn.x = d_btn.x = _dx * 2 + X;
		a_btn.y = s_btn.y = d_btn.y = _dx + Y;

		a_btn.x = X;
		q_btn.x = X;

		w_btn.y = Y;
		q_btn.y = Y;
		e_btn.y = Y;
	}

	private function onClick():Void {}
}
