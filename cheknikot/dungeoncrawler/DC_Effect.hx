package cheknikot.dungeoncrawler;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

class DC_Effect extends FlxSprite
{
	public var group:FlxGroup;

	public var follow:DC_GameObject;

	public static var effects:Array<DC_Effect> = new Array();

	public var basic_scale:Float = 1;
	public var visual:FlxSprite;

	override public function new(_follow:DC_GameObject, _visual:FlxSprite = null)
	{
		super();
		follow = _follow;
		effects.push(this);
		if (_visual == null)
			_visual = _follow.visual_spr;
		visual = _visual;
	}

	public static function actions_all(_elapsed:Float):Void
	{
		var _n:Int = effects.length;
		while (--_n >= 0)
		{
			effects[_n].actions(_elapsed);
		}
	}

	override function loadGraphic(Graphic:FlxGraphicAsset, Animated:Bool = false, Width:Int = 0, Height:Int = 0, Unique:Bool = false, ?Key:String):FlxSprite
	{
		super.loadGraphic(Graphic, Animated, Width, Height, Unique, Key);

		animation.finishCallback = anim_ended;
		return this;
	}

	public function anim_ended(_):Void
	{
		remove();
	}

	public function actions(_elapsed:Float):Void
	{
		remove_from_group();

		trace(follow.on_screen);

		if (follow.on_screen)
		{
			var _position:FlxPoint = visual.getMidpoint();
			this.x = _position.x;
			this.y = _position.y;
			this.scale.set(follow.visual_spr.scale.x * basic_scale, follow.visual_spr.scale.y * basic_scale);
			offset.set(width / 2, height / 2);

			trace(x, y, scale.x);

			// updateHitbox();
			this.add_to_group(follow.current_state);
		}
		else
		{
			update(_elapsed);
		}
	}

	public function remove_from_group():Void
	{
		if (group != null)
			group.remove(this, true);
		group = null;
	}

	public function add_to_group(_group:FlxGroup):Void
	{
		group = _group;
		group.add(this);
	}

	public function remove():Void
	{
		if (group != null)
		{
			group.remove(this, true);
		}
		effects.remove(this);
	}
}
