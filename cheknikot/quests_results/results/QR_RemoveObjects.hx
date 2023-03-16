package cheknikot.quests_results.results;

import cheknikot.dungeoncrawler.DC_GameObject;
import cheknikot.dungeoncrawler.DC_screen;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author ...
 */
class QR_RemoveObjects extends QuestResult
{
	public static var save_vars:Array<String> = ['type', 'point', 'name'];

	public var point:String = 'string_id';
	public var name:String = 'all';

	public function new()
	{
		this.type = 'QC_RemoveObjects';
		super();
	}

	override public function make_result_actions():Void
	{
		super.make_result_actions();

		var x1:Int = -1;
		var y1:Int = -1;
		var x2:Int = -1;
		var y2:Int = -1;

		var _points:Array<QPoint> = AF.getObjectsWith(QPoint.positions, {string_id: point});

		if (_points.length != 0)
			for (_p in _points)
			{
				x1 = _p.x;
				y1 = _p.y;
				x2 = _p.x + _p.width;
				y2 = _p.y + _p.height;

				var _x:Int = x1;
				var _y:Int = y1;

				// trace('Removing +' + name + '+', name.length);

				while (_x <= x2)
				{
					_y = y1;
					while (_y <= y2)
					{
						var arr:Array<DC_GameObject> = DC_GameObject.get_objects_at(_x, _y);
						var _n:Int = arr.length;
						while (--_n >= 0)
							if (name == 'all' || arr[_n].string_id == name)
							{
								arr[_n].remove_from_map();
								trace('REMOVED');
							}
						_y++;
					}
					_x++;
				}
			}
		else
		{
			var arr:Array<DC_GameObject> = AF.getObjectsWith(DC_GameObject.objects, {string_id: name});
			var _n:Int = arr.length;
			while (--_n >= 0)
				arr[_n].remove_from_map();
		}
	}
}
