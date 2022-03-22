package cheknikot.pathfinding.sidescroll;

import cheknikot.pathfinding.PathMapBase;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
/**
 * ...
 * @author ...
 */
class PathMapSS extends PathMapBase 
{

	public static var state:PathMapSS;
	public function new() 
	{
		super();
		state = this;
		
		WaySection.diap_y_minus = -2;
		
		WaySection.mp_dx = Math.floor(GameParams.TILE_SIZE / 2);
		WaySection.mp_dy = GameParams.TILE_SIZE;
		
	}
	override function can_walk_here(_x:Int, _y:Int):Bool
	{
		
		var _walls:FlxTilemap = LocalGame.state.walls;
		var _ladders:FlxTilemap = LocalGame.state.ladders;
		
		if (_x < 0 || _y < 0) return false;
		if (_x >= _walls.widthInTiles || _y >= (_walls.heightInTiles - 1)) return false;
		
		var _tile:Int = _walls.getTile(_x, _y);
		if (_walls.getTileCollisions(_tile) != FlxObject.ANY)
		{
			_tile = _walls.getTile(_x, _y + 1);
			var ladder_tile:Int = _ladders.getTile(_x, _y + 1);
			if (_walls.getTileCollisions(_tile) == FlxObject.ANY || _walls.getTileCollisions(_tile) == FlxObject.CEILING 
			|| _ladders.getTileCollisions(ladder_tile) == FlxObject.CEILING)
			{
				return true;
			}
		}
		return false;
	}
	
	
	
}