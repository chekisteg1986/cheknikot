package cheknikot.dungeoncrawler;

import flixel.FlxG;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxRect;

/**
 * ...
 * @author ...
 */
class DC_quad
{
	public var uv:Array<Float> = [0, 0, 0, 0, 0, 0, 0, 0]; // 8
	public var vertices:Array<Float> = [0, 0, 0, 0, 0, 0, 0, 0]; // 8
	public var indexes:Array<Int> = [0, 1, 2, 1, 2, 3]; // 6
	public var quad_index:Int = -1;

	private var parent_row:DC_row;
	private var parent_screen:DC_screen;

	public var row:Int = -1;
	public var column:Int = -1;
	public var visible:Bool = true;

	private var tile:Int = -1;
	private var nesw:Int = -1;

	public function new() {}

	private var parent_row_uvtData:DrawData<Float>;
	private var parent_row_vertices:DrawData<Float>;
	private var tile_rectangles:Array<FlxRect>;

	public function update():Void
	{
		if (!visible)
			return;
		var _quad_index:Int = this.quad_index * 8;
		// var _in_index:Int = _quad_index * 4;
		// trace('update quad');
		// trace('add_quad',_quad_index, _in_index);

		var _n:Int = -1;
		while (++_n < 8)
		{
			parent_row_vertices[_quad_index + _n] = this.vertices[_n];
			// uvtData.push(_quad.uv[_n]);
		}
	}

	public function set_row(_r:DC_row):Void
	{
		parent_row = _r;
		parent_row_uvtData = parent_row.uvtData;
		parent_row_vertices = parent_row.vertices;
	}

	public function set_screen(_s:DC_screen):Void
	{
		parent_screen = _s;
		tile_rectangles = parent_screen.tile_rectangles;
	}

	public function set_texture(_t:Int, _nesw:Int = 0):Void
	{
		if (_t == tile && nesw == _nesw)
			return;
		// trace('set tile', _t);

		tile = _t;
		var _rect:FlxRect = tile_rectangles[_t];
		var _i:Int = quad_index * 8;

		var _left:Float = _rect.left;
		var _right:Float = _rect.right;
		var _top:Float = _rect.top;
		var _bottom:Float = _rect.bottom;
		nesw = _nesw;

		nesw = AF.NESW_border(nesw);

		var ROWS:Int = DC_sprite.ROWS;
		var COLUMNS:Int = DC_sprite.COLUMNS;
		var _w:Float = 0;
		var _h:Float = 0;
		var _buf:Int = 0;

		var _row:Int = row;
		var _column:Int = column;

		if (row == -1)
		{
			// trace('ROW -1 what is it???');
		}
		else
		{
			if (nesw == 1)
			{
				_w = (_right - _left) / ROWS;
				_h = (_bottom - _top) / COLUMNS;

				_row = ROWS - _row - 1;

				_left = _left + _w * _row;
				_top = _top + _h * _column;
				_right = _left + _w;
				_bottom = _top + _h;
			}
			else if (nesw == 3)
			{
				_w = (_right - _left) / ROWS;
				_h = (_bottom - _top) / COLUMNS;

				_column = COLUMNS - _column - 1;
				_left = _left + _w * _row;
				_top = _top + _h * _column;
				_right = _left + _w;
				_bottom = _top + _h;
			}
			else if (nesw == 2)
			{
				_w = (_right - _left) / COLUMNS;
				_h = (_bottom - _top) / ROWS;

				_column = COLUMNS - _column - 1;

				_row = ROWS - _row - 1;
				_left = _left + _w * _column;
				_top = _top + _h * _row;
				_right = _left + _w;
				_bottom = _top + _h;
			}
			else
			{
				_w = (_right - _left) / COLUMNS;
				_h = (_bottom - _top) / ROWS;

				_left = _left + _w * _column;
				_top = _top + _h * _row;
				_right = _left + _w;
				_bottom = _top + _h;
			}
		}

		switch (nesw)
		{
			case 0:
				uv[0] = parent_row_uvtData[_i] = _left;
				uv[1] = parent_row_uvtData[_i + 1] = _top;

				uv[2] = parent_row_uvtData[_i + 2] = _right;
				uv[3] = parent_row_uvtData[_i + 3] = _top;

				uv[4] = parent_row_uvtData[_i + 4] = _left;
				uv[5] = parent_row_uvtData[_i + 5] = _bottom;

				uv[6] = parent_row_uvtData[_i + 6] = _right;
				uv[7] = parent_row_uvtData[_i + 7] = _bottom;

			case 2:
				uv[0] = parent_row_uvtData[_i] = _right;
				uv[1] = parent_row_uvtData[_i + 1] = _bottom;

				uv[2] = parent_row_uvtData[_i + 2] = _left;
				uv[3] = parent_row_uvtData[_i + 3] = _bottom;

				uv[4] = parent_row_uvtData[_i + 4] = _right;
				uv[5] = parent_row_uvtData[_i + 5] = _top;

				uv[6] = parent_row_uvtData[_i + 6] = _left;
				uv[7] = parent_row_uvtData[_i + 7] = _top;

			case 1:
				uv[0] = parent_row_uvtData[_i] = _right;
				uv[1] = parent_row_uvtData[_i + 1] = _top;

				uv[2] = parent_row_uvtData[_i + 2] = _right;
				uv[3] = parent_row_uvtData[_i + 3] = _bottom;

				uv[4] = parent_row_uvtData[_i + 4] = _left;
				uv[5] = parent_row_uvtData[_i + 5] = _top;

				uv[6] = parent_row_uvtData[_i + 6] = _left;
				uv[7] = parent_row_uvtData[_i + 7] = _bottom;
			case 3:
				uv[0] = parent_row_uvtData[_i] = _left;
				uv[1] = parent_row_uvtData[_i + 1] = _bottom;

				uv[2] = parent_row_uvtData[_i + 2] = _left;
				uv[3] = parent_row_uvtData[_i + 3] = _top;

				uv[4] = parent_row_uvtData[_i + 4] = _right;
				uv[5] = parent_row_uvtData[_i + 5] = _bottom;

				uv[6] = parent_row_uvtData[_i + 6] = _right;
				uv[7] = parent_row_uvtData[_i + 7] = _top;
		}

		// trace('uv', uv);
		// trace('ver', vertices);
		// trace('in',indexes);
	}

	public function set_visible(_b:Bool):Void
	{
		if (_b == visible)
			return;

		if (_b)
		{
			var _i:Int = quad_index * 8;
			var _n:Int = -1;
			while (++_n < 8)
			{
				parent_row_vertices[_i + _n] = vertices[_n];
			}
			visible = true;
		}
		else
		{
			var _i:Int = quad_index * 8;

			var _n:Int = -1;
			while (++_n < 8)
			{
				parent_row_vertices[_i + _n] = 0;
			}
			visible = false;
		}
	}
}
