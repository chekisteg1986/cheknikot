package cheknikot.dungeoncrawler;

class DC_additional
{
	@:generic
	public static function put_in_line<T>(_arr:Array<T>, _facing:Int):Void
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

	private static function positions_face_S(_o1:DC_GameObject, _o2:DC_GameObject):Int
	{
		if (_o1.tile_dy < _o2.tile_dy)
			return -1;
		else if (_o1.tile_dy > _o2.tile_dy)
			return 1;
		else
			return 0;
	}

	private static function positions_face_N(_o1:DC_GameObject, _o2:DC_GameObject):Int
	{
		if (_o1.tile_dy < _o2.tile_dy)
			return 1;
		else if (_o1.tile_dy > _o2.tile_dy)
			return -1;
		else
			return 0;
	}

	private static function positions_face_E(_o1:DC_GameObject, _o2:DC_GameObject):Int
	{
		if (_o1.tile_dx < _o2.tile_dx)
			return -1;
		else if (_o1.tile_dx > _o2.tile_dx)
			return 1;
		else
			return 0;
	}

	private static function positions_face_W(_o1:DC_GameObject, _o2:DC_GameObject):Int
	{
		if (_o1.tile_dx < _o2.tile_dx)
			return 1;
		else if (_o1.tile_dx > _o2.tile_dx)
			return -1;
		else
			return 0;
	}

	public static function sortPositions(_objects:Array<DC_GameObject>, _camera_face:Int):Void
	{
		switch (_camera_face)
		{
			case 0:
				_objects.sort(positions_face_N);
			case 1:
				_objects.sort(positions_face_E);
			case 2:
				_objects.sort(positions_face_S);
			case 3:
				_objects.sort(positions_face_W);
		}
	}
}
