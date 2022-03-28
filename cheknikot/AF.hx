package cheknikot;

/**
 * ...
 * @author ...
 */
// import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxHorizontalAlign;

// import flixel.system.FlxAssets.FlxGraphicAsset;
// import openfl.display.Tilemap;
class AF
{
	public static var collosion_variants:Int = 2;

	public static function set_collosion(tilemap:FlxTilemap, index:Int, collosion:Int, collide_f:FlxObject->FlxObject->Void = null):Void
	{
		var variant:Int = collosion_variants;
		var n:Int = index * variant - 1;

		// var passable_indexes:Array<Int> = [6];

		while (++n < (index * variant + variant))
		{
			if (tilemap != null)
			{
				trace('collosion', n, collosion);
				tilemap.setTileProperties(n, collosion, collide_f);
			}
		}
	}

	public static function get_free_object(_arr:Array<Dynamic>, _number:Int, _function_new:Void->Dynamic):Dynamic
	{
		if (_number >= _arr.length)
		{
			var _obj:Dynamic = _function_new();
			_arr.push(_obj);
		}
		return (_arr[_number]);
	}

	public static function NESW_border(_i:Int):Int
	{
		while (_i < 0 || _i > 3)
		{
			if (_i < 0)
				_i += 4;
			if (_i > 3)
				_i -= 4;
		}
		return _i;
	}

	public static function get_step_dx(camera_face:Int):Int
	{
		camera_face = NESW_border(camera_face);
		if (camera_face == 1 /*FACE_RIGHT*/)
			return 1;
		if (camera_face == 3 /*FACE_LEFT*/)
			return -1;
		return 0;
	}

	public static function get_step_dy(camera_face:Int):Int
	{
		camera_face = NESW_border(camera_face);
		if (camera_face == 2 /*FACE_DOWN*/)
			return 1;
		if (camera_face == 0 /*FACE_UP*/)
			return -1;
		return 0;
	}

	public static function getTileByCoords(_tilemap:FlxTilemap, _p:FlxPoint):Int
	{
		var _index:Int = _tilemap.getTileIndexByCoords(_p);
		var _tile:Int = _tilemap.getTileByIndex(_index);
		return _tile;
	}

	public static function get_text(_arr:Array<String>):String
	{
		var _str:String = '';

		if (_arr != null)
		{
			if (GameParams.LANGUAGE < _arr.length)
				_str = _arr[GameParams.LANGUAGE]
			else if (_arr.length > 0)
				_str = _arr[0];
		}

		#if android
		_str = new UnicodeString(_str);
		#end

		return _str;
	}

	public static function uncompressArray(arr:Array<Int>):Array<Int>
	{
		var _i:Int = 0;
		var _l_arr:Array<Int> = new Array();

		while (_i < arr.length)
		{
			var _counts:Int = arr[_i];
			_i++;
			var _tile:Int = arr[_i];
			_i++;

			while (--_counts >= 0)
			{
				_l_arr.push(_tile);
			}
		}
		return _l_arr;
	}

	public static function get_compressed_array(m:FlxTilemap):Array<Int>
	{
		// var tiles_height:Int = m.heightInTiles;
		// var tiles_width:Int = m.widthInTiles;

		var _arr:Array<Int> = new Array();

		var _index:Int = 0;
		var _counts:Int = 1;
		var _tile:Int = m.getTileByIndex(_index);
		while (++_index < m.totalTiles)
		{
			var _new_tile:Int = m.getTileByIndex(_index);

			if (_tile == _new_tile)
			{
				_counts++;
			}
			else
			{
				_arr.push(_counts);
				_arr.push(_tile);

				_tile = _new_tile;
				_counts = 1;
			}
		}
		_arr.push(_counts);
		_arr.push(_tile);
		return _arr;
	}

	public static function get2DarrayFromTilemap(m:FlxTilemap):Array<Array<Int>>
	{
		var _y:Int = -1;
		var tiles_height:Int = m.heightInTiles;
		var tiles_width:Int = m.widthInTiles;
		var arr:Array<Array<Int>> = new Array();
		var arr_y:Array<Int>;

		while (++_y < tiles_height)
		{
			arr_y = arr[_y] = new Array();
			var _x:Int = -1;
			while (++_x < tiles_width)
			{
				arr_y[_x] = m.getTile(_x, _y);
				// walls[_y][_x] = GameObjectLayer.walls.getTile(_x, _y);
			}
		}
		return arr;
	}

	public static function get1DarrayFromTilemap(m:FlxTilemap):Array<Int>
	{
		var _y:Int = -1;
		var tiles_height:Int = m.heightInTiles;
		var tiles_width:Int = m.widthInTiles;
		var arr:Array<Int> = new Array();

		while (++_y < tiles_height)
		{
			var _x:Int = -1;
			while (++_x < tiles_width)
			{
				arr.push(m.getTile(_x, _y));
				// walls[_y][_x] = GameObjectLayer.walls.getTile(_x, _y);
			}
		}
		return arr;
	}

	/*
		public static function get_asset_png(str:String):FlxGraphicAsset
		{
			return Reflect.getProperty(AssetPaths, str + '__png');
		}
	 */
	public static function get_object_compare(arr:Array<Dynamic>, lowest:Bool, parameter:String):Dynamic
	{
		if (arr.length == 0)
			return null;

		var current:Dynamic = arr[0];

		for (r in arr)
		{
			var value:Dynamic = Reflect.getProperty(r, parameter);
			var value_current:Dynamic = Reflect.getProperty(current, parameter);

			if (lowest)
			{
				// trace(value+' < ' + value_current,(value < value_current ));

				if (value < value_current)
				{
					current = r;
				}
			}
			else
			{
				if (value > value_current)
				{
					current = r;
				}
				// trace(value+' > ' + value_current,(value > value_current ) );
			}
		}
		return current;
	}

	public static function scale_picture(s:FlxSprite, stage_w:Float = -1, stage_h:Float = -1):Void
	{
		if (stage_w == -1)
			stage_w = FlxG.width;
		if (stage_h == -1)
			stage_h = FlxG.height;

		var w:Int = s.frameWidth;
		var h:Int = s.frameHeight;

		trace('stage', stage_w, stage_h);
		trace('sprite', w, h);

		if (w == stage_w && h == stage_h)
		{
			trace('PERFECTO');
			return;
		}

		// screen_w = Capabilities.screenResolutionX;
		// screen_h = Capabilities.screenResolutionY;

		var scale_w:Float = stage_w / w;
		var scale_h:Float = stage_h / h;

		var scale:Float = 1;

		// if (scale_h < 1)
		// {
		scale = Math.max(scale_w, scale_h);
		// }
		// else scale = Math.min(scale_w, scale_h);

		s.scale.set(scale, scale);

		s.updateHitbox();
		trace('scale:', scale_w, scale_h, scale);
	}

	public static function clear_array(arr:Array<Dynamic>):Void
	{
		var _n:Int = arr.length;
		while (--_n >= 0)
		{
			arr.splice(0, 1);
		}
	}

	public static function get_object_with(arr:Array<Dynamic>, _prop:String, _value:Dynamic):Dynamic
	{
		var n:Int = arr.length;
		while (--n >= 0)
		{
			var o:Dynamic = arr[n];
			if (o == null)
				continue;
			// if (Reflect.hasField(o, _prop))
			if (Reflect.getProperty(o, _prop) == _value)
			{
				return o;
			}
		}
		return null;
	}

	public static function get_object_with_english(arr:Array<Dynamic>, _prop:String, _value_0:Dynamic):Dynamic
	{
		var n:Int = arr.length;
		while (--n >= 0)
		{
			var o:Dynamic = arr[n];
			if (o == null)
				continue;

			var _value:Array<Dynamic> = Reflect.getProperty(o, _prop);
			if (_value != null)
				if (_value[0] == _value_0)
				{
					return o;
				}
		}
		return null;
	}

	public static function get_objects_with(arr:Array<Dynamic>, _prop:String, _value:Dynamic):Array<Dynamic>
	{
		var res:Array<Dynamic> = new Array();
		var n:Int = arr.length;
		while (--n >= 0)
		{
			var o:Dynamic = arr[n];
			if (o == null)
				continue;
			if (Reflect.getProperty(o, _prop) == _value)
			{
				res.push(o);
			}
		}
		return res;
	}

	// public static var timer:Array<Float> = [0,0,0,0,0,0,0,0,0,0,0];
	private static var last_time:Float = 0;
	// public static var showtime:Bool = false;
	public static var timer_i:Int = 0;
	public static var timer_layer:FlxTypedGroup<FlxText> = new FlxTypedGroup();
	public static var timer_on_screen:Bool = false;

	public static function time_on_off():Void
	{
		timer_on_screen = !timer_on_screen;
		if (AF.timer_on_screen)
		{
			FlxG.state.add(timer_layer);
		}
		else
		{
			FlxG.state.remove(timer_layer, true);
		}
	}

	public static function add_timer(_str:String, time:Float):Void
	{
		if (!timer_on_screen)
			return;
		time = FlxMath.roundDecimal(time, 1);
		var t:FlxText = null;
		if (timer_i == timer_layer.length)
		{
			t = new FlxText(0, timer_i * 11, 0, null, 8);
			t.borderStyle = FlxTextBorderStyle.OUTLINE;
			t.borderSize = 1;

			t.borderColor = FlxColor.BLACK;
			t.scrollFactor.set(0, 0);
			timer_layer.add(t);
		}
		else
		{
			t = timer_layer.members[timer_i];
		}
		t.text = _str + time;

		timer_i++;
	}

	public static function check_time(_str:String):Void
	{
		var current_time:Float = Date.now().getTime();
		var time:Float = current_time - last_time;
		last_time = current_time;

		if (_str != null)
		{
			add_timer(_str, time);
		}
		else
		{
			timer_i = 0;
			if (timer_on_screen)
			{
				FlxG.state.remove(timer_layer, true);
				FlxG.state.add(timer_layer);
			}
		}
	}

	public static function make_2d_int_array(value:Int, width:Int, height:Int):Array<Array<Int>>
	{
		var arr:Array<Array<Int>> = new Array();
		var arr_1d:Array<Int>;
		while (--height >= 0)
		{
			arr_1d = make_int_array(value, width);
			arr.push(arr_1d);
		}
		return arr;
	}

	public static function make_int_array(value:Int, length:Int):Array<Int>
	{
		var arr:Array<Int> = new Array();
		while (--length >= 0)
		{
			arr.push(value);
		}
		return arr;
	}

	/*
		public static function follow_distance(n:Int):Int
		{
			return  Math.floor( 16 * Math.sqrt(n * 3.14));
			
	}*/
	public static function put_sort(g:FlxGroup, max_width:Float, dx:Float, start_x:Float = 0, start_y:Float = 0):Void
	{
		// var s:FlxSprite;
		var current_x:Float = start_x;
		var current_y:Float = start_y;
		for (s in g)
		{
			cast(s, FlxSprite).x = current_x;
			cast(s, FlxSprite).y = current_y;

			current_x += dx;
			if ((current_x - start_x) > max_width)
			{
				current_x = start_x;
				current_y += dx;
			}
		}
	}

	public static function change_in_2d_int_arr(arr:Array<Array<Int>>, i1:Int, i2:Int):Void
	{
		var x:Int = arr.length;
		var y:Int = 0;
		var maxy:Int = arr[0].length;
		var arr_x:Array<Int>;
		while (--x >= 0)
		{
			arr_x = arr[x];
			y = maxy;
			while (--y >= 0)
			{
				if (arr_x[y] == i1)
				{
					arr_x[y] = i2;
				}
			}
		}
	}

	public static function put_in_center_x(mc:Dynamic, container:Dynamic):Void
	{
		mc.x = (container.width - mc.width) / 2;
	}

	public static function put_in_center_sprite_x(mc:Dynamic, container:Dynamic):Void
	{
		mc.x = container.x + (container.width - mc.width) / 2;
	}

	public static function put_in_center_sprite_y(mc:Dynamic, container:Dynamic):Void
	{
		mc.y = container.y + (container.height - mc.height) / 2;
	}

	public static function put_in_line(arr:Array<Dynamic>, dx:Float, horiz:Bool = true):Void
	{
		var n:Int = 0;
		var o1:Dynamic;
		var o2:Dynamic;
		while (++n < arr.length)
		{
			o1 = arr[n - 1];
			o2 = arr[n];
			if (horiz)
			{
				o2.y = o1.y;
				o2.x = o1.x + o1.width + dx;
			}
			else
			{
				o2.x = o1.x;
				o2.y = o1.y + o1.height + dx;
			}
		}
	}
}
