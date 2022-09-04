package cheknikot.dungeoncrawler;

class DC_additional
{
	@:generic
	public static function put_in_line(_arr:Array<T>, _facing:Int):Void
	{
		var _n:Int = _arr.length;
		var _dx:Float = 1 / (_n + 1);

		var _go:DC_GameObject = null;
		while (--_n >= 0)
		{
			_go = cast(_arr[_n], DC_GameObject);
			switch (_facing)
			{
				case 0:
					_go.tile_dx = _dx * (_n + 1);
				case 1:
					_go.tile_dy = _dx * (_n + 1);
				case 2:
					_go.tile_dx = 1 - _dx * (_n + 1);
				case 3:
					_go.tile_dy = 1 - _dx * (_n + 1);
			}
		}
	}
}
