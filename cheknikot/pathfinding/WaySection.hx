package cheknikot.pathfinding;
import cheknikot.IntRectangle;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.system.debug.watch.Watch;


/**
 * ...
 * @author ...
 */
class WaySection 
{
	public var number:Int = 0;
	public var min_x:Int = 0;
	public var min_y:Int = 0;
	public var max_x:Int = 0;
	public var max_y:Int = 0;
	
	public var midpoint:FlxPoint = new FlxPoint();
	public var rect:FlxRect = new FlxRect();
	public var full_rect:FlxRect = new FlxRect();
	
	
	public var connected_with:Array<WaySection> = new Array();

	
	
	

	public static var map_width:Int;
	public static var map_height:Int;
	
	

	public function new(_i:Int) 
	{
		number = _i;
	}
	
	//public static var diap_y_minus
	
	public static var diap_y_plus:Int = 20;
	public static var diap_y_minus:Int =0;
	public static var diap_x_plus:Int = 15;
	public static var diap_x_minus:Int = 15;
	
	public static var mp_dx:Int = 0;
	public static var mp_dy:Int = 0;
	
	
	public function check_connections():Void
	{
		var _r:IntRectangle = new IntRectangle(min_x - 1, min_y - 1,0,0);
		_r.maxx = max_x;
		_r.maxy = max_y;
		PathMapBase.state.check_all_connections(_r);
	}
	public function remove_connections():Void
	{
		var _ws:WaySection = null;
		var _i:Int = connected_with.length;
		while (--_i >= 0)
		{
			_ws = connected_with[_i];
			_ws.connected_with.remove(this);
			connected_with.remove(_ws);
		}
	}
	
	
	public function calculate_midpoit():Void
	{
		//var diap:Float = 0.2;
		var tilesize:Int = GameParams.TILE_SIZE;
		
		//var diap_x:Float = 0.45;
		//var diap_y:Float = 0.45;
		
		//if (min_x != max_x) diap_x = 0.5;
		//if (min_y != max_y) diap_y = 0.5;
		
		rect.x = min_x * tilesize +diap_x_plus;
		rect.y = min_y * tilesize +diap_y_plus;
		rect.width = (max_x - min_x+1) * tilesize - diap_x_minus-diap_x_plus;
		rect.height = (max_y - min_y+1 ) * tilesize- diap_y_minus - diap_y_plus;
		
		
		//midpoint.x = rect.x + rect.width / 2 +dx;
		//midpoint.y = rect.y + rect.height / 2 +dy;
		//midpoint.x = (max_x + min_x+1) * 0.5*tilesize;
		//midpoint.y = (max_y + min_y + 1) * 0.5 * tilesize;		
		full_rect.x = min_x * tilesize;
		full_rect.y = min_y * tilesize;
		full_rect.width = (max_x - min_x + 1) * tilesize;
		full_rect.height = (max_y - min_y + 1) * tilesize;
		midpoint.x = full_rect.x +mp_dx;
		midpoint.y = full_rect.y +mp_dy;
		
	}
	
	public function perfect_fit(p:FlxPoint):Bool
	{
		return (p.inRect(rect));
	}
	
	
	
	
	
}