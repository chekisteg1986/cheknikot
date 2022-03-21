package cheknikot.pathfinding.topdown;
import cheknikot.pathfinding.PathMapBase;

/**
 * ...
 * @author ...
 */
class PathMapTD extends PathMapBase
{
	public var highness:Array<Int> = new Array();
	public function new() 
	{
		super();
		
	}
	
	
	override function can_walk_here(_x:Int, _y:Int):Bool
	{
		var _tile:Int = getTile(_x, _y);
		return passable_walls[tile];
	}
	
	override function clear_pathmap():Void
	{
		super();
		AF.clear_array(highness);
	}
	override function prepare_arrays():Void
	{
		super();
		var max_index:Int = (width - 1) * (height - 1)+1;
		while (--max_index >= 0)
		{
			way_zones.push(null);
			passages.push(false);
			checked.push(false);
			highness.push(0);
		}
	}
	
	private function maprect_highness(r:MapgenRectangle):Void
	{
		if (r.highness >= 0)
			{
				//trace('mapwidth',width,'setting highness', r.highness, 'roomtype', r.room_type);
				var _h:Int = r.highness;
				var _x:Int = r.maxx+1;
				while (--_x >= r.x)
				{
					var _y:Int = r.maxy+1;
					while (--_y >= r.y)
					{
						highness[_x + _y * width] = _h;
						//trace('_x',_x,'_y',_y);
						
					}			
				}
			}
	}
	
	public function set_highness():Void
	{
		
		var arr:Array<MapgenRectangle> = Location.current_location.maprect.final_childs;
		var n:Int = arr.length;
		while(--n>=0)
		{
			maprect_highness(arr[n]);
		}
	}
	
}