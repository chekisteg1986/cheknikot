package cheknikot.mapgeneration;

/**
	* ...
	* @
	*author ...
 */
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tile.FlxTilemap;

class MapgenRectangle
{
	public var checked:Bool = false;

	public static var min_w:Int = 8;
	public static var min_h:Int = 8;
	public static var max_w:Int = 10;
	public static var max_h:Int = 10;

	public static var WIDTH:Int;
	public static var HEIGHT:Int;

	public static var rect_map:Array<Array<MapgenRectangle>> = new Array();

	public var room_type:Int = 0;
	public var generated:Bool = false;

	public var x:Int = 0;
	public var y:Int = 0;
	public var width:Int = 0;
	public var height:Int = 0;
	public var maxx:Int = 0;
	public var maxy:Int = 0;

	public var children:Array<MapgenRectangle> = new Array();
	public var parent:MapgenRectangle = null;

	public var vertical_children:Bool = false;

	public var occupied:Bool = false;
	public var name:Array<String> = null;
	public var final_childs:Array<MapgenRectangle> = new Array();

	public var children_passages:Array<MapgenRectangle> = new Array();
	public var all_children_passages:Array<MapgenRectangle> = new Array();
	public var is_passage:Bool = false;

	public var intersects_with:Array<MapgenRectangle> = new Array();

	public static var getNewRect:?Int->?Int->?Int->?Int->MapgenRectangle = standart_new;

	private static function standart_new(_x:Int = 0, _y:Int = 0, _w:Int = 0, _h:Int = 0):MapgenRectangle
	{
		return new MapgenRectangle(_x, _y, _w, _h);
	}

	public static function check_intersects(_arr:Array<MapgenRectangle>):Void
	{
		for (_r in _arr)
			for (_r2 in _arr)
				if (_r != _r2)
					if (_r.intersects(_r2, 1))
						_r.intersects_with.push(_r2);
	}

	public function fillTileMap(_tilemap:FlxTilemap, _t:Int, _diap:Int = 0):Void
	{
		var _x:Int = maxx + 1 + _diap;
		while (--_x >= (x - _diap))
			if (_x >= 0)
				if (_x < _tilemap.widthInTiles)
				{
					var _y:Int = maxy + 1 + _diap;
					while (--_y >= (y - _diap))
						if (_y >= 0)
							if (_y < _tilemap.heightInTiles)
								_tilemap.setTile(_x, _y, _t);
				}
	}

	private function find_final_children_for_passages(_side:String, _result:Array<MapgenRectangle>):Array<MapgenRectangle>
	{
		if (_result == null)
		{
			_result = new Array();
		}

		if (children.length == 0)
		{
			_result.push(this);
			return _result;
		}

		var _room1:MapgenRectangle = children[0];
		var _room2:MapgenRectangle = children[1];
		if (vertical_children)
		{
			if (_side == 'up')
				_room2 = null;
			else if (_side == 'down')
				_room1 = null;
		}
		else
		{
			if (_side == 'left')
				_room2 = null;
			else if (_side == 'right')
				_room1 = null;
		}
		if (_room1 != null)
			_room1.find_final_children_for_passages(_side, _result);
		if (_room2 != null)
			_room2.find_final_children_for_passages(_side, _result);

		return _result;
	}

	public function make_passages_for_children(_border:Int = 0):Void
	{
		if (children.length == 0)
			return;

		var _passage:MapgenRectangle = null;

		if (vertical_children)
		{
			var _up_child:MapgenRectangle = children[0];
			var _down_child:MapgenRectangle = children[1];

			var _up_children:Array<MapgenRectangle> = _up_child.find_final_children_for_passages('down', null);
			var _down_children:Array<MapgenRectangle> = _down_child.find_final_children_for_passages('up', null);

			_passage = make_passage_between(_up_children, _down_children, true, _border);
		}
		else
		{
			var _left_child:MapgenRectangle = children[0];
			var _right_child:MapgenRectangle = children[1];

			var _left_children:Array<MapgenRectangle> = _left_child.find_final_children_for_passages('right', null);
			var _right_children:Array<MapgenRectangle> = _right_child.find_final_children_for_passages('left', null);

			_passage = make_passage_between(_left_children, _right_children, false, _border);
		}

		if (_passage == null)
		{
			trace('ERROR passage == null', vertical_children, children.length);
		}

		this.children_passages.push(_passage);
		this.all_children_passages.push(_passage);

		add_passage_to_all_parent(_passage);
		children[0].make_passages_for_children(_border);
		children[1].make_passages_for_children(_border);
	}

	public static function make_passage_between(_children1:Array<MapgenRectangle>, _children2:Array<MapgenRectangle>, _vertical:Bool, _border):MapgenRectangle
	{
		FlxG.random.shuffle(_children1);
		FlxG.random.shuffle(_children2);
		var _m:Int = _children1.length;
		var _n:Int = _children2.length;
		var _passage:MapgenRectangle = null;
		var _child1:MapgenRectangle;
		var _child2:MapgenRectangle;

		while (--_m >= 0 && _passage == null)
			while (--_n >= 0 && _passage == null)
			{
				var _child1:MapgenRectangle = _children1[_m];
				var _child2:MapgenRectangle = _children2[_n];

				if (_vertical)
				{
					var _min_x:Int = FlxMath.maxInt(_child1.x, _child2.x) + _border;
					var _max_x:Int = FlxMath.minInt(_child1.maxx, _child2.maxx) - _border;
					if (_min_x > _max_x)
						continue;

					var _x:Int = FlxG.random.int(_min_x, _max_x);
					_passage = getNewRect(_x, _child1.maxy, 1, _child2.y - _child1.maxy + 1);
					_passage.is_passage = true;
				}
				else
				{
					var _min_y:Int = FlxMath.maxInt(_child1.y, _child2.y) + _border;
					var _max_y:Int = FlxMath.minInt(_child1.maxy, _child2.maxy) - _border;
					if (_min_y > _max_y)
						continue;

					var _y:Int = FlxG.random.int(_min_y, _max_y);
					_passage = getNewRect(_child1.maxx, _y, _child2.x - _child1.maxx + 1, 1);
					_passage.is_passage = true;
				}

				if (_passage != null)
				{
					trace('Passage:', _passage.x, _passage.y, _passage.maxx, _passage.maxy);
					break;
				}
			}

		if (_passage == null)
		{
			ERROR = true;
			trace('ERROR cant make a passage!!!');
		}
		return _passage;
	}

	public static var ERROR:Bool = false;

	public function new(_x:Int = 0, _y:Int = 0, _w:Int = 0, _h:Int = 0)
	{
		x = _x;
		y = _y;
		width = _w;
		height = _h;

		calculate_max();
		// if (getNewRect == null)
		//		getNewRect = standart_new;
	}

	public static function init_maprect_map(_width:Int, _height:Int):Void
	{
		AF.clear_array(rect_map);

		var _x:Int = -1;
		var _y:Int = -1;

		while (++_x < _width)
		{
			rect_map[_x] = new Array();
			_y = -1;
			while (++_y < _height)
			{
				rect_map[_x][_y] = null;
			}
		}
	}

	public static function fill_maprect_map(childs:Array<MapgenRectangle>):Void
	{
		var _maxx:Int = 0;
		var _maxy:Int = 0;
		var _x:Int = -1;
		var _y:Int = -1;

		if (childs != null)
			for (r in childs)
			{
				_x = r.x - 1;
				_maxx = r.maxx;
				_maxy = r.maxy;
				while (++_x <= _maxx)
				{
					_y = r.y - 1;
					while (++_y <= _maxy)
						if (rect_map[_x] != null)
						{
							rect_map[_x][_y] = r;
						}
				}
			}
	}

	public static function xmore(r1:MapgenRectangle, r2:MapgenRectangle):Int
	{
		if (r1.x == r2.x)
			return 0
		else if (r1.x > r2.x)
			return 1
		else
			return -1;
	}

	public static function ymore(r1:MapgenRectangle, r2:MapgenRectangle):Int
	{
		if (r1.y == r2.y)
			return 0
		else if (r1.y > r2.y)
			return 1
		else
			return -1;
	}

	public static function get_center_x_rectangle(arr:Array<MapgenRectangle>):MapgenRectangle
	{
		arr.sort(xmore);
		var l:Int = Math.floor(arr.length / 2);
		return (arr[l]);
	}

	public static function get_center_y_rectangle(arr:Array<MapgenRectangle>):MapgenRectangle
	{
		arr.sort(ymore);
		var l:Int = Math.floor(arr.length / 2);
		return (arr[l]);
	}

	public static function get_left_rectangles(arr:Array<MapgenRectangle>):Array<MapgenRectangle>
	{
		var min_x:Int = arr[0].x;

		for (rect in arr)
		{
			if (rect.x < min_x)
				min_x = rect.x;
		}

		return AF.get_objects_with(arr, 'x', min_x);
	}

	public static function get_down_rectangles(arr:Array<MapgenRectangle>):Array<MapgenRectangle>
	{
		var min_y:Int = arr[0].y;

		for (rect in arr)
		{
			if (rect.y < min_y)
				min_y = rect.y;
		}

		return AF.get_objects_with(arr, 'y', min_y);
	}

	public static function get_right_rectangles(arr:Array<MapgenRectangle>):Array<MapgenRectangle>
	{
		var max_x:Int = arr[0].maxx;

		for (rect in arr)
		{
			if (rect.maxx > max_x)
				max_x = rect.maxx;
		}

		return AF.get_objects_with(arr, 'maxx', max_x);
	}

	public static function get_up_rectangles(arr:Array<MapgenRectangle>):Array<MapgenRectangle>
	{
		var max_y:Int = arr[0].maxy;

		for (rect in arr)
		{
			if (rect.maxy > max_y)
				max_y = rect.maxy;
		}

		return AF.get_objects_with(arr, 'maxy', max_y);
	}

	public static function get_rect(_tile_x:Int, _tile_y:Int):MapgenRectangle
	{
		if (rect_map[_tile_x] != null)
			return rect_map[_tile_x][_tile_y];
		return null;
	}

	public static function set_size(min:Int, max:Int):Void
	{
		min_w = min_h = min;
		max_w = max_h = max;
	}

	public function get_center_tile():IntPoint
	{
		var p:IntPoint = new IntPoint(0, 0);
		p.x = Math.round((x + maxx) / 2);
		p.y = Math.round((y + maxy) / 2);
		return p;
	}

	public function getCenterFlxPoint(_tile_w:Int, _tile_h:Int):FlxPoint
	{
		var p:FlxPoint = new FlxPoint();
		p.x = ((x + maxx) / 2) * _tile_w;
		p.y = ((y + maxy) / 2) * _tile_h;
		return p;
	}

	public function square():Int
	{
		return width * height;
	}

	public function calculate_w_h():Void
	{
		width = maxx - x + 1;
		height = maxy - y + 1;
	}

	public function calculate_max():Void
	{
		maxx = x + width - 1;
		maxy = y + height - 1;
	}

	public function getFlxRect(_tile_width:Int = 1, _tile_height:Int = 1):FlxRect
	{
		return new FlxRect(this.x * _tile_width, this.y * _tile_height, this.width * _tile_width, this.height * _tile_height);
	}

	public function make_smaller_from_all_sides(streets:Float):Void
	{
		var plus:Int = Math.floor(streets);
		var minus:Int = Math.ceil(streets);

		x = x + plus;
		y = y + plus;
		maxx = maxx - minus;
		maxy = maxy - minus;
		calculate_w_h();
	}

	public static function get_biggest_rectangle(arr:Array<MapgenRectangle>):MapgenRectangle
	{
		var n:Int = arr.length - 1;
		var maxRect:MapgenRectangle = arr[n];

		while (--n >= 0)
		{
			if (arr[n].occupied)
				continue;
			if (arr[n].square() > maxRect.square())
			{
				maxRect = arr[n];
			}
		}

		return maxRect;
	}

	public static function get_smallest_rectangle(arr:Array<MapgenRectangle>):MapgenRectangle
	{
		var n:Int = arr.length - 1;
		var minRect:MapgenRectangle = arr[n];

		while (--n >= 0)
		{
			if (arr[n].occupied)
				continue;

			if (arr[n].square() < minRect.square())
			{
				minRect = arr[n];
			}
		}

		return minRect;
	}

	public static function get_biggest_child(inRect:MapgenRectangle, maxRect:MapgenRectangle = null):MapgenRectangle
	{
		if (maxRect == null)
			maxRect = getNewRect();

		if (inRect.children.length == 0)
		{
			if (inRect.square() > maxRect.square())
			{
				maxRect = inRect;
			}
		}
		else
		{
			var child_rect:MapgenRectangle = get_biggest_child(inRect.children[0], maxRect);

			if (child_rect.square() > maxRect.square())
			{
				maxRect = child_rect;
			}

			child_rect = get_biggest_child(inRect.children[1], maxRect);
			if (child_rect.square() > maxRect.square())
			{
				maxRect = child_rect;
			}
		}
		return maxRect;
	}

	public function make_children():Bool
	{
		var horiz:Bool = true;
		var vertic:Bool = true;

		// can we divide?
		if (width < min_w * 2)
		{
			vertic = false;
		}
		if (height < min_h * 2)
		{
			horiz = false;
		}

		// no
		if (!horiz && !vertic)
			return false;

		// Yes we can!

		if (horiz && vertic)
		{
			vertic = FlxG.random.bool();
			horiz = !vertic;
		}

		var child_1:MapgenRectangle = getNewRect();
		var child_2:MapgenRectangle = getNewRect();

		if (horiz)
		{
			// up and down
			vertical_children = true;
			var h1:Int = FlxG.random.int(min_h, height - min_h);
			if (h1 < min_h)
			{
				trace('ERROR');
				h1 = min_h;
			}

			// up
			child_1.x = x;
			child_1.y = y;
			child_1.width = width;
			child_1.height = h1;
			child_1.calculate_max();
			child_1.parent = this;
			children.push(child_1);

			// down
			child_2.x = x;
			child_2.y = y + h1;

			child_2.width = width;
			child_2.height = height - h1;
			child_2.calculate_max();

			children.push(child_2);
			child_2.parent = this;
		}
		else
		{
			vertical_children = false;
			var w1:Int = FlxG.random.int(min_w, width - min_w);
			if (w1 < min_w)
			{
				trace('ERROR');
				w1 = min_w;
			}

			// left
			child_1.x = x;
			child_1.y = y;
			child_1.width = w1;
			child_1.height = height;
			child_1.calculate_max();
			child_1.parent = this;
			children.push(child_1);

			// right
			child_2.x = x + w1;
			child_2.y = y;
			child_2.width = width - w1;
			child_2.height = height;
			child_2.calculate_max();

			children.push(child_2);
			child_2.parent = this;
		}

		if (child_1.maxy == 0 || child_2.maxy == 0)
		{
			trace('ERROR');
		}

		return true;
	}

	public function intersects(r:MapgenRectangle, range:Int = 0):Bool
	{
		if ((r.x - range) > this.maxx || (this.x - range) > r.maxx)
			return false;
		if ((r.y - range) > this.maxy || (this.y - range) > r.maxy)
			return false;
		return true;
	}

	public function make_all_children():Void
	{
		// if (parent == null) add_to = final_childs;

		AF.clear_array(children);
		AF.clear_array(final_childs);

		if (make_children())
		{
			children[0].make_all_children();
			children[1].make_all_children();
		}
		else
		{
			// adding this final rectangle to ALL parents
			this.add_final_child_to_all_parent(this);
			// save_child_list.push(this);
		}
	}

	private function add_final_child_to_all_parent(_child:MapgenRectangle):Void
	{
		if (this.parent == null)
			return;
		parent.final_childs.push(_child);
		parent.add_final_child_to_all_parent(_child);
	}

	private function add_passage_to_all_parent(_passage:MapgenRectangle):Void
	{
		if (this.parent == null)
			return;
		parent.all_children_passages.push(_passage);
		parent.add_passage_to_all_parent(_passage);
	}
}
