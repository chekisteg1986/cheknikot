package cheknikot.pathfinding;

import cheknikot.IntRectangle;
import cheknikot.pathfinding.WaySection;
import cheknikot.pathfinding.topdown.PathfindMemory;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class PathMapBase
{
	// map of waysections
	// map of free tiles
	public var way_zones:Array<WaySection> = new Array();

	public var passages:Array<Bool> = new Array();

	/*

	 */
	public var width:Int = 0;
	public var height:Int = 0;

	public var passable_walls:Array<Bool> = new Array();
	public var current_zone:Int = 0;
	public var wayzones_list:Array<WaySection> = new Array();

	public static var state:PathMapBase;

	public function new()
	{
		state = this;
	}

	private function clear_pathmap():Void
	{
		AF.clear_array(passages);
		AF.clear_array(chkd);
		AF.clear_array(way_zones);
		AF.clear_array(wayzones_list);
	}

	private function prepare_arrays():Void
	{
		var max_index:Int = (width - 1) * (height - 1) + 1;
		while (--max_index >= 0)
		{
			way_zones.push(null);
			passages.push(false);
			chkd.push(false);
		}
	}

	public function refresh(_w:Int, _h:Int):Void
	{
		drawed = false;
		width = _w;
		height = _h;

		pixel_width = width * GameParams.TILE_SIZE;
		pixel_height = height * GameParams.TILE_SIZE;

		clear_pathmap();

		prepare_arrays();
	}

	public function check_all_connections(r:IntRectangle = null):Void
	{
		var min_x:Int = 0;
		var min_y:Int = 0;
		var max_x:Int = width - 1;
		var max_y:Int = height - 1;
		// var maxx_x:Int = 0;

		if (r != null)
		{
			min_x = FlxMath.maxInt(min_x, r.x);
			min_y = FlxMath.maxInt(min_y, r.y);
			max_x = FlxMath.minInt(max_x, r.maxx);
			max_y = FlxMath.minInt(max_y, r.maxy);
		}

		var _x:Int = min_x - 1;
		var _y:Int = min_y - 1;

		while (++_x <= max_x)
		{
			_y = min_y - 1;
			while (++_y <= max_y)
			{
				check_connections_at(_x, _y);
			}
		}
	}

	public function set_passable_x_y(_x:Int, _y:Int, _pass:Bool):Void
	{
		var _i:Int = _x + _y * width;
		passages[_i] = _pass;
		chkd[_i] = true;
	}

	public var drawed:Bool = false;

	public function draw_wayzones():Void
	{
		if (drawed)
			return;
		drawed = true;
		var _x:Int = 0;
		var _y:Int = 0;
		var wz:WaySection = null;
		var wz_i:Int = way_zones.length;
		var colors:Array<FlxColor> = [FlxColor.CYAN, FlxColor.BLUE, FlxColor.RED, FlxColor.GREEN];
		var color_index:Int = 0;

		var _tilesize:Int = GameParams.TILE_SIZE;

		function addtxt()
		{
			var t:FlxText = new FlxText(_x * _tilesize, _y * _tilesize, _tilesize, '' + wz_i, Math.ceil(_tilesize / 2));
			t.color = colors[color_index];
			MyGameObjectLayer.state.add(t);
			color_index++;
			if (color_index >= colors.length)
				color_index = 0;
		}

		var n:Int = wayzones_list.length;
		while (--n >= 0)
		{
			var wz:WaySection = wayzones_list[n];
			_x = wz.max_x + 1;
			while (--_x >= wz.min_x)
			{
				_y = wz.max_y + 1;
				while (--_y >= wz.min_y)
				{
					// wz = way_zones(_x + _y * width);
					wz_i = wz.number;
					addtxt();
				}
			}
			wz.calculate_midpoit();
			MyGameObjectLayer.state.effects.add(new FlxSprite(wz.midpoint.x - 1, wz.midpoint.y - 1).makeGraphic(1, 1));
			MyGameObjectLayer.state.effects.add(new FlxSprite(wz.rect.x, wz.rect.y).makeGraphic(1, 1, FlxColor.RED));
			MyGameObjectLayer.state.effects.add(new FlxSprite(wz.rect.right, wz.rect.y + wz.rect.height).makeGraphic(1, 1, FlxColor.GREEN));
			MyGameObjectLayer.state.effects.add(new FlxSprite(wz.rect.x, wz.rect.y + wz.rect.height).makeGraphic(1, 1, FlxColor.GREEN));
			MyGameObjectLayer.state.effects.add(new FlxSprite(wz.rect.right, wz.rect.y).makeGraphic(1, 1, FlxColor.RED));
		}
	}

	public function can_walk_here(_x:Int, _y:Int):Bool
	{
		return true;
	}

	private var chkd:Array<Bool> = new Array();

	public function fill_all_passages(_map_width:Int, _map_height:Int):Void
	{
		var _y:Int = _map_height;

		while (--_y >= 0)
		{
			var _x:Int = _map_width;
			while (--_x >= 0)
			{
				if (chkd[_y * _map_width + _x] == false)
					if (can_walk_here(_x, _y))
						fill_passages(_x, _y);
			}
		}
	}

	public function fill_passages(_x:Float, _y:Float):Void
	{
		var active_points:Array<IntPoint> = new Array();
		var p:IntPoint = new IntPoint(Math.floor(_x), Math.floor(_y));
		active_points.push(p);

		var x:Int = 0;
		var y:Int = 0;

		var n:Int = -1;
		var len:Int = 1;
		// var tile:Int = 0;
		var new_point:IntPoint;
		var index:Int;
		var index_new:Int;
		var width_1:Int = width - 1;
		var height_1:Int = height - 1;

		// var walls:FlxTilemap = MyGameObjectLayer.state.walls;
		// var getTile:Int -> Int -> Int = walls.getTile;

		while (++n < len)
		{
			p = active_points[n];
			x = p.x;
			y = p.y;
			index = x + y * width;

			if (passages[index])
				continue;

			if (!can_walk_here(x, y))
				continue;

			passages[index] = true;

			if (x > 0)
			{
				index_new = index - 1;
				if (!chkd[index_new])
					if (!passages[index_new])
					{
						new_point = new IntPoint(x - 1, y);
						active_points.push(new_point);
						len++;
						chkd[index_new] = true;
					}
			}

			if (x < width_1)
			{
				index_new = index + 1;
				if (!chkd[index_new])
					if (!passages[index_new])
					{
						new_point = new IntPoint(x + 1, y);
						active_points.push(new_point);
						len++;
						chkd[index_new] = true;
					}
			}

			if (y > 0)
			{
				index_new = index - width;
				if (!chkd[index_new])
					if (!passages[index_new])
					{
						new_point = new IntPoint(x, y - 1);
						active_points.push(new_point);
						len++;
						chkd[index_new] = true;
					}
			}

			if (y < height_1)
			{
				index_new = index + width;
				if (!chkd[index_new])
					if (!passages[index_new])
					{
						new_point = new IntPoint(x, y + 1);
						active_points.push(new_point);
						len++;
						chkd[index_new] = true;
					}
			}
		}
	}

	public function place_way_zones(square:Bool, _size:Int = 0, _max_size:Int = 3, r:IntRectangle = null):Void
	{
		var x:Int = -1;
		var y:Int = -1;
		var index:Int = 0;
		// var _max_size:Int = 3;

		// if (_size == 0) _max_size = 1;

		var min_x:Int = 0;
		var min_y:Int = 0;
		var max_x:Int = width - 1;
		var max_y:Int = height - 1;
		// var maxx_x:Int = 0;

		if (r != null)
		{
			min_x = FlxMath.maxInt(min_x, r.x);
			min_y = FlxMath.maxInt(min_y, r.y);
			max_x = FlxMath.minInt(max_x, r.maxx);
			max_y = FlxMath.minInt(max_y, r.maxy);
		}

		// ======================
		var grow_w:Bool = true;
		var grow_h:Bool = true;
		var w:Int = 0;
		var h:Int = 0;
		var xx:Int = 0;
		var yy:Int = 0;
		var check_index:Int = 0;
		var last_y:Int = 0;
		var last_x:Int = 0;

		// var fit:Bool = true;

		var ws:WaySection = null;

		function grow_width():Void
		{
			w++;
			xx = x + w;
			yy = y - 1;
			while (++yy <= last_y)
			{
				check_index = xx + yy * width;
				way_zones[check_index] = ws;
			}
			if (w >= _max_size)
				grow_w = false;
		}

		function grow_height():Void
		{
			h++;
			xx = x - 1;
			yy = y + h;
			while (++xx <= last_x)
			{
				check_index = xx + yy * width;
				way_zones[check_index] = ws;

				// t = new FlxText(xx * 16, yy * 16, 16, current_zone, 4);
				// GameObjectLayer.effects.add(t);
				if (h >= _max_size)
					grow_h = false;
			}
		}

		var index2:Int = 0;

		y = min_y - 1;
		while (++y <= max_y)
		{
			x = min_x - 1;
			while (++x <= max_x)
			{
				index = x + y * width;
				if (way_zones[index] == null)
					if (passages[index])
					{
						if (square)
						{
							// проверка на квадрат минимального размера
							xx = x + _size;
							if (xx > max_x)
								continue;

							yy = y + _size;
							if (yy > max_y)
								continue;

							var placed:Bool = true;

							xx++;
							while (--xx >= x)
							{
								yy = y + _size + 1;

								while (--yy >= y)
								{
									index2 = xx + yy * width;
									if (way_zones[index2] != null)
										placed = false;
									if (!passages[index2])
										placed = false;
								}
							}

							if (!placed)
								continue;

							// вставляется!
							current_zone++;
							ws = new WaySection(current_zone);
							wayzones_list.push(ws);

							xx = x + _size + 1;
							while (--xx >= x)
							{
								yy = y + _size + 1;
								while (--yy >= y)
								{
									index2 = xx + yy * width;
									way_zones[index2] = ws;
									// addtxt(xx, yy, current_zone);
								}
							}
							w = _size;
							h = _size;
						}
						else
						{
							current_zone++;

							ws = new WaySection(current_zone);
							wayzones_list.push(ws);

							// addtxt(x , y, current_zone);

							way_zones[index] = ws;
							w = 0;
							h = 0;
						}

						// нашли точку свободную, делаем прямоугольник
						grow_w = true;
						grow_h = true;

						if (_max_size == 0)
						{
							grow_h = false;
							grow_w = false;
						}

						// размещаем прямоугольник
						while (grow_w || grow_h)
						{
							if (grow_w)
							{
								xx = x + w + 1;
								yy = y - 1;
								last_y = y + h;

								if (xx >= width)
								{
									grow_w = false;
								}
								else
									while (++yy <= last_y)
									{
										check_index = xx + yy * width;
										if (!passages[check_index] || way_zones[check_index] != null)
										{
											grow_w = false;
											break;
										}
									}

								// можно расширить вправо
								if (!square)
								{
									if (grow_w)
									{
										grow_width();
									}
								}
							}

							if (grow_h && (!square || (square && grow_w)))
							{
								xx = x - 1;
								yy = y + h + 1;
								last_x = x + w;

								if (square)
									last_x++;

								if (yy >= height)
								{
									grow_h = false;
								}
								else
									while (++xx <= last_x)
									{
										check_index = xx + yy * width;
										if (!passages[check_index] || way_zones[check_index] != null)
										{
											grow_h = false;
											break;
										}
									}

								// можно расширить вверх
								if (!square)
									if (grow_h)
									{
										grow_height();
									}
							}

							if (square)
							{
								if (grow_w && grow_h)
								{
									grow_width();
									grow_height();
								}
								else
								{
									grow_h = grow_w = false;
								}
							}
						}

						ws.min_x = x;
						ws.max_x = x + w;
						ws.min_y = y;
						ws.max_y = y + h;
						ws.calculate_midpoit();
					}
			}
		}
	}

	public function check_connections_at(_x:Int, _y:Int):Void
	{
		var index:Int = _x + _y * width;

		var ws1:WaySection = way_zones[index];
		var ws2:WaySection = null;

		if (_x < (width - 1))
		{
			ws2 = way_zones[index + 1];
			if (ws1 != ws2)
			{
				connect_sections(ws1, ws2);
			}
		}

		if (_y < (height - 1))
		{
			ws2 = way_zones[index + width];
			if (ws1 != ws2)
			{
				connect_sections(ws1, ws2);
			}
		}
	}

	public function connect_sections(ws1:WaySection, ws2:WaySection):Void
	{
		if (ws1 == null)
			return;
		if (ws2 == null)
			return;
		if (ws1.connected_with.indexOf(ws2) == -1)
		{
			ws1.connected_with.push(ws2);
			ws2.connected_with.push(ws1);
		}
	}

	public var pixel_width:Int;
	public var pixel_height:Int;

	public function get_way_zone(p:FlxPoint):WaySection
	{
		var size:Int = GameParams.TILE_SIZE;
		var x:Float = p.x;
		var y:Float = p.y;
		if (x <= 0)
			return null;
		if (y <= 0)
			return null;
		if (x >= pixel_width)
			return null;
		if (y >= pixel_height)
			return null;
		// trace(Math.floor(x / size),Math.floor(y / size),width);
		return way_zones[Math.floor(x / size) + Math.floor(y / size) * width];
	}

	public function close_sections(p1:FlxPoint, p2:FlxPoint):Bool
	{
		var ws1:WaySection = get_way_zone(p1);
		var ws2:WaySection = get_way_zone(p2);

		if (ws1 == ws2)
			return true;

		if (ws1.connected_with.indexOf(ws2) != -1)
			return true;

		return false;
	}

	public var max_ws_per_frame:Int = 10;
	public var max_way:Int = 30;

	public function get_trail_to(p1:FlxPoint, p2:FlxPoint, path_memory:PathfindMemory, force:Bool = false):PathfindMemory
	{
		// Ищем с конца

		var ws1:WaySection = get_way_zone(p1);
		var ws2:WaySection = get_way_zone(p2);

		if (ws1 == null || ws2 == null)
			return null;

		// trace('Pathfinding from ',ws1.number, 'to',ws2.number);

		if (path_memory == null)
		{
			path_memory = new PathfindMemory(ws1, ws2);
		}
		else
		{
			if (ws1 != path_memory.ws1)
			{
				// trace('AHAAAAA');
				return null;
			}
			if (ws2 != path_memory.ws2)
			{
				// trace('AHAAAAA 2');
				return null;
			}
		}
		// save to AI memory
		var active_sections:Array<WaySection> = path_memory.active_sections;
		// индекс текущей секции
		var i:Int = path_memory.last_i;
		// размер активных секций
		var len:Int = active_sections.length;
		// чему предшествовало
		var last_ws:Array<WaySection> = path_memory.last_ws;
		// нашлось ли
		var finded:Bool = false;

		// временное
		// текущая секция проверяемая
		var current_ws:WaySection = null;
		var connections:Array<WaySection>;
		var j:Int = 0;
		var next_ws:WaySection;

		var max_i:Int = i + max_ws_per_frame;

		while (++i < len && !finded && (i < max_i || force))
		{
			current_ws = active_sections[i];
			connections = current_ws.connected_with;
			j = connections.length;
			// trace('connections',connections);

			while (--j >= 0)
			{
				next_ws = connections[j];
				// trace('?adding '+next_ws.number);

				if (last_ws[next_ws.number] == null)
				{
					// waysection is not checked
					if (next_ws == ws1)
					{
						// trace('finded! closest ws is',current_ws.number);
						finded = true;
						break;
					}
					else
					{
						// trace('ADDED');
						last_ws[next_ws.number] = current_ws;
						active_sections.push(next_ws);
						len++;
					}
				}
				else
				{
					// trace('already checked');
				}
			}
		}

		if (i == max_i && !force)
		{
			// save memory
			// индекс текущей секции
			path_memory.last_i = i - 2;
			return path_memory;
		}

		var path:Array<WaySection> = path_memory.section_path;
		var way_len:Int = 0;
		if (finded)
		{
			path_memory.finded = true;
			path.push(current_ws);
			// var s:String = current_ws.number + ' ';

			while (current_ws != ws2 && (way_len < max_way || force))
			{
				current_ws = last_ws[current_ws.number];
				// s+= current_ws.number + ' ';
				path.push(current_ws);
				way_len++;
			}
			// trace('Way is '+s);
		}
		else
		{
			if (i == len)
			{
				// NO PATH
				return null;
			}
		}

		// trace('calculate path',path);
		return path_memory;
	}
}
