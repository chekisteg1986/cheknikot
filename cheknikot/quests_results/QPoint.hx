package cheknikot.quests_results;

import cheknikot.dungeoncrawler.DC_GameObject;
import cheknikot.quests_results.conditions.QC_Event;

/**
 * ...
 * @author ...
 */
class QPoint
{
	// public static inline var EXIT:Int = 0;
	public static var positions:Array<QPoint> = new Array();

	public var ready:Bool = true;
	public var x:Int = 0;
	public var y:Int = 0;
	public var width:Int = 0;
	public var height:Int = 0;
	public var string_id:String = '1';

	public static var save_vars:Array<String> = ['x', 'y', 'width', 'height', 'string_id'];

	// public static var items:Array<String> = new Array();

	public function new() {}

	public function remove():Void
	{
		positions.remove(this);
	}

	public function result():Void
	{
		ready = false;
		Quest.event('reach ' + string_id);
	}

	public function contains(_x:Int, _y:Int):Bool
	{
		if (_x >= x)
			if (_x <= x + width)
				if (_y >= y)
					if (_y <= y + height)
						return true;
		return false;
	}
}
