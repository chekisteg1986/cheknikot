package cheknikot.sounds;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Playlist 
{
	public static var all_playlists:Array<Playlist> = new Array();
	
	public var name:String;
	public var songs:Array<Song> = new Array();
	public var song_i:Int = 0;
	public var current_song:Song;
	public function new(_name:String) 
	{
		name = _name;
		all_playlists.push(this);
	}
	
	public static function get(_name:String):Playlist
	{
		for (pl in all_playlists)
		{
			if (pl.name == _name) return pl;
		}
		
		return null;
	}
	
	public function add_songs(arr:Array<String>):Void
	{
		for (as in arr)
		{
			var _s:Song = Song.get_song(as);
			songs.push(_s);
		}
		
		song_i = FlxG.random.int(0, songs.length - 1);
		current_song = songs[song_i];
	}
	
	public function next_track():Void
	{	
		song_i++;
		current_song.position = 0;
		if (song_i >= songs.length)
		{
			song_i = 0;
		}
		current_song = songs[song_i];
	}
	
}