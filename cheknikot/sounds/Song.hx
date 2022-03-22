package cheknikot.sounds;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Song 
{
	public static var all_songs:Array<Song> = new Array();
	
	public var asset:Dynamic;
	public var position:Float=0;
	
	public function new() 
	{		
	}
	
	public static function get_song(_ass:Dynamic):Song
	{
		for (_song  in all_songs)
		{
			if (_song.asset == _ass) return _song;
		}
		var _s:Song = new Song();
		_s.asset = _ass;
		all_songs.push(_s);
		
		return _s;
	}
	
}