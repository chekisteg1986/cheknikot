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
	private static function add_sounds_to_default(arr:Array<FlxSound>):Void
	{
		for (s in arr)
			FlxG.sound.defaultSoundGroup.add(s);
	}

	public static function load_asset_to_array(_arr:Array<FlxSound>, _asset:Array<FlxSoundAsset>):Void
	{
		for (_ass in _asset)
			_arr.push(FlxG.sound.load(_ass));
	}

	public static function play(_arr:Array<FlxSound>, _volume:Float = 1):Void
	{
		FlxG.random.getObject(_arr).play().volume = _volume;
	}
}
