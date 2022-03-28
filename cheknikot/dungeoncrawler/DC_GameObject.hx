package cheknikot.dungeoncrawler;

import cheknikot.quests_results.Quest;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;

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

	public var tile_dx:Float = 0;
	public var tile_dy:Float = 0;

	public var NESW_facing:Int = 0;

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
		screen_3d = DC_screen.screen_3d;
		visual_spr = new FlxSprite();
		visual_spr.scrollFactor.set(0, 0);
	}

	public static var screen_3d:DC_screen;

	public function add_to_map():Void
	{
		objects.push(this);
		screen_3d.add_to_visible(this);
		walls = DC_screen.screen_3d.tilemap;
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

	private var walls:FlxTilemap;

	public function step_forward(_face:Int = -1):Bool
	{
		if (_face == -1)
			_face = NESW_facing;
		if (_face > 3)
			_face -= 4;

		var _dx:Int = AF.get_step_dx(_face);
		var _dy:Int = AF.get_step_dy(_face);
		// trace('dxdy', _dx,_dy);

		var _new_x:Int = this.tile_x + _dx;
		var _new_y:Int = this.tile_y + _dy;

		var _walls:FlxTilemap = walls;

		if (_new_x >= 0 && _new_x < _walls.widthInTiles)
			if (_new_y >= 0 && _new_y < _walls.heightInTiles)
			{
				if (_walls.getTileCollisions(_walls.getTile(_new_x, _new_y)) != FlxObject.NONE)
				{
					trace('block', _walls.getTile(_new_x, _new_y));
					return false;
				}

				screen_3d.remove_from_visible(this);
				this.tile_x = _new_x;
				this.tile_y = _new_y;
				screen_3d.add_to_visible(this);
				return true;
			}
		return false;
	}

	public static function get_objects_at(_x:Int, _y:Int):Array<DC_GameObject>
	{
		return screen_3d.visible_map[_x + _y * DC_screen.screen_3d.tilemap.widthInTiles].copy();
	}
	/*public static function count_chars_side_at(_x:Int, _y:Int, _side:Int):Int
		{
			var _count:Int = 0;
			for (go in screen_3d.visible_map[_x + _y * LocalGame.state.walls.widthInTiles])
				if (Std.isOfType(go, Character))
					if (cast(go, Character).side == _side || _side == -1)
					{
						_count++;
					}
			return _count;
	}*/
}
