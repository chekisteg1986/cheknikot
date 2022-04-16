package cheknikot.quests_results.results;

import flixel.tile.FlxTilemap;

/**
 * ...
 * @author ...
 */
class QR_SetTileRect extends QuestResult
{
	public static var save_vars:Array<String> = ['type', 'x1', 'y1', 'x2', 'y2', 'tile', 'point'];

	public var x1:Int = -1;
	public var y1:Int = -1;
	public var x2:Int = -1;
	public var y2:Int = -1;
	public var tile:Int = 0;
	public var point:String = 'point';

	public static var set_tile_wall:Int->Int->Int->Void;

	public function new()
	{
		this.type = 'QC_SetTileRect';
		super();
	}

	override public function make_result_actions():Void
	{
		super.make_result_actions();

		var _p:QPoint = AF.getObjectWith(QPoint.positions, {type: point});

		if (_p != null)
		{
			x1 = _p.x;
			y1 = _p.y;
			x2 = _p.x + _p.width;
			y2 = _p.y + _p.height;
		}

		var _x:Int = x1;
		var _y:Int = y1;

		if (x2 == -1)
			x2 = x1;
		if (y2 == -1)
			y2 = y1;

		while (_x <= x2)
		{
			_y = y1;
			while (_y <= y2)
			{
				set_tile_wall(_x, _y, tile);

				_y++;
			}
			_x++;
		}
	}
}
