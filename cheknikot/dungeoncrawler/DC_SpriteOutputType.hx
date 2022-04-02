package cheknikot.dungeoncrawler;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;

class DC_SpriteOutputType
{
	public static inline var LINE:Int = 0;
	public static inline var DXDY:Int = 1;

	private static function positions_face_S(_o1:DC_GameObject, _o2:DC_GameObject):Int
	{
		if (_o1.tile_dy < _o2.tile_dy)
			return -1;
		else if (_o1.tile_dy > _o2.tile_dy)
			return 1;
		else
			return 0;
	}

	private static function positions_face_N(_o1:DC_GameObject, _o2:DC_GameObject):Int
	{
		if (_o1.tile_dy < _o2.tile_dy)
			return 1;
		else if (_o1.tile_dy > _o2.tile_dy)
			return -1;
		else
			return 0;
	}

	private static function positions_face_E(_o1:DC_GameObject, _o2:DC_GameObject):Int
	{
		if (_o1.tile_dx < _o2.tile_dx)
			return -1;
		else if (_o1.tile_dx > _o2.tile_dx)
			return 1;
		else
			return 0;
	}

	private static function positions_face_W(_o1:DC_GameObject, _o2:DC_GameObject):Int
	{
		if (_o1.tile_dx < _o2.tile_dx)
			return 1;
		else if (_o1.tile_dx > _o2.tile_dx)
			return -1;
		else
			return 0;
	}

	public static function show_visible_objects_dxdy(_sprite_objects:Array<DC_GameObject>, _dc_sprite:DC_sprite):Void
	{
		var _camera_face:Int = DC_screen.screen_3d.camera_face;
		var _scale:Float = 1;
		switch (_camera_face)
		{
			case 0:
				_sprite_objects.sort(positions_face_N);
			case 1:
				_sprite_objects.sort(positions_face_E);
			case 2:
				_sprite_objects.sort(positions_face_S);
			case 3:
				_sprite_objects.sort(positions_face_W);
		}

		var _len:Int = _sprite_objects.length;
		var _obj:DC_GameObject = null;
		var _n:Int = _len;
		var _spr:FlxSprite = null;
		while (--_n >= 0)
		{
			_obj = cast(_sprite_objects[_n], DC_GameObject);
			if (!_obj.visible)
				continue;
			_obj.setVisualSprite(_camera_face);
			if (_obj.visual_spr == null)
				continue;

			_dc_sprite.parent_row.sprites_on_screen.add(_obj.visual_spr);
			_obj.visual_spr.visible = true;
			_spr = _obj.visual_spr;

			_spr.updateHitbox();

			var _width:Float = _dc_sprite.w_right - _dc_sprite.w_left;
			var _height:Float = _dc_sprite.w_down - _dc_sprite.next_down;
			// trace('CHECK', DC_screen.screen_3d.DY(1), _height);
			// var _next_height:Float = DC_screen.screen_3d.DY(2);

			var _dx:Float = 0;
			var _dy:Float = 0;

			if (_camera_face == 0)
			{
				_dx = _obj.tile_dx;
				_dy = 1 - _obj.tile_dy;
			}
			else if (_camera_face == 1)
			{
				_dx = _obj.tile_dy;
				_dy = _obj.tile_dx;
			}
			else if (_camera_face == 2)
			{
				_dx = (1 - _obj.tile_dx);
				_dy = _obj.tile_dy;
			}
			else if (_camera_face == 3)
			{
				_dx = (1 - _obj.tile_dy);
				_dy = 1 - _obj.tile_dx;
			}

			var _scale:Float = _dc_sprite.scale_h - (_dc_sprite.scale_h - _dc_sprite.next_scale_h) * (_dy - 1);

			_spr.scale.set(_scale, _scale);
			_spr.updateHitbox();

			var _left:Float = _dc_sprite.get_left(_dy);
			var _right:Float = _dc_sprite.get_right(_dy);

			_spr.x = _dc_sprite.get_center(_dy) + (_dx - 0.5) * (_right - _left);
			_spr.y = _dc_sprite.w_down - _dy * _height - _obj.attitude_dy * _scale;

			_spr.x += -_spr.frameWidth * _scale * 0.5;
			_spr.y += -_spr.frameHeight * _scale;
		}
	}

	public static function put_in_center(_obj:DC_GameObject, _dy:Float, _dc_sprite:DC_sprite):Void
	{
		var _spr:FlxSprite = _obj.visual_spr;
		_dc_sprite.parent_row.sprites_on_screen.add(_spr);
		_spr.visible = true;
		_spr.scale.set(_dc_sprite.scale_h, _dc_sprite.scale_h);
		_spr.updateHitbox();
		_spr.x = (_dc_sprite.w_left + _dc_sprite.w_right) / 2 - _spr.width / 2;
		_spr.y = _dc_sprite.w_down - (_dy + _spr.frameHeight) * _dc_sprite.scale_h;
	}

	public static function put_in_row(_sprite_objects:Array<Dynamic>, _dy:Float, _dc_sprite:DC_sprite):Void
	{
		var _len:Int = _sprite_objects.length;
		var _obj:DC_GameObject = null;
		var _n:Int = _len;
		var _spr:FlxSprite = null;
		while (--_n >= 0)
		{
			_obj = cast(_sprite_objects[_n], DC_GameObject);

			_dc_sprite.parent_row.sprites_on_screen.add(_obj.visual_spr);
			_obj.visual_spr.visible = true;
			_spr = _obj.visual_spr;

			_spr.scale.set(_dc_sprite.scale_h, _dc_sprite.scale_h);
			_spr.updateHitbox();

			var _width:Float = _dc_sprite.w_right - _dc_sprite.w_left;
			var _dx:Float = _width / (_len + 1);

			_spr.x = _dc_sprite.w_left + _dx * (_n + 1) - _spr.frameWidth * _dc_sprite.scale_h * 0.5;
			_spr.y = _dc_sprite.w_down - (_spr.frameHeight + _dy) * _dc_sprite.scale_h;
		}
	}
}
