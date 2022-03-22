package cheknikot.dungeoncrawler;

import cheknikot.quests_results.Quest;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class DC_GameObject
{
	public static var objects:Array<DC_GameObject> = new Array();

	public var line:Int = 0;
	public var visual_spr:FlxSprite;
	public var tile_x:Int;
	public var tile_y:Int;
	public var name:Array<String>;
	public var on_center:Bool = false;
	public var onClickFunc:DC_GameObject->Void = null;

	public function onClick():Void
	{
		if (name != null)
			Quest.clicked_on(this.name[0]);
		if (onClickFunc != null)
		{
			onClickFunc(this);
		}
	}

	public function new()
	{
		screen_3d = LocalGame.state.screen_3d;
		visual_spr = new FlxSprite();
		visual_spr.scrollFactor.set(0, 0);
	}

	public static var screen_3d:DC_screen;

	public function add_to_map():Void
	{
		objects.push(this);
		screen_3d.add_to_visible(this);
	}

	public function remove_from_map():Void
	{
		objects.remove(this);
		screen_3d.remove_from_visible(this);
	}

	public static function remove_objects_at(_x:Int, _y:Int):Void
	{
		var _n:Int = objects.length;
		while (--_n >= 0)
		{
			var go:DC_GameObject = objects[_n];

			if (go.tile_x == _x)
				if (go.tile_y == _y)
					go.remove_from_map();
		}
	}

	public static function get_objects_at(_x:Int, _y:Int):Array<DC_GameObject>
	{
		// var _res:Array<DC_GameObject> = new Array();
		return screen_3d.visible_map[_x + _y * LocalGame.state.walls.widthInTiles].copy();
		// for (go in screen_3d.visible_map[_x+_y*tiles_width])
		// if (go.tile_x == _x)
		// if (go.tile_y == _y)
		// {
		//	_res.push(go);
		// }
		// return _res;
	}

	public static function count_chars_side_at(_x:Int, _y:Int, _side:Int):Int
	{
		var _count:Int = 0;
		for (go in screen_3d.visible_map[_x + _y * LocalGame.state.walls.widthInTiles])
			if (Std.isOfType(go, Character))
				if (cast(go, Character).side == _side || _side == -1)
				{
					_count++;
				}
		return _count;
	}
}
