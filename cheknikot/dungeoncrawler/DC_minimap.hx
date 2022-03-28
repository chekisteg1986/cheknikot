package cheknikot.dungeoncrawler;

// import cheknikot.MenuBase;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

// import flixel.group.FlxSpriteGroup;
// import flixel.system.FlxAssets.*;

/**
 * ...
 * @author ...
 */
class DC_minimap
{
	public var tilemap:FlxTilemap;
	public var mm_tilemap:FlxTilemap;
	public var connected_to:DC_GameObject;
	public var arrow:FlxSprite;
	public var range:Int = 0;
	public var tile_size:Int;

	public function new(_range:Int = 3)
	{
		range = _range;

		arrow = new FlxSprite();
		arrow.loadGraphic(AssetPaths.mm_arrow__png);
		// create_tilemap();
	}

	public function create_tilemap(_x:Float, _y:Float, _tile_size:Int):Void
	{
		// if (_as == null) return;

		if (mm_tilemap != null)
			return; // remove(mm_tilemap, true);
		// if (tilemap == null) return;

		tile_size = _tile_size;

		var _size:Int = 1 + range * 2;

		mm_tilemap = new FlxTilemap();
		var _arr:Array<Int> = new Array();
		var _len:Int = _size * _size;
		while (--_len >= 0)
			_arr.push(0);

		mm_tilemap.loadMapFromArray(_arr, _size, _size, AssetPaths.minimap_tileset__png, _tile_size, _tile_size);

		mm_tilemap.x = _x;
		mm_tilemap.y = _y;
		arrow.x = _x + range * tile_size + tile_size / 2 - arrow.frameWidth / 2;
		arrow.y = _y + range * tile_size + tile_size / 2 - arrow.frameWidth / 2;

		mm_tilemap.scrollFactor.set(0, 0);
		arrow.scrollFactor.set(0, 0);
	}

	public function update():Void
	{
		// trace('minimap',mm_tilemap.x,mm_tilemap.y,connected_to);

		var _x:Int = range + 1;
		var _tile_x:Int;
		var _tile_y:Int;

		if (connected_to == null)
			return;

		arrow.angle = 90 * connected_to.NESW_facing;

		while (--_x >= -range)
		{
			_tile_x = connected_to.tile_x + _x;

			var _y:Int = range + 1;
			while (--_y >= -range)
			{
				_tile_y = connected_to.tile_y + _y;

				if (_tile_x < 0 || _tile_y < 0 || _tile_x >= tilemap.widthInTiles || _tile_y >= tilemap.heightInTiles)
				{
					mm_tilemap.setTile(range + _x, range + _y, 0);
				}
				else
				{
					var _t:Int = tilemap.getTile(_tile_x, _tile_y);
					mm_tilemap.setTile(range + _x, range + _y, _t);
				}
			}
		}
	}
}
