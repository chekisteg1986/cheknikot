package cheknikot.sounds;

/**
 * ...
 * @author ...
 */

 
 import flixel.system.FlxAssets;
 import flixel.system.FlxSound;
 import flixel.FlxG;
class MySounds 
{
	private static var swing_arr:Array<FlxSound> = new Array();
	//private static var arrow_arr:Array<FlxSound> = new Array();
	//private static var electric_arr:Array<FlxSound> = new Array();
	private static var flame_arr:Array<FlxSound> = new Array();
	private static var magic_arr:Array<FlxSound> = new Array();
	private static var spiderbite_arr:Array<FlxSound> = new Array();
	private static var monster_1_arr:Array<FlxSound> = new Array();
	//private static var explosion_arr:Array<FlxSound> = new Array();
//	private static var troll_arr:Array<FlxSound> = new Array();
	private static var shoot_arr:Array<FlxSound> = new Array();
	//private static var coins_arr:Array<FlxSound> = new Array();
	//private static var bash_arr:Array<FlxSound> = new Array();
	private static var summon_arr:Array<FlxSound> = new Array();
	
	public static var open_door_snd:FlxSound;
	
	/*public static var click_door_snd:FlxSound;
	public static var spider_queen_snd:FlxSound;
	public static var switch_snd:FlxSound;
	public static var lich_snd:FlxSound;
	public static var breakwall_snd:FlxSound;
	public static var flame_aura_snd:FlxSound;
	public static var mystic_strike_snd:FlxSound;
	public static var ward_snd:FlxSound;*/
	
	
	
	
	
	public static function init():Void
	{
		MusicPlaying.init();
	}
	
	
	
	
	public static function open_door():Void
	{
			//open_door_snd.volume = max_volume;
			open_door_snd.play();
	}
	
	public static function load_sounds():Void
	{
		function add_arr(arr:Array<FlxSound>):Void
		{
			for (s in arr) FlxG.sound.defaultSoundGroup.add(s);
		}
		function _add(_arr:Array<FlxSound>, _d:Dynamic):Void
		{
			_arr.push(FlxG.sound.load(_d));
		}
		function  _snd(_d:Dynamic):FlxSound
		{
			var s:FlxSound = FlxG.sound.load(_d);
			FlxG.sound.defaultSoundGroup.add(s);
			return s;
		}
		
		//flame_aura_snd = FlxG.sound.load(AssetPaths.flame_aura__wav);
		//lich_snd  = FlxG.sound.load(AssetPaths.ScaryGirl__wav);
		open_door_snd = FlxG.sound.load(AssetPaths.door__wav);
		//click_door_snd = FlxG.sound.load(AssetPaths.doorhclick__wav);
		//spider_queen_snd = FlxG.sound.load(AssetPaths.spider_queen__wav);
		//switch_snd = FlxG.sound.load(AssetPaths.Switch2__wav);
		//breakwall_snd = FlxG.sound.load(AssetPaths.trashcan2__wav);
		
		
		FlxG.sound.defaultSoundGroup.add(open_door_snd);
		
		/*FlxG.sound.defaultSoundGroup.add(lich_snd);		
		FlxG.sound.defaultSoundGroup.add(click_door_snd);
		FlxG.sound.defaultSoundGroup.add(spider_queen_snd);
		FlxG.sound.defaultSoundGroup.add(switch_snd);
		FlxG.sound.defaultSoundGroup.add(breakwall_snd);
		FlxG.sound.defaultSoundGroup.add(flame_aura_snd);
		
		mystic_strike_snd = _snd(AssetPaths.mystic_strike__wav);
		ward_snd = _snd(AssetPaths.ward__wav);
		*/
		
		
		_add(shoot_arr, AssetPaths.shoot1__wav);
		_add(shoot_arr, AssetPaths.shoot2__wav);
		_add(shoot_arr, AssetPaths.shoot3__wav);
		_add(shoot_arr, AssetPaths.shoot4__wav);
		_add(shoot_arr, AssetPaths.shoot5__wav);
		add_arr(shoot_arr);
		
		_add(summon_arr, AssetPaths.summon1__wav);
		_add(summon_arr, AssetPaths.summon2__wav);
		add_arr(summon_arr);
		
		
		/*
		_add(coins_arr, AssetPaths.coin1__wav);
		_add(coins_arr, AssetPaths.coin2__wav);
		add_arr(coins_arr);
		
		
		_add(bash_arr, AssetPaths.bash_1__wav);
		_add(bash_arr, AssetPaths.bash_2__wav);
		_add(bash_arr, AssetPaths.bash_3__wav);
		add_arr(bash_arr);
		*/
		
		
	/*
			troll_arr.push(FlxG.sound.load(AssetPaths.ogre1__wav));
			troll_arr.push(FlxG.sound.load(AssetPaths.ogre2__wav));
			troll_arr.push(FlxG.sound.load(AssetPaths.ogre3__wav));
			troll_arr.push(FlxG.sound.load(AssetPaths.ogre4__wav));
			troll_arr.push(FlxG.sound.load(AssetPaths.ogre5__wav));
			//troll_arr.push(FlxG.sound.load(AssetPaths.ogre6__wav));
			add_arr(troll_arr);
		*/
		
		/*
			explosion_arr.push(FlxG.sound.load(AssetPaths.Explosion1__wav));
			explosion_arr.push(FlxG.sound.load(AssetPaths.Explosion2__wav));
			explosion_arr.push(FlxG.sound.load(AssetPaths.Explosion3__wav));
			add_arr(explosion_arr);
		*/
		
		//for (n in [2, 3, 6])
		{
			//var s:FlxSound = FlxG.sound.load(Reflect.getProperty(AssetPaths, 'mnstr' + n + '__wav'));
			monster_1_arr.push(FlxG.sound.load(AssetPaths.mnstr2__wav));
			monster_1_arr.push(FlxG.sound.load(AssetPaths.mnstr3__wav));
			monster_1_arr.push(FlxG.sound.load(AssetPaths.mnstr6__wav));
			add_arr(monster_1_arr);
		}
		//for ( n in 1...4)
		{
			//var s:FlxSound = FlxG.sound.load(Reflect.getProperty(AssetPaths, 'bite_small' + n + '__wav'));
			//.push(s);
			spiderbite_arr.push(FlxG.sound.load(AssetPaths.bite_small1__wav));
			spiderbite_arr.push(FlxG.sound.load(AssetPaths.bite_small2__wav));
			spiderbite_arr.push(FlxG.sound.load(AssetPaths.bite_small3__wav));
			add_arr(spiderbite_arr);
		}
		
		{
			//var s:FlxSound = FlxG.sound.load(Reflect.getProperty(AssetPaths, 'magic' + n + '__wav'));
			//trace('LOAD MAGIC SOUND', n);
			magic_arr.push(FlxG.sound.load(AssetPaths.magic1__wav));
			add_arr(magic_arr);
		}
		//for ( n in 1...6)
		{
			//var s:FlxSound = FlxG.sound.load(Reflect.getProperty(AssetPaths, 'sword_unsheathe' + n + '__wav'));
			swing_arr.push(FlxG.sound.load(AssetPaths.sword_unsheathe1__wav));
			swing_arr.push(FlxG.sound.load(AssetPaths.sword_unsheathe2__wav));
			swing_arr.push(FlxG.sound.load(AssetPaths.sword_unsheathe3__wav));
			swing_arr.push(FlxG.sound.load(AssetPaths.sword_unsheathe4__wav));
			swing_arr.push(FlxG.sound.load(AssetPaths.sword_unsheathe5__wav));
			add_arr(swing_arr);
		}
		//for ( n in 1...4)
		{
			
			/*
			arrow_arr.push(FlxG.sound.load(AssetPaths.swing1__wav));
			arrow_arr.push(FlxG.sound.load(AssetPaths.swing1__wav));
			arrow_arr.push(FlxG.sound.load(AssetPaths.swing1__wav));
			add_arr(arrow_arr);
			*/
		}
		//for ( n in 1...3)
		{
			
			/*
			electric_arr.push(FlxG.sound.load(AssetPaths.electric1__wav));
			electric_arr.push(FlxG.sound.load(AssetPaths.electric2__wav));
			add_arr(electric_arr);
			*/
		}
		//for ( n in 1...2)
		{
			//var s:FlxSound = FlxG.sound.load(Reflect.getProperty(AssetPaths, 'flame' + n + '__wav'));
			flame_arr.push(FlxG.sound.load(AssetPaths.flame1__wav));
			add_arr(flame_arr);
		}
		
	}
	
	public static function monster_1():Void
	{
		//var s:FlxSound = 
		FlxG.random.getObject(monster_1_arr).play();
		//if (!s.playing)
		//{
			//s.play();
		//}
	}
	

	public static function summon():Void
	{
		FlxG.random.getObject(summon_arr).play();
	}
	public static function shoot():Void
	{
		FlxG.random.getObject(shoot_arr).play();
	}
	
	public static function flame():Void
	{
		FlxG.random.getObject(flame_arr).play();
	}

	public static function swing():Void
	{
		FlxG.random.getObject(swing_arr).play();
		//var s:FlxSound = FlxG.random.getObject(swing_arr);
		//if (!s.playing)
		//{
			//s.play();
		//}
	}
	public static function spiderbite():Void
	{
		//var s:FlxSound = 
		FlxG.random.getObject(spiderbite_arr).play();
		//if (!s.playing)
		//{
			//s.play();
		//}
	}
	
	public static function magic():Void
	{
		//var s:FlxSound = 
		FlxG.random.getObject(magic_arr).play();

	}
	
}