package cheknikot.dungeoncrawler;

import cheknikot.controllers.MouseBase;
import cheknikot.quests_results.Quest;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class DC_GameObject
{
	public static var objects:Array<DC_GameObject> = new Array();

	public static var collision_functions:Array<Int->Int->DC_GameObject->Void> = new Array();

	public var string_id:String = null;
	public var radius_sprites:Array<DC_GameObject>;
	public var line:Int = 0;

	public var can_collide:Bool = true;
	public var moved:Bool = false;
	public var visual_spr:FlxSprite;
	public var visible:Bool = true;

	public var visual_group:Array<FlxSprite>;

	public var front_view_spr:FlxSprite;
	public var right_view_spr:FlxSprite;
	public var back_view_spr:FlxSprite;
	public var left_view_spr:FlxSprite;

	public var on_map:Bool = false;

	public var visual_type:Int = DC_SpriteOutputType.DXDY;

	public var tile_x:Int = 0;
	public var tile_y:Int = 0;
	public var tile_dx:Float = 0.5;
	public var tile_dy:Float = 0.5;
	public var speed:Float = 1;
	public var position:FlxPoint = new FlxPoint();

	private var visible_map:FlxTilemap;
	private var walking_map:FlxTilemap;

	public var object_radius:Float = 0.1;

	public var attitude_dy:Float = 0;

	public var nesw_facing:Int = 0;

	public var name:Array<String>;
	public var on_center:Bool = false;
	public var onClickFunc:DC_GameObject->Void = null;

	public var always_front_view:Bool = true;

	private var face_to_camera:Int = 0;

	private var time:Float = 0;

	public var scale:Float = 1;

	private var last_scale:Float = 1;

	public function setScale(_scale:Float):Void
	{
		scale = _scale;
		visual_spr.scale.set(_scale, _scale);
		visual_spr.updateHitbox();
	}

	public var on_screen_x:Float;
	public var on_screen_y:Float;

	public function setVisualXY(_x:Float, _y:Float):Void
	{
		on_screen_x = _x;
		on_screen_y = _y;

		if (Std.isOfType(visual_spr, FlxSpriteGroup))
		{
			/*visual_spr.x = _x - visual_spr.width * 0.5 * scale;
				visual_spr.y = _y - visual_spr.height * scale;
				visual_spr.offset.set(0, 0); */
		}
		else if (Std.isOfType(visual_spr, FlxSprite))
		{
			visual_spr.x = _x - visual_spr.frameWidth * 0.5 * scale;
			visual_spr.y = _y - visual_spr.frameHeight * scale;
		}
	}

	private var buf_sprites:Array<FlxSprite> = new Array();

	public var on_screen:Bool = false;
	public var current_state:FlxGroup;

	public function add_to_screen(_state:FlxGroup):Void
	{
		on_screen = true;
		current_state = _state;
		_state.add(visual_spr);
	}

	public function mouseover():Bool
	{
		if (Std.isOfType(visual_spr, FlxSpriteGroup))
		{
			// no update hitbox
		}
		else if (Std.isOfType(visual_spr, FlxSprite))
		{
			visual_spr.updateHitbox();
		}

		if (MouseBase.click_point != null)
			if (MouseBase.click_point.inRect(visual_spr.getHitbox()))
				return true;

		/*if (Std.isOfType(visual_spr, FlxSprite))
			{
				var _spr:FlxSprite = cast(visual_spr, FlxSprite);
				_spr.updateHitbox();
				if (FlxG.mouse.getPosition().inRect(_spr.getHitbox()))
					return true;
			}
			else if (Std.isOfType(visual_spr, FlxSpriteGroup))
			{
				var _group:FlxSpriteGroup = cast(visual_spr, FlxSpriteGroup);
				for (_spr in _group)
				{
					_spr.updateHitbox();
					if (FlxG.mouse.getPosition().inRect(_spr.getHitbox()))
						return true;
				}
		}*/

		return false;
	}

	public function create_radius_sprites(_len:Int = 4, _color:FlxColor = FlxColor.CYAN, _size:Int = 2):Void
	{
		radius_sprites = new Array();

		var _n:Int = _len;
		while (--_n >= 0)
		{
			var _go:DC_GameObject = new DC_GameObject();
			_go.can_collide = false;
			_go.visual_spr = new FlxSprite().makeGraphic(_size, _size, _color);
			radius_sprites.push(_go);
		}
	}

	public function rotate_left():Void
	{
		nesw_facing = AF.NESW_border(nesw_facing - 1);
	}

	public function rotate_right():Void
	{
		nesw_facing = AF.NESW_border(nesw_facing - 1);
	}

	public function face_to(_o:DC_GameObject):Void
	{
		var _res:Array<Int> = new Array();
		if (_o.tile_y < this.tile_y)
			_res.push(0);
		if (_o.tile_y > this.tile_y)
			_res.push(2);

		if (_o.tile_x > this.tile_x)
			_res.push(1);
		if (_o.tile_x < this.tile_x)
			_res.push(3);

		if (_res.length > 0)
			nesw_facing = FlxG.random.getObject(_res);
	}

	public function sees(_go:DC_GameObject, _tile_size:Int, _vision_radius:Int = 0):Bool
	{
		if (_vision_radius > 0)
		{
			if (Math.abs(_go.tile_x - tile_x) > _vision_radius)
				return false;
			if (Math.abs(_go.tile_y - tile_y) > _vision_radius)
				return false;
		}

		return visible_map.ray(FlxPoint.weak(position.x * _tile_size, position.y * _tile_size),
			FlxPoint.weak(_go.position.x * _tile_size, _go.position.y * _tile_size));
	}

	public function setVisualSprite(_camera_face:Int):Void
	{
		if (always_front_view)
			return;

		face_to_camera = AF.NESW_border(-_camera_face + this.nesw_facing);
		switch (face_to_camera)
		{
			case 0:
				visual_spr = back_view_spr;
			case 1:
				visual_spr = right_view_spr;
			case 2:
				visual_spr = front_view_spr;
			case 3:
				visual_spr = left_view_spr;
		}
		//	return visual_spr;
	}

	public function loadGraphic_all_sprites(_asset:FlxGraphicAsset, _width:Int, _height:Int):Void
	{
		cast(front_view_spr, FlxSprite).loadGraphic(_asset, true, _width, _height);
		cast(right_view_spr, FlxSprite).loadGraphic(_asset, true, _width, _height);
		cast(left_view_spr, FlxSprite).loadGraphic(_asset, true, _width, _height);
		cast(back_view_spr, FlxSprite).loadGraphic(_asset, true, _width, _height);
	}

	public function animation_add_all_sprites(_name:String, _frames:Array<Int>, _frame_rate:Float, _left_is_mirror_right:Bool, _d_frames = 0):Void
	{
		function _add():Void
		{
			_frames = _frames.copy();
			var _n:Int = _frames.length;
			while (--_n >= 0)
				_frames[_n] = _frames[_n] + _d_frames;
		}

		cast(front_view_spr, FlxSprite).animation.add(_name, _frames, _frame_rate, true, false, false);

		_add();
		cast(right_view_spr, FlxSprite).animation.add(_name, _frames, _frame_rate, true, false, false);

		if (!_left_is_mirror_right)
			_add();
		cast(left_view_spr, FlxSprite).animation.add(_name, _frames, _frame_rate, true, _left_is_mirror_right, false);

		_add();
		cast(back_view_spr, FlxSprite).animation.add(_name, _frames, _frame_rate, true, false, false);
	}

	public function create_all_sprites():Void
	{
		front_view_spr = visual_spr;
		left_view_spr = new FlxSprite();
		right_view_spr = new FlxSprite();
		back_view_spr = new FlxSprite();
	}

	public static function update_all(_e:Float):Void
	{
		var n:Int = objects.length;
		while (--n >= 0)
			if (objects[n] != null)
				objects[n].update(_e);
	}

	public function collide_with(_arr:Array<Dynamic>):DC_GameObject
	{
		var _n:Int = _arr.length;
		while (--_n >= 0)
		{
			var _c:DC_GameObject = cast(_arr[_n], DC_GameObject);
			if (_c == this)
				continue;
			if (!_c.can_collide)
				continue;

			var _critical:Float = _c.object_radius + this.object_radius;
			var _dx:Float = Math.abs(this.tile_x + this.tile_dx - _c.tile_x - _c.tile_dx);
			var _dy:Float = Math.abs(this.tile_y + this.tile_dy - _c.tile_y - _c.tile_dy);
			if ((_dx * _dx + _dy * _dy) < (_critical * _critical))
			{
				return _c;
			}
		}
		return null;
	}

	public function update(_elapsed:Float):Void
	{
		moved = false;
		position.x = tile_x + tile_dx;
		position.y = tile_y + tile_dy;

		if (radius_sprites != null)
			update_radius_sprites(_elapsed);

		check_walls();
	}

	private function check_walls():Void
	{
		var _d:Float = 0.001;

		if (tile_x > 0)
			if (tile_dx < object_radius)
				if (walking_map.getTileCollisions(walking_map.getTile(tile_x - 1, tile_y)) != NONE)
					tile_dx += _d;

		if (tile_y > 0)
			if (tile_dy < object_radius)
				if (walking_map.getTileCollisions(walking_map.getTile(tile_x, tile_y - 1)) != NONE)
					tile_dy += _d;
		if (tile_x < (walking_map.widthInTiles - 1))
			if (tile_dx > (1 - object_radius))
				if (walking_map.getTileCollisions(walking_map.getTile(tile_x + 1, tile_y)) != NONE)
					tile_dx -= _d;
		if (tile_y < (walking_map.heightInTiles - 1))
			if (tile_dy > (1 - object_radius))
				if (walking_map.getTileCollisions(walking_map.getTile(tile_x, tile_y + 1)) != NONE)
					tile_dy -= _d;
	}

	public function update_radius_sprites(_elapsed:Float):Void
	{
		time += _elapsed * 40;
		var _len:Int = radius_sprites.length;
		var _n:Int = _len;
		var _p:FlxPoint = new FlxPoint();
		while (--_n >= 0)
		{
			var _spr:DC_GameObject = radius_sprites[_n];
			var _angle:Float = time + _n * 360 / _len;
			_p.x = object_radius;
			_p.y = 0;
			_p.pivotDegrees(FlxPoint.weak(), _angle);
			_p.x += this.tile_x + this.tile_dx;
			_p.y += this.tile_y + this.tile_dy;

			_spr.setPosition(_p.x, _p.y);
		}
	}

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

		this.front_view_spr = visual_spr = new FlxSprite();
		cast(visual_spr, FlxSprite).scrollFactor.set(0, 0);
	}

	public static var screen_3d:DC_screen;

	public function add_to_map():Void
	{
		on_map = true;
		objects.push(this);
		screen_3d.add_to_visible(this);
		walking_map = visible_map = DC_screen.screen_3d.tilemap;

		if (radius_sprites != null)
		{
			var _n:Int = radius_sprites.length;
			while (--_n >= 0)
				radius_sprites[_n].add_to_map();
		}
	}

	public function remove_from_map():Void
	{
		on_map = false;
		objects.remove(this);
		screen_3d.remove_from_visible(this);
		if (radius_sprites != null)
		{
			var _n:Int = radius_sprites.length;
			while (--_n >= 0)
				radius_sprites[_n].remove_from_map();
		}
	}

	public function shoot(_b:DC_Bullet, _nesw_facing:Int = -1, _side_dx:Float = 0):Void
	{
		if (_nesw_facing == -1)
			_nesw_facing = nesw_facing;

		_b.tile_x = this.tile_x;
		_b.tile_y = this.tile_y;
		var _start:Float = (object_radius + _b.object_radius + 0.1);
		_b.tile_dx = this.tile_dx + AF.get_step_dx(_nesw_facing) * _start;
		_b.tile_dy = this.tile_dy + AF.get_step_dy(_nesw_facing) * _start;
		if (_side_dx != 0)
		{
			_b.tile_dx += AF.get_step_dx(_nesw_facing + 1) * _side_dx;
			_b.tile_dy += AF.get_step_dy(_nesw_facing + 1) * _side_dx;
		}
		_b.nesw_facing = _nesw_facing;
		_b.add_to_map();
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

	public function setPosition(_new_x:Float, _new_y:Float):Void
	{
		screen_3d.remove_from_visible(this);
		this.tile_x = Math.floor(_new_x);
		this.tile_y = Math.floor(_new_y);
		this.tile_dx = _new_x - tile_x;
		this.tile_dy = _new_y - tile_y;
		screen_3d.add_to_visible(this);
	}

	public function step_forward(_face:Int = -1, _speed:Float = 1, _make_step:Bool = true):Bool
	{
		var _border:Float = 0.1;

		if (_face == -1)
			_face = nesw_facing;
		if (_face > 3)
			_face -= 4;

		var _step_x:Int = AF.get_step_dx(_face);
		var _step_y:Int = AF.get_step_dy(_face);

		var _dx:Float = _step_x * _speed;
		var _dy:Float = _step_y * _speed;
		// trace('dxdy', _dx,_dy);

		var _x:Float = this.tile_x + tile_dx + _dx;
		var _y:Float = this.tile_y + tile_dy + _dy;

		var _new_x:Int = Math.floor(_x + _step_x * _border);
		var _new_y:Int = Math.floor(_y + _step_y * _border);

		var _walls:FlxTilemap = walking_map;

		if (_new_x >= 0 && _new_x < _walls.widthInTiles)
			if (_new_y >= 0 && _new_y < _walls.heightInTiles)
			{
				var _t:Int = _walls.getTile(_new_x, _new_y);
				if (_walls.getTileCollisions(_t) != NONE)
				{
					// trace('block', _walls.getTile(_new_x, _new_y), tile_x, tile_y, _new_x, _new_y);

					if (collision_functions[_t] != null)
						collision_functions[_t](_new_x, _new_y, this);
					return false;
				}

				if (_make_step)
				{
					moved = true;

					_new_x = Math.floor(_x);
					_new_y = Math.floor(_y);
					if (tile_x != _new_x || tile_y != _new_y)
					{
						setPosition(_x, _y);
						/*screen_3d.remove_from_visible(this);
							this.tile_x = _new_x;
							this.tile_y = _new_y;
							screen_3d.add_to_visible(this); */
					}
					this.tile_dx = _x - tile_x;
					this.tile_dy = _y - tile_y;
				}

				return true;
			}
		return false;
	}

	public function kill():Void
	{
		remove_from_map();
	}

	public static function get_objects_at(_x:Int, _y:Int):Array<DC_GameObject>
	{
		return screen_3d.visible_map[_x + _y * DC_screen.screen_3d.tilemap.widthInTiles].copy();
	}

	@:generic
	public function get_objects_in_front<T>(_arr:Array<T>, _start_step:Int):Array<T>
	{
		var _dx:Int = AF.get_step_dx(nesw_facing);
		var _dy:Int = AF.get_step_dy(nesw_facing);

		var _step:Int = _start_step;

		var _new_x:Int = 0;
		var _new_y:Int = 0;
		var _width:Int = visible_map.widthInTiles;
		var _height:Int = visible_map.heightInTiles;

		while (true)
		{
			_new_x = tile_x + _step * _dx;
			if (_new_x >= _width)
				break;
			if (_new_x < 0)
				break;
			_new_y = tile_y + _step * _dy;
			if (_new_y >= _height)
				break;
			if (_new_y < 0)
				break;

			if (visible_map.getTileCollisions(visible_map.getTile(_new_x, _new_y)) == ANY)
				break;
			_step++;
		}
		// now we know where steps ends
		// _step , <>_new_x, <>_new_y
		var _res:Array<T> = new Array();
		var _n:Int = _arr.length;
		while (--_n >= 0)
		{
			var _obj:DC_GameObject = cast(_arr[_n], DC_GameObject);
			if (_dx == 0 && _obj.tile_x != this.tile_x)
				continue;
			if (_dy == 0 && _obj.tile_y != this.tile_y)
				continue;
			if (_dx > 0 && (_obj.tile_x >= _new_x || _obj.tile_x < this.tile_x))
				continue;
			if (_dx < 0 && (_obj.tile_x <= _new_x || _obj.tile_x > this.tile_x))
				continue;
			if (_dy > 0 && (_obj.tile_y >= _new_y || _obj.tile_y < this.tile_y))
				continue;
			if (_dy < 0 && (_obj.tile_y <= _new_y || _obj.tile_y > this.tile_y))
				continue;
			_res.push(_arr[_n]);
		}
		return _res;
	}
}
