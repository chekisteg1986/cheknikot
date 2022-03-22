package cheknikot.pathfinding.topdown;
import cheknikot.pathfinding.WaySection;

/**
 * ...
 * @author ...
 */
class PathfindMemory 
{

	public var section_path:Array<WaySection> = new Array();
	public var finded:Bool = false;
	
	public var ws1:WaySection;
	public var ws2:WaySection;
	//save to AI memory
	public var active_sections:Array<WaySection>;
		//индекс текущей секции
	public var last_i:Int = -1;
	
		//чему предшествовало
	public var last_ws:Array<WaySection> = new Array();
	
	
	
	
	public function new(_ws1:WaySection,_ws2:WaySection) 
	{
		ws1 = _ws1;
		ws2 = _ws2;
		active_sections = [ws2];
		last_ws[_ws2.number] = _ws2;
	}
	
}