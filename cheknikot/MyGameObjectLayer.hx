package cheknikot;

// import locationmap.game_objects.*;
import cheknikot.AF;
import cheknikot.game_objects.BaseCharacter;
import cheknikot.game_objects.GameObject;
import cheknikot.questeditor.QuestEditor;
import cheknikot.quests_results.Quest;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import openfl.utils.Assets;

class MyGameObjectLayer extends FlxGroup
{
	private var ogmo_map:FlxOgmo3Loader;

	public var player:cheknikot.game_objects.BaseCharacter;

	public var ground:FlxTilemap;
	public var ladders:FlxTilemap;
	public var walls:FlxTilemap;
	public var shooting_walls:FlxTilemap;
	public var shadow:FlxTilemap;

	public var ground_sprites:MyFlxTypedGroup<FlxSprite> = new MyFlxTypedGroup('GRND SPR');
	public var isometric_sprites:MyFlxTypedGroup<GameObject> = new MyFlxTypedGroup('ISO SPR');
	public var over_sprites:MyFlxTypedGroup<FlxSprite> = new MyFlxTypedGroup('OVER SPR');
	public var isometric_sprites_on_screen:MyFlxTypedGroup<GameObject> = new MyFlxTypedGroup('ISO_ON');
	public var effects:MyFlxGroup = new MyFlxGroup('EFFECTS');

	public var clickable_objects:Array<GameObject> = new Array();
	public var active_objects:Array<GameObject> = new Array();

	public var camera_point:FlxSprite;

	public var positions:Array<IntPoint> = new Array();
	public var speed_mlt:Int = 1;

	public static var state:MyGameObjectLayer;

	public var back_spr:FlxSprite;

	public function new()
	{
		super();
		// messanger  = new GameMessage();
		camera_point = new FlxSprite();
		camera_point.makeGraphic(1, 1);

		visible = false;
		GameObject.isometric_sprites_on_screen = isometric_sprites_on_screen;
		GameObject.isometric_sprites = isometric_sprites;
		state = this;
		back_spr = new FlxSprite();
		back_spr.scrollFactor.set(0, 0);
		back_spr.visible = false;
	}

	public function make_shooting_walls():Void
	{
		if (shooting_walls != null)
			shooting_walls.destroy();
		shooting_walls = new FlxTilemap();
		shooting_walls.loadMapFromArray(walls.getData(), walls.widthInTiles, walls.heightInTiles, walls.graphic.assetsKey, GameParams.TILE_SIZE,
			GameParams.TILE_SIZE);
	}

	public function background(_ass:FlxGraphicAsset):Void
	{
		back_spr.loadGraphic(_ass);
		AF.scale_picture(back_spr);
		back_spr.visible = false;
	}

	public function clear_all():Void
	{
		trace('================== CLEAR DATA ==============');

		AF.clear_array(positions);
		AF.clear_array(clickable_objects);
		isometric_sprites.clear();
		isometric_sprites_on_screen.clear();
		over_sprites.clear();
		AF.clear_array(active_objects);

		/*

			function clear_group(gr:Dynamic):Void
			{
				
				var members:Array<Dynamic> = Reflect.getProperty(gr, 'members');
				for (o in members) 
				if(o!= null)
				{
					o.destroy();
				}
				gr.clear();
		}*/

		effects.clear();

		remove(ground, true);
		remove(ladders, true);
		remove(walls, true);
		remove(shadow, true);

		if (ground != null)
			ground.destroy();
		if (ladders != null)
			ladders.destroy();
		if (walls != null)
			walls.destroy();
		if (shadow != null)
			shadow.destroy();
	}

	public function load_level(_filename:String, _shoot_map:Bool = false):Void
	{
		ogmo_load_map(_filename);

		if (_shoot_map)
			make_shooting_walls();

		Quest.load_quests(_filename);

		#if flash
		walls.follow(FlxG.camera, -5);
		#else
		walls.follow(null, -5);
		#end

		// set_all_collosion();

		add_objects();
		show();
		connect_vars();
		set_all_collosion();
	}

	private function ogmo_load_map(_filename:String):Void
	{
		// ogmo_map = new FlxOgmoLoader('assets/data/'+_filename+'.oel');
	}

	public function set_all_collosion(_walls:FlxTilemap = null):Void
	{
		// trace('SET ALL  COLLOSION',walls);
	}

	public function set_collosion(tilemap:FlxTilemap, index:Int, collosion:Int, collide_f:FlxObject->FlxObject->Void = null):Void
	{
		var variant:Int = GameParams.TILE_VARIATIONS;
		var n:Int = index * variant - 1;

		// var passable_indexes:Array<Int> = [6];

		while (++n < (index * variant + variant))
		{
			if (tilemap != null)
			{
				trace('collosion', n, collosion);
				tilemap.setTileProperties(n, collosion, collide_f);
			}
		}
	}

	private function add_objects():Void
	{
		trace('walls', walls);
		trace('shadow', shadow);
		clear();
		add(camera_point);
		add(back_spr);

		if (ground != null)
			add(ground);
		if (ladders != null)
			add(ladders);
		add(ground_sprites);
		add(isometric_sprites_on_screen);
		if (walls != null)
			add(walls);
		add(over_sprites);
		add(effects);
		if (shadow != null)
			add(shadow);
	}

	override public function update(elapsed:Float):Void
	{
		elapsed = elapsed * speed_mlt;

		super.update(elapsed);

		for (go in isometric_sprites)
		{
			if (go != null)
				if (go.alive)
					go.check_enter_screen();
		}
		for (go in isometric_sprites_on_screen)
		{
			if (go != null)
				if (go.alive)
					go.check_leave_screen();
		}

		// isometric_sprites_on_screen.sort(FlxSort.byY);

		if (!pause)
		{
			var _n:Int = active_objects.length;
			while (--_n >= 0)
			{
				if (!active_objects[_n].on_screen)
					active_objects[_n].update(elapsed);
				// active_objects[_n].actions();
			}

			if (player != null)
			{
				camera_point.x = player.getMidpoint().x;
				camera_point.y = player.getMidpoint().y;
			}
		}
	}

	public var pause:Bool = false;

	public function connect_vars():Void
	{
		// trace('connect vars');
	}

	public function hide():Void
	{
		FlxG.state.remove(this, true);
		active = visible = false;
	}

	public function show():Void
	{
		active = visible = true;
		FlxG.state.remove(this, true);
		FlxG.state.add(this);

		FlxG.camera.follow(camera_point, FlxCameraFollowStyle.NO_DEAD_ZONE, 0);
	}

	// private var decorations_over_list:Array<String> = ['gobelen_1'];
}
