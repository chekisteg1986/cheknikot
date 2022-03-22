package cheknikot;

/**
 * ...
 * @author ...
 */
class IntRectangle 
{
	public var x:Int = 0;
	public var y:Int = 0;
	public var width:Int = 0;
	public var height:Int = 0;
	
	public var maxx:Int = 0;
	public var maxy:Int = 0;

	public function new(_x:Int, _y:Int, _w:Int,_h:Int) 
	{
		x = _x;
		y = _y;
		width = _w;
		height = _h;
		
		maxx = x + width;
		maxy = y + height;
	}
	
}