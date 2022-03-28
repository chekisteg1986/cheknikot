package cheknikot.sounds;

/**
 * ...
 * @author ...
 */
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;

class MySounds
{
	private static var swing_arr:Array<FlxSound> = new Array();
	// private static var arrow_arr:Array<FlxSound> = new Array();
	// private static var electric_arr:Array<FlxSound> = new Array();
	private static var flame_arr:Array<FlxSound> = new Array();
	private static var magic_arr:Array<FlxSound> = new Array();
	private static var spiderbite_arr:Array<FlxSound> = new Array();
	private static var monster_1_arr:Array<FlxSound> = new Array();
	// private static var explosion_arr:Array<FlxSound> = new Array();
	//	private static var troll_arr:Array<FlxSound> = new Array();
	private static var shoot_arr:Array<FlxSound> = new Array();
	// private static var coins_arr:Array<FlxSound> = new Array();
	// private static var bash_arr:Array<FlxSound> = new Array();
	private static var summon_arr:Array<FlxSound> = new Array();

	public static var open_door_snd:FlxSound;

	/*public static var click_door_snd:FlxSound;
		public static var spider_queen_snd:FlxSound;
		public static var switch_snd:FlxSound;
		public static var lich_snd:FlxSound;
		public static var breakwall_snd:FlxSound;
		public static var flame_aura_snd:FlxSound;
		public static var mystic_strike_snd:FlxSound;
		public static var ward_snd:FlxSound; */
	public static function init():Void
	{
		MusicPlaying.init();
	}

	public static function test_sound():Void {}

	public static function open_door():Void
	{
		// open_door_snd.volume = max_volume;
		open_door_snd.play();
	}

	public static function load_sounds():Void
	{
		function add_arr(arr:Array<FlxSound>):Void
		{
			for (s in arr)
				FlxG.sound.defaultSoundGroup.add(s);
		}
		function _add(_arr:Array<FlxSound>, _d:Dynamic):Void
		{
			_arr.push(FlxG.sound.load(_d));
		}
		function _snd(_d:Dynamic):FlxSound
		{
			var s:FlxSound = FlxG.sound.load(_d);
			FlxG.sound.defaultSoundGroup.add(s);
			return s;
		}

		/*
			electric_arr.push(FlxG.sound.load(AssetPaths.electric1__wav));
			electric_arr.push(FlxG.sound.load(AssetPaths.electric2__wav));
			add_arr(electric_arr);
		 */
	}
}
