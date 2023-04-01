package cheknikot.dungeoncrawler;

import cheknikot.dungeoncrawler.DC_GameObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxStrip;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class DC_screen extends FlxGroup
{
	public static var screen_3d:DC_screen;

	// public var sprite_output_type:DC_SpriteOutputType = DC_SpriteOutputType.LINE;
	public var tilemap:FlxTilemap;
	public var visible_objects:Array<DC_GameObject>;

	public var clickOnStep1:Void->Void;

	public var camera_position_x:Int = 0;
	public var camera_position_y:Int = 0;

	public var camera_position_dx:Float = 0;
	public var camera_position_dy:Float = 0;
	public var last_camera_d_step:Float = 0;
	public var last_camera_d_side:Float = 0;

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

	// public var first_sprite_height:Float=0;
	public var visible_map:Array<Array<DC_GameObject>> = new Array();

	public var left_dark:FlxSprite = new FlxSprite();
	public var right_dark:FlxSprite = new FlxSprite();

	public var ceil_and_floor:DC_row = new DC_row();

	// public var floors:DC_row = new DC_row();

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
		if (_go.visible)
		{
			// trace(_go.tile_x, _go.tile_y);
			// trace(tilemap.widthInTiles);
			var _i:Int = _go.tile_x + _go.tile_y * tilemap.widthInTiles;
			// if (visible_map[_i] == null)
			//	visible_map[_i] = new Array();
			visible_map[_i].push(_go);
		}
	}

	public function remove_from_visible(_go:DC_GameObject):Void
	{
		visible_map[_go.tile_x + _go.tile_y * tilemap.widthInTiles].remove(_go);
	}

	/*public function DX(_step:Float):Float
		{
			return first_dx * (Math.pow(step_scale, _step) - 1) / Math.log(step_scale);
	}*/
	public function get_scale(_step:Float):Float
	{
		return Math.pow(step_scale, _step);
	}

	/*public function DY(_step:Float):Float
		{
			// scale(_step) =  Math.pow(step_scale, _step)
			// Integral(scale) =  Math.pow(step_scale, _step) / Math.log(step_scale)

			return first_dy * (Math.pow(step_scale, _step) - 1) / Math.log(step_scale);
	}*/
	private var first_scale:Float;

	// private var first_dx:Float;
	// public var first_dy:Float;
	public var sprite_width:Float;
	public var sprite_height:Float;

	/**

	**/
	private var sprite_x:Float;

	private var sprite_y:Float;

	public function new(_vision_radius:Int = 3, _width:Int = 640, _height:Int = 480, _spr_w:Float = 0, _spr_h:Float = 0, _scale:Float = -1)
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

		if (_scale == -1)
			first_scale = 1 / (_vision_radius);
		else
			first_scale = _scale;

		//	first_dy = 0.5 * sprite_height * first_scale;
		//	first_dx = 0.5 * sprite_width * first_scale;
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

		// Making rows

		add(ceil_and_floor);
		ceil_and_floor.show_objects = false;
		ceil_and_floor.parent = this;
		rows.push(ceil_and_floor);
		var _cur_step:Int = _vision_radius + 1;
		while (_cur_step >= 0)
		{
			var _row:DC_row = new DC_row();
			rows.push(_row);
			// Adding row to screen
			add(_row);
			_row.parent = this;
			var _cur_side:Int = -_cur_step - 2;
			var _line_sprites:Array<DC_sprite> = new Array();
			while (++_cur_side <= (_cur_step + 1))
			{
				var _spr:DC_sprite = new DC_sprite(this, _row, _cur_step, _cur_side);
				_row.sprites.push(_spr);
				_line_sprites.push(_spr);
			}

			// at first, we adding floor
			var _n:Int = -1;
			while (++_n < _line_sprites.length)
				if (_line_sprites[_n].floor != null)
					ceil_and_floor.add_quads(_line_sprites[_n].floor);
			// ceil
			_n = -1;
			while (++_n < _line_sprites.length)
				if (_line_sprites[_n].ceil != null)
					ceil_and_floor.add_quads(_line_sprites[_n].ceil);
			// side walls
			_n = -1;
			while (++_n < _line_sprites.length)
				if (_line_sprites[_n].side_wall != null)
					_row.add_quads(_line_sprites[_n].side_wall);
			// front wall
			_n = -1;
			while (++_n < _line_sprites.length)
				if (_line_sprites[_n].front_wall != null)
					_row.add_quad(_line_sprites[_n].front_wall);

			// Adding row visible group for objects/sprites
			add(_row.sprites_on_screen);
			_cur_step--;
		}

		// side wall on step == -1 , side +-1
		if (true)
		{
			var _row:DC_row = new DC_row();
			rows.push(_row);
			// Adding row to screen
			add(_row);
			_row.parent = this;
			back_left_spr = new DC_sprite(this, _row, -1, -1);
			_row.sprites.push(back_left_spr);
			back_left_spr.front_wall = null;
			back_left_spr.ceil = back_left_spr.floor = null;
			_row.add_quads(back_left_spr.side_wall);
			back_right_spr = new DC_sprite(this, _row, -1, 1);
			_row.sprites.push(back_right_spr);
			back_right_spr.front_wall = null;
			back_right_spr.ceil = back_right_spr.floor = null;
			_row.add_quads(back_right_spr.side_wall);
		}
		//

		left_dark.makeGraphic(1, 1, FlxColor.BLACK);
		right_dark.makeGraphic(1, 1, FlxColor.BLACK);
		add(left_dark);
		add(right_dark);
		left_dark.scale.x = right_dark.scale.x = sprite_x;
		left_dark.scale.y = right_dark.scale.y = screen_height;
		left_dark.visible = right_dark.visible = false;
		left_dark.updateHitbox();
		right_dark.updateHitbox();
		// left_dark.offset.set();
		// right_dark.offset.set();

		right_dark.x = sprite_x + sprite_width;
	}

	public var back_right_spr:DC_sprite;
	public var back_left_spr:DC_sprite;

	public function update_coordinates():Void
	{
		// trace('=====================');
		// trace('UPDADE coord', camera_position_dx, camera_position_dy);
		// trace('side/step:', camera_d_side, camera_d_step);

		var _n:Int = rows.length;
		while (--_n >= 0)
			rows[_n].update_coordinates();
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

	public function right(_step:Float, _side:Int):Float
	{
		return left(_step, _side + 1);
	}

	public function left(_step:Float, _side:Float):Float
	{
		// screen center
		var _center_x:Float = screen_width * 0.5;
		// width of current step tile
		// OLD: var _w:Float = sprite_width - 2 * DX(_step - camera_d_step);
		var _w:Float = sprite_width * get_scale(_step - camera_d_step);
		return _center_x + _w * (_side - camera_d_side);
	}

	/*public function center(_step:Float, _side:Float):Float
		{
			var _center_x:Float = screen_width * 0.5;
			var _w:Float = sprite_width - 2 * DX(_step);
			return _center_x + _w * _side;
	}*/
	/**
		Up Y coordinate of wall tile on screen
		@param _step tile from camera position
		@return 
	**/
	public function up(_step:Float):Float
	{
		// old:return DY(_step - camera_d_step) + sprite_y;

		return /*center y*/ (sprite_y + sprite_height / 2) - sprite_height * get_scale(_step - camera_d_step) / 2;
	}

	/**
		Lower Y coordinate of row/tile on screen/object on screen
		@param _step tile from camera position
		@return 
	**/
	public function down(_step:Float):Float
	{
		// OLD:return sprite_y + sprite_height - DY(_step - camera_d_step);
		return /*center y*/ (sprite_y + sprite_height / 2) + sprite_height * get_scale(_step - camera_d_step) / 2;
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
		//	trace('3D update');
		if (showed)
			return;
		if (tilemap == null)
			return;
		showed = true;

		camera_position_x = Math.floor(camera_point.x);
		camera_position_y = Math.floor(camera_point.y);

		camera_position_dx = camera_point.x - camera_position_x;
		camera_position_dy = camera_point.y - camera_position_y;

		// trace('Camera:', camera_position_x, camera_position_y, camera_position_dx, camera_position_dy);

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

		//	trace('setCamera');
		setCameraDxDy();

		for (r in rows)
		{
			r.sprites_on_screen.clear();
		}
		//	trace('updating sprites');
		for (r in rows)
		{
			//		trace('row:', r);
			r.update_sprites(_dx_per_step, _dx_per_side, _dy_per_step, _dy_per_side);
		}
		//	trace('effect actions');
		DC_Effect.actions_all(elapsed);

		//	trace('show borders');
		show_borders(_dx_per_step, _dx_per_side, _dy_per_step, _dy_per_side);
		//	trace('super update');
		super.update(elapsed);
		//	trace('3D update END');
	}

	public var x:Float = 0;
	public var y:Float = 0;
	public var camera_d_step:Float = 0.5;
	public var camera_d_side:Float = 0.5;

	private function setCameraDxDy():Void
	{
		// if (camera_position_dx == last_camera_position_dx || camera_position_dy == last_camera_position_dy)
		//		return;

		var _d_step:Float = 0;
		var _d_side:Float = 0;
		switch (camera_face)
		{
			case FACE_UP:
				camera_d_step = 1 - camera_position_dy;
				camera_d_side = camera_position_dx;

			case FACE_RIGHT:
				camera_d_step = camera_position_dx;
				camera_d_side = camera_position_dy;

			case FACE_DOWN:
				camera_d_step = camera_position_dy;
				camera_d_side = 1 - camera_position_dx;

			case FACE_LEFT:
				camera_d_step = 1 - camera_position_dx;
				camera_d_side = 1 - camera_position_dy;
			default:
				trace('ERROR');
		}

		// trace('Face:', camera_face);
		// trace(camera_d_step, camera_d_side, '/', last_camera_d_step, last_camera_d_side);
		if (last_camera_d_step != camera_d_step || last_camera_d_side != camera_d_side)
			update_coordinates();

		last_camera_d_step = camera_d_step;
		last_camera_d_side = camera_d_side;
	}

	public function show_borders(_dx_per_step:Int, _dx_per_side:Int, _dy_per_step:Int, _dy_per_side:Int):Void
	{
		// return;
		// Left

		var _x:Int = camera_position_x - _dx_per_side - _dx_per_step;
		var _y:Int = camera_position_y - _dy_per_side - _dy_per_step;
		var _x2:Int = camera_position_x - _dx_per_side;
		var _y2:Int = camera_position_y - _dy_per_side;
		if (_x < 0 || _y < 0 || _x >= tilemap.widthInTiles || _y >= tilemap.heightInTiles)
			left_dark.visible = false;
		else
		{
			var _t:Int = tilemap.getTile(_x, _y);
			var _t2:Int = tilemap.getTile(_x2, _y2);

			if (sprites_complect[_t].block_vision && sprites_complect[_t2].block_vision)
			{
				left_dark.visible = true;
				left_dark.scale.x = left(camera_d_step - 1, 0);
				// left_dark.scale.x = left(-1, 0);
				left_dark.updateHitbox();
				if (left_dark.scale.x <= 0)
				{
					left_dark.visible = false;
				}
				left_dark.x = 0;
				// trace('Left:' + left_dark.scale.x);
			}
			else
				left_dark.visible = false;
		}

		back_left_spr.set_visible(left_dark.visible, false);

		// right
		_x = camera_position_x + _dx_per_side - _dx_per_step;
		_y = camera_position_y + _dy_per_side - _dy_per_step;
		_x2 = camera_position_x + _dx_per_side;
		_y2 = camera_position_y + _dy_per_side;

		if (_x < 0 || _y < 0 || _x >= tilemap.widthInTiles || _y >= tilemap.heightInTiles)
			right_dark.visible = false;
		else
		{
			var _t:Int = tilemap.getTile(_x, _y);
			var _t2:Int = tilemap.getTile(_x2, _y2);
			if (sprites_complect[_t].block_vision && sprites_complect[_t2].block_vision)
			{
				right_dark.visible = true;
				right_dark.x = right(camera_d_step - 1, 0);
				// right_dark.x = right(-1, 0);
				right_dark.scale.x = screen_width - right_dark.x;
				right_dark.updateHitbox();
			}
			else
				right_dark.visible = false;
		}
		back_right_spr.set_visible(right_dark.visible, false);
	}
}
