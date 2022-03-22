package cheknikot;
import flixel.math.FlxPoint;

/**
 * ...
 * @author ...
 */
class IntPoint 
{
	public var x:Int = 0;
	public var y:Int = 0;
	public var name:String = null;
	private var flxp:FlxPoint = null;

	public function new(_x:Int,_y:Int,_name:String = null) 
	{
		x = _x;
		y = _y;
		name = _name;
	}
	public function flxpoint():FlxPoint
	{
		if (flxp == null) flxp = new FlxPoint();
		flxp.set(x, y);
		return flxp;
	}
	
}