package cheknikot.game_objects;

import cheknikot.pathfinding.PathMapBase;
import cheknikot.pathfinding.WaySection;
import flixel.FlxSprite;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
/**
 * ...
 * @author ...
 */
class GameObject extends FlxSprite 
{
	public static var isometric_sprites_on_screen:MyFlxTypedGroup<GameObject>;
	public static var isometric_sprites:MyFlxTypedGroup<GameObject>;
	public static var before_wayzones_fill:Array<GameObject> = new Array();
	public var on_screen:Bool = false;
	public var isometric:Bool = false;
		public var midpoint:FlxPoint = new FlxPoint();
		public var gravity:Bool = false; 
		public var on_ground:Bool = false;
		public var midpoint_spr:FlxSprite;
			public var legspoint:FlxPoint;
			public var attackpoint:FlxPoint;
			public var block_object:Bool = false;
			public var size:Int = 20;
		
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		legspoint = midpoint;
		attackpoint = midpoint;
	}
	
	public function onClick():Void
	{
		
	}
	
	public function before_wayzones():Void
	{
		
	}
	public function after_wayzones():Void
	{
		
	}
	
	public var legspoint_spr:FlxSprite;
	public function create_mp_spr():Void
	{
		midpoint_spr = new FlxSprite();
		midpoint_spr.makeGraphic(2, 2);
		
		legspoint_spr = new FlxSprite();
		legspoint_spr.makeGraphic(2, 2);
	}

	
	public var tile_index:Int;
	public var tile_x:Int;
	public var tile_y:Int;
	public function update_coords():Void
	{
		 getMidpoint(midpoint);
		 
		 tile_x = Math.floor(x / GameParams.TILE_SIZE);
		 tile_y = Math.floor(y / GameParams.TILE_SIZE);
	
		 
		 var _walls:FlxTilemap = MyGameObjectLayer.state.walls;
		 if (_walls != null)
		 {
			tile_index = tile_x + tile_y *_walls.widthInTiles;
		 }
	}
	
	public function add_to_map():Void
	{
		if (isometric)
		{
			isometric_sprites.add(this);
		}
		update_coords();
	}
	public function remove_from_map():Void
	{
		if (isometric)
		{
			isometric_sprites.remove(this, true);
			isometric_sprites_on_screen.remove(this, true);
		}
		MyGameObjectLayer.state.clickable_objects.remove(this);
		
	}
	override public function kill():Void 
	{
		super.kill();
		remove_from_map();
	}
	
	public function check_enter_screen():Void
	{
		
		if (!on_screen)
			if (isOnScreen(FlxG.camera))
			{
				
				on_screen = true;
				isometric_sprites_on_screen.add(this);
				//isometric_sprites.remove(this, true);
			}
	}
	public function check_leave_screen():Void
	{
	
		if(on_screen)
		if(!isOnScreen(FlxG.camera))
		{
			on_screen = false;
			isometric_sprites_on_screen.remove(this, true);
			//isometric_sprites.add(this);
		}
		
	}
	
	public function gravity_action(_e:Float):Void
	{
		velocity.y += 1000*_e;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (MyGameObjectLayer.state.pause) elapsed = 0;
		
		if (gravity) gravity_action(elapsed);
		
		super.update(elapsed);
		update_coords();
		
		if (midpoint_spr != null)
		{
			midpoint_spr.x = midpoint.x - 1;
			midpoint_spr.y = midpoint.y - 1;
			LocalGame.state.effects.add(midpoint_spr);
			legspoint_spr.x = legspoint.x - 1;
			legspoint_spr.y = legspoint.y - 1;
			LocalGame.state.effects.add(legspoint_spr);
		}
		
		//update_coords();
	}
	public function get_current_ws():WaySection
	{
		
		return PathMapBase.state.get_way_zone(this.legspoint);
	}
	
}