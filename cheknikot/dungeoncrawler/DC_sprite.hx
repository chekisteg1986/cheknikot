package cheknikot.dungeoncrawler;

/**
 * ...
 * @author ...
 */
import cheknikot.dungeoncrawler.DC_GameObject;
import cpp.abi.Abi;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouse;
import flixel.math.FlxPoint;

class DC_sprite
{
	public var step:Int = 0;
	public var side:Int = 0;
	public var parent_screen:DC_screen;
	public var parent_row:DC_row;

	//
	public var w_left:Float;
	public var w_right:Float;
	public var w_up:Float;
	public var w_down:Float;
	public var floor_height:Float;
	public var scale_h:Float;

	public var side_wall:Array<DC_quad>;
	public var front_wall:DC_quad;
	public var floor:Array<DC_quad>;
	public var ceil:Array<DC_quad>;

	public static var ROWS:Int = 4;
	public static var COLUMNS:Int = 4;

	public function update_quads_for(_arr:Array<DC_quad>, _left_up:FlxPoint, _right_up:FlxPoint, _left_down:FlxPoint, _right_down:FlxPoint):Void
	{
		// trace('making floor', _left_up,_right_up,_left_down,_right_down);
		var _quad_n:Int = 0;

		var _r:Int = ROWS;
		while (--_r >= 0)
		{
			var _row_left:FlxPoint = new FlxPoint();
			_row_left.x = _left_up.x + _r * (_left_down.x - _left_up.x) / ROWS;
			_row_left.y = _left_up.y + _r * (_left_down.y - _left_up.y) / ROWS;

			var _row_right:FlxPoint = new FlxPoint();
			_row_right.x = _right_up.x + _r * (_right_down.x - _right_up.x) / ROWS;
			_row_right.y = _right_up.y + _r * (_right_down.y - _right_up.y) / ROWS;

			var _next_row_left:FlxPoint = new FlxPoint();
			_next_row_left.x = _left_up.x + (_r + 1) * (_left_down.x - _left_up.x) / ROWS;
			_next_row_left.y = _left_up.y + (_r + 1) * (_left_down.y - _left_up.y) / ROWS;

			var _next_row_right:FlxPoint = new FlxPoint();
			_next_row_right.x = _right_up.x + (_r + 1) * (_right_down.x - _right_up.x) / ROWS;
			_next_row_right.y = _right_up.y + (_r + 1) * (_right_down.y - _right_up.y) / ROWS;

			var _dx_up:Float = (_row_right.x - _row_left.x) / COLUMNS;
			var _dy_up:Float = (_row_right.y - _row_left.y) / COLUMNS;

			var _dx_down:Float = (_next_row_right.x - _next_row_left.x) / COLUMNS;
			var _dy_down:Float = (_next_row_right.y - _next_row_left.y) / COLUMNS;

			var _c:Int = COLUMNS;

			while (--_c >= 0)
			{
				var _q_left_up:FlxPoint = new FlxPoint();
				_q_left_up.x = _row_left.x + _dx_up * _c;
				_q_left_up.y = _row_left.y + _dy_up * _c;
				var _q_right_up:FlxPoint = new FlxPoint();

				_q_right_up.x = _row_left.x + _dx_up * (_c + 1);
				_q_right_up.y = _row_left.y + _dy_up * (_c + 1);

				var _q_left_down:FlxPoint = new FlxPoint();
				_q_left_down.x = _next_row_left.x + _dx_down * _c;
				_q_left_down.y = _next_row_left.y + _dy_down * _c;
				var _q_right_down:FlxPoint = new FlxPoint();
				_q_right_down.x = _next_row_left.x + _dx_down * (_c + 1);
				_q_right_down.y = _next_row_left.y + _dy_down * (_c + 1);

				var _quad:DC_quad = _arr[_quad_n];
				_quad_n++;
				_quad.row = _r;
				_quad.column = _c;
				// lu
				_quad.vertices[0] = _q_left_up.x;
				_quad.vertices[1] = _q_left_up.y;
				// ru
				_quad.vertices[2] = _q_right_up.x;
				_quad.vertices[3] = _q_right_up.y;
				// ld
				_quad.vertices[4] = _q_left_down.x;
				_quad.vertices[5] = _q_left_down.y;
				// rd
				_quad.vertices[6] = _q_right_down.x;
				_quad.vertices[7] = _q_right_down.y;

				// trace('result floor', _q_left_up,_q_right_up,_q_left_down,_q_right_down);

				// _arr.push(_quad);
			}
		}
	}

	public function update(_dx_per_step:Int, _dy_per_step:Int, _dx_per_side:Int, _dy_per_side:Int):Void
	{
		var _x:Int = parent_screen.camera_position_x + step * _dx_per_step + side * _dx_per_side;
		var _y:Int = parent_screen.camera_position_y + step * _dy_per_step + side * _dy_per_side;

		var _show_objects:Bool = true;

		if (_x < 0 || _y < 0 || _x >= parent_screen.tilemap.widthInTiles || _y >= parent_screen.tilemap.heightInTiles)
		{
			if (ceil != null)
				for (s in ceil)
					s.set_visible(false);
			if (floor != null)
				for (s in floor)
					s.set_visible(false);
			if (front_wall != null)
				front_wall.set_visible(false);
			if (side_wall != null)
				for (s in side_wall)
					s.set_visible(false);

			_show_objects = false;
		}
		else
		{
			var _t:Int = parent_screen.tilemap.getTile(_x, _y);
			set_tile(_t);
			if (parent_screen.sprites_complect[_t].floor == 0)
				_show_objects = false;
		}

		var _n:Int = sprite_objects.length;
		while (--_n >= 0)
		{
			sprite_objects.splice(_n, 1);
		}

		// AF.clear_array(sprite_objects);

		// var _visible_objects:Array<DC_GameObject> = parent_screen.visible_objects;

		var _visible_objects:Array<DC_GameObject> = parent_screen.visible_map[_x + _y * parent_screen.tilemap.widthInTiles];

		var _obj:DC_GameObject = null;
		var _spr:FlxSprite = null;

		if (_show_objects)
			if (_visible_objects != null)
			{
				_n = _visible_objects.length;
				while (--_n >= 0)
					sprite_objects.push(_visible_objects[_n]);

				// check lines
				/*
					var _line:Int = 5;
					while (--_line >= 0)
					{
						var _sprites_in_line:Array<Dynamic> = AF.get_objects_with(sprite_objects, 'line', _line);
						put_in_row(_sprites_in_line, _line * 20);
					}
				 */
				//

				DC_SpriteOutputType.show_visible_objects_dxdy(sprite_objects, this);
			}
	}

	public function check_click_on_sprites():DC_GameObject
	{
		var _n:Int = sprite_objects.length;
		while (--_n >= 0)
		{
			var obj:DC_GameObject = sprite_objects[_n];
			obj.visual_spr.updateHitbox();
			if (FlxG.mouse.getPosition().inRect(obj.visual_spr.getHitbox()))
			{
				return sprite_objects[_n];
			}
		}
		return null;
	}

	/*public function set_floor_tile(_t:Int):Void
		{
			var _floor:Int = parent_screen.sprites_complect[_t][0];		
			for (s in floor)
			{
				s.set_texture(_floor);
			}
		}
		public function set_side_tile(_t:Int):Void
		{
			var _side_wall:Int = parent_screen.sprites_complect[_t][2];
			for (s in side_wall)
			{
				s.set_texture(_side_wall);
			}
	}*/
	public var sprite_objects:Array<DC_GameObject> = new Array();

	public var next_left:Float;
	public var next_right:Float;
	public var next_up:Float;
	public var next_down:Float;
	public var next_scale_h:Float;

	public function get_center(_dy:Float):Float
	{
		var _front_center:Float = (w_right + w_left) / 2;
		var _back_center:Float = (next_right + next_left) / 2;

		return _front_center - _dy * (_front_center - _back_center);
	}

	public function get_left(_dy:Float):Float
	{
		return w_left - _dy * (w_left - next_left);
	}

	public function get_right(_dy:Float):Float
	{
		return w_right - _dy * (w_right - next_right);
	}

	public function new(_parent_s:DC_screen, _parent_r:DC_row, _step:Int, _side:Int)
	{
		step = _step;
		side = _side;
		parent_screen = _parent_s;
		parent_row = _parent_r;

		w_left = parent_screen.left(step, side);
		w_right = parent_screen.right(step, side);
		w_up = parent_screen.up(step);
		w_down = parent_screen.down(step);

		next_left = parent_screen.left(step + 1, side);
		next_right = parent_screen.right(step + 1, side);
		next_up = parent_screen.up(step + 1);
		next_down = parent_screen.down(step + 1);

		scale_h = (w_down - w_up) / parent_screen.screen_height;
		next_scale_h = (next_down - next_up) / parent_screen.screen_height;

		// trace('Sprite',step,side);

		if (side != 0 && (step != (parent_screen.vision_radius + 1)))
		{
			if (side < 0)
			{
				// side_wall = new DC_quad();
				side_wall = new Array();
				make_quads_for(side_wall);
			}
			else
			{
				side_wall = new Array();
				make_quads_for(side_wall);
			}
		}

		if (Math.abs(side) <= (step + 1))
		{
			front_wall = new DC_quad();
		}

		if (step != (parent_screen.vision_radius + 1))
		{
			floor = new Array();
			make_quads_for(floor);

			ceil = new Array();
			make_quads_for(ceil);
		}

		update_coordinates();
		// floor = null;
		// side_wall = null;
		// front_wall = null;
	}

	public function make_quads_for(_arr:Array<DC_quad>):Void
	{
		var _r:Int = ROWS;
		while (--_r >= 0)
		{
			var _c:Int = COLUMNS;

			while (--_c >= 0)
			{
				_arr.push(new DC_quad());
			}
		}
	}

	public function update_coordinates():Void
	{
		var lu:FlxPoint;
		var ru:FlxPoint;
		var ld:FlxPoint;
		var rd:FlxPoint;
		if (side_wall != null)
			if (side < 0)
			{
				// left up
				lu = new FlxPoint(parent_screen.right(step, side), parent_screen.up(step));
				// right up
				ru = new FlxPoint(parent_screen.right(step + 1, side), parent_screen.up(step + 1));
				// down left
				ld = new FlxPoint(parent_screen.right(step, side), parent_screen.down(step));
				// down right
				rd = new FlxPoint(parent_screen.right(step + 1, side), parent_screen.down(step + 1));
				update_quads_for(side_wall, lu, ru, ld, rd);
			}
			else
			{
				// left up
				lu = new FlxPoint(parent_screen.left(step + 1, side), parent_screen.up(step + 1));
				// right up
				ru = new FlxPoint(parent_screen.left(step, side), parent_screen.up(step));
				// down left
				ld = new FlxPoint(parent_screen.left(step + 1, side), parent_screen.down(step + 1));
				// down right
				rd = new FlxPoint(parent_screen.left(step, side), parent_screen.down(step));
				update_quads_for(side_wall, lu, ru, ld, rd);
			}

		if (front_wall != null)
		{
			// left up
			front_wall.vertices[0] = parent_screen.left(step, side);
			front_wall.vertices[1] = parent_screen.up(step);
			// right up
			front_wall.vertices[2] = parent_screen.right(step, side);
			front_wall.vertices[3] = parent_screen.up(step);
			// down left
			front_wall.vertices[4] = parent_screen.left(step, side);
			front_wall.vertices[5] = parent_screen.down(step);
			// down right
			front_wall.vertices[6] = parent_screen.right(step, side);
			front_wall.vertices[7] = parent_screen.down(step);
		}
		if (floor != null)
		{
			// left up
			lu = new FlxPoint(parent_screen.left(step + 1, side), parent_screen.down(step + 1));
			// right up
			ru = new FlxPoint(parent_screen.right(step + 1, side), parent_screen.down(step + 1));
			// down left
			ld = new FlxPoint(parent_screen.left(step, side), parent_screen.down(step));
			// down right
			rd = new FlxPoint(parent_screen.right(step, side), parent_screen.down(step));
			update_quads_for(floor, lu, ru, ld, rd);
		}
		if (ceil != null)
		{
			lu = new FlxPoint(parent_screen.left(step, side), parent_screen.up(step));
			// right up
			ru = new FlxPoint(parent_screen.right(step, side), parent_screen.up(step));
			// down left
			ld = new FlxPoint(parent_screen.left(step + 1, side), parent_screen.up(step + 1));
			// down right
			rd = new FlxPoint(parent_screen.right(step + 1, side), parent_screen.up(step + 1));
			update_quads_for(ceil, lu, ru, ld, rd);
		}
	}

	public function set_visible(_walls:Bool, _floor:Bool):Void
	{
		// trace('visible', step, side, _walls, _floor);
		if (front_wall != null)
		{
			front_wall.set_visible(_walls);
		}
		if (side_wall != null)
		{
			set_side_visible(_walls);
		}
		if (floor != null)
		{
			for (spr in floor)
				spr.set_visible(_floor);
		}
	}

	public function set_side_visible(_b:Bool):Void
	{
		for (spr in side_wall)
			spr.set_visible(_b);
	}

	private var current_tile:Int = -1;

	public function set_tile(_t:Int):Void
	{
		// if (current_tile == _t) return;
		current_tile = _t;
		var _complect:DC_TextureComplect = parent_screen.sprites_complect[_t];
		// trace('set tile', step, side, _t);

		if (floor != null)
		{
			var _floor:Int = _complect.floor;
			var _rotate:Int = _complect.rotate_floor;
			if (_complect.nesw_floor)
				_rotate += parent_screen.camera_face;

			if (_floor > 0)
			{
				for (quad in floor)
				{
					quad.set_texture(_floor, _rotate);
					quad.set_visible(true);
				}
			}
			else
			{
				for (quad in floor)
					quad.set_visible(false);
			}
		}

		if (ceil != null)
		{
			var _ceil:Int = _complect.ceil;
			var _rotate:Int = _complect.rotate_ceil;
			if (_complect.nesw_ceil)
				_rotate += parent_screen.camera_face;

			if (_ceil > 0)
			{
				for (quad in ceil)
				{
					quad.set_texture(_ceil, _rotate);
					quad.set_visible(true);
				}
			}
			else
			{
				for (quad in ceil)
					quad.set_visible(false);
			}
		}

		if (front_wall != null)
		{
			var _wall:Int = _complect.wall;
			if (_wall > 0)
			{
				front_wall.set_texture(_wall);
				front_wall.set_visible(true);
			}
			else
			{
				front_wall.set_visible(false);
			}
		}

		if (side_wall != null)
		{
			var _side:Int = _complect.side_wall;
			if (_side > 0)
			{
				for (quad in side_wall)
				{
					quad.set_texture(_side);
					quad.set_visible(true);
				}
			}
			else
			{
				for (quad in side_wall)
					quad.set_visible(false);
			}
		}
	}

	// public function set_tile_arr(_t:Int):Void
	// {
	//
	// }
}
