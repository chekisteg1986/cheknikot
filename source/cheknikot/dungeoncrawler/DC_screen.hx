package cheknikot.dungeoncrawler;

import cheknikot.dungeoncrawler.DC_GameObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxStrip;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author ...
 */
class DC_screen extends FlxGroup
{
	public static var screen_3d:DC_screen;

	public var tilemap:FlxTilemap;
	public var visible_objects:Array<DC_GameObject>;
	public var camera_position_x:Int = 0;
	public var camera_position_y:Int = 0;
	public var camera_face:Int = 0;

	public inline static var FACE_UP:Int = 0;
	public inline static var FACE_RIGHT:Int = 1;
	public inline static var FACE_DOWN:Int = 2;
	public inline static var FACE_LEFT:Int = 3;

	public var screen_width:Int;
	public var screen_height:Int;

	// public var DX:Float;
	// public var DY:Float;
	public var rows:Array<DC_row> = new Array();
	public var tile_rectangles:Array<FlxRect> = new Array();

	// public var floors:Array<Int> = new Array();
	// public var walls:Array<Int> = new Array();
	public var vision_radius:Int;
	public var step_scale:Float = 0.8;

	public var visible_map:Array<Array<DC_GameObject>> = new Array();

	public function refresh():Void
	{
		var _n:Int = visible_map.length;
		while (--_n >= 0)
			AF.clear_array(visible_map[_n]);

		// making size
		while (visible_map.length < tilemap.totalTiles)
		{
			var _arr:Array<DC_GameObject> = new Array();
			visible_map.push(_arr);
		}
		// complete
	}

	public function add_to_visible(_go:DC_GameObject):Void
	{
		visible_map[_go.tile_x + _go.tile_y * tilemap.widthInTiles].push(_go);
	}

	public function remove_from_visible(_go:DC_GameObject):Void
	{
		visible_map[_go.tile_x + _go.tile_y * tilemap.widthInTiles].remove(_go);
	}

	public function DX(_step:Int):Float
	{
		// return first_dx * _step;
		var _dx:Float = 0;
		var _add:Int = 0;
		while (++_add <= _step)
		{
			_dx += Math.pow(step_scale, _add - 1) * first_dx;
		}
		return _dx;
	}

	public function DY(_step:Int):Float
	{
		// return first_dy * _step;

		var _dy:Float = 0;
		var _add:Int = 0;
		while (++_add <= _step)
		{
			_dy += Math.pow(step_scale, _add - 1) * first_dy;
		}
		return _dy;
	}

	private var first_scale:Float;
	private var first_dx:Float;
	private var first_dy:Float;

	private var sprite_width:Float;
	private var sprite_height:Float;
	private var sprite_x:Float;
	private var sprite_y:Float;

	public function new(_vision_radius:Int = 3, _width:Int = 640, _height:Int = 480, _spr_w:Float = 0, _spr_h:Float = 0)
	{
		super();
		//

		screen_3d = this;
		vision_radius = _vision_radius;
		screen_width = _width;
		screen_height = _height;

		sprite_width = _spr_w;
		sprite_height = _spr_h;
		if (_spr_w == 0)
			sprite_width = _width;
		if (_spr_h == 0)
			sprite_height = _height;

		sprite_x = screen_width / 2 - sprite_width / 2;
		sprite_y = screen_height / 2 - sprite_height / 2;

		first_scale = 1 / (_vision_radius);

		first_dy = 0.5 * sprite_height * first_scale;
		first_dx = 0.5 * sprite_width * first_scale;
		trace('screen');
		trace(screen_width);
		trace(screen_height);
		trace('FIRST SPRITE w h');
		trace(sprite_width);
		trace(sprite_height);
		trace('FIRST SPRITE x y');
		trace(sprite_x);
		trace(sprite_y);
		trace('L R U D');
		trace(left(0, 0));
		trace(right(0, 0));
		trace(up(0));
		trace(down(0));

		var _cur_step:Int = _vision_radius + 1;

		while (_cur_step >= 0)
		{
			var _row:DC_row = new DC_row();
			rows.push(_row);
			add(_row);
			add(_row.sprites_on_screen);
			_row.parent = this;

			var _cur_side:Int = -_cur_step - 2;
			// var _width:Float = screen_width * (1 - _scale * _cur_step);
			var _line_sprites:Array<DC_sprite> = new Array();
			while (++_cur_side <= (_cur_step + 1))
			{
				// if (_cur_side == 0 && _cur_step == 0 ) continue;

				var _spr:DC_sprite = new DC_sprite(this, _row, _cur_step, _cur_side);
				_row.sprites.push(_spr);
				_line_sprites.push(_spr);
			}

			var _n:Int = -1;
			while (++_n < _line_sprites.length)
				if (_line_sprites[_n].floor != null)
					_row.add_quads(_line_sprites[_n].floor);

			_n = -1;
			while (++_n < _line_sprites.length)
				if (_line_sprites[_n].ceil != null)
					_row.add_quads(_line_sprites[_n].ceil);

			_n = -1;
			while (++_n < _line_sprites.length)
				if (_line_sprites[_n].side_wall != null)
					_row.add_quads(_line_sprites[_n].side_wall);

			_n = -1;
			while (++_n < _line_sprites.length)
				if (_line_sprites[_n].front_wall != null)
					_row.add_quad(_line_sprites[_n].front_wall);

			_cur_step--;
		}
	}

	public function rotate_left():Void
	{
		camera_face--;
		if (camera_face < 0)
			camera_face = 3;
		showed = false;
	}

	public function rotate_right():Void
	{
		camera_face++;
		if (camera_face > 3)
			camera_face = 0;
		showed = false;
	}

	public function right(_step:Int, _side:Int):Float
	{
		var _w:Float = sprite_width - 2 * DX(_step);
		return DX(_step) + (_side + 1) * _w + sprite_x;
	}

	public function left(_step:Int, _side:Int):Float
	{
		var _w:Float = sprite_width - 2 * DX(_step);
		return DX(_step) + _side * _w + sprite_x;
	}

	public function up(_step:Int):Float
	{
		return DY(_step) + sprite_y;
	}

	public function down(_step:Int):Float
	{
		var _h:Float = sprite_height - 2 * DY(_step);

		return DY(_step) + _h + sprite_y;
	}

	public function loadGraphic(_ass:FlxGraphicAsset):Void
	{
		for (r in rows)
			r.loadGraphic(_ass);
	}

	public function add_texture(_rect:FlxRect):Void
	{
		// screen_3d.loadGraphic(AssetPaths.floor_tileset_0__png);
		_rect.x = (_rect.x + 0.1) / rows[0].frameWidth;
		_rect.y = (_rect.y + 0.1) / rows[0].frameHeight;

		_rect.width = _rect.width / rows[0].frameWidth;
		_rect.height = (_rect.height - 0.5) / rows[0].frameHeight;

		if ((_rect.x + _rect.width) >= 1)
			_rect.width = 1 - _rect.x - 0.001;
		if ((_rect.y + _rect.height) >= 1)
			_rect.height = 1 - _rect.y - 0.001;

		tile_rectangles.push(_rect);
		#if debug
		FlxG.log.add('S: ' + _rect.left + ' ' + _rect.top + ' ' + _rect.right + ' ' + _rect.bottom);
		#end

		// trace('Add sprite', _rect.x, _rect.y, _rect.width, _rect.height,_rect.right, _rect.bottom,_rect.left,_rect.top);
	}

	public var sprites_complect:Array<DC_TextureComplect> = new Array();

	public function add_sprite(_floor:Int = 0, _wall:Int = 0, _side_wall:Int = 0, _ceil:Int = 0, _nesw_f:Bool = false, _r_f:Int = 0):DC_TextureComplect
	{
		var _n:Int = sprites_complect.length;
		var _complect:DC_TextureComplect = new DC_TextureComplect();

		_complect.floor = _floor;
		_complect.wall = _wall;
		_complect.side_wall = _side_wall;
		_complect.ceil = _ceil;

		_complect.nesw_floor = _nesw_f;
		_complect.rotate_floor = _r_f;

		sprites_complect.push(_complect);

		return _complect;
		// if (_floor > 0) floors.push(_n);
		// if (_wall > 0) walls.push(_n);
	}

	public function get_step_dx():Int
	{
		if (camera_face == FACE_RIGHT)
			return 1;
		if (camera_face == FACE_LEFT)
			return -1;
		return 0;
	}

	public function get_step_dy():Int
	{
		if (camera_face == FACE_DOWN)
			return 1;
		if (camera_face == FACE_UP)
			return -1;
		return 0;
	}

	public var showed:Bool = false;
	public var camera_point:FlxPoint = new FlxPoint();

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		// this.draw();
		// trace(camera_position_x,camera_position_y,showed,tilemap);
		if (showed)
			return;
		if (tilemap == null)
			return;
		showed = true;

		camera_point.x = camera_position_x * 16 + 8;
		camera_point.y = camera_position_y * 16 + 8;

		var _dx_per_step:Int = 0;
		var _dx_per_side:Int = 0;

		var _dy_per_step:Int = 0;
		var _dy_per_side:Int = 0;

		switch (camera_face)
		{
			case FACE_UP:
				_dx_per_side = 1;
				_dy_per_step = -1;

			case FACE_RIGHT:
				_dx_per_step = 1;
				_dy_per_side = 1;

			case FACE_DOWN:
				_dx_per_side = -1;
				_dy_per_step = 1;

			case FACE_LEFT:
				_dx_per_step = -1;
				_dy_per_side = -1;
		}

		// trace('CHECK');

		for (r in rows)
		{
			for (go in r.sprites_on_screen)
			{
				go.visible = false;
			}
			r.sprites_on_screen.clear();
		}

		for (r in rows)
		{
			r.update_sprites(_dx_per_step, _dx_per_side, _dy_per_step, _dy_per_side);
		}
	}
}
