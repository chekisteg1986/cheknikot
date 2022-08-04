package cheknikot.sounds;

import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class MusicPlaying
{
	// private static var music_list:Array<Dynamic>;
	private static var current_track_i:Int = 0;

	public static var current_playlist:Playlist;
	// menu
	private static var all_music:Array<Song> = new Array();

	// private static var all_music_positions:Array<Float> = new Array();
	public static var playlist_menu:Playlist = new Playlist('menu');
	public static var playlist_global:Playlist = new Playlist('global');
	public static var playlist_adventure:Playlist = new Playlist('adventure');
	public static var playlist_battle:Playlist = new Playlist('battle');

	public static function init():Void
	{
		// playlist_menu.add_songs([AssetPaths.cossacks__ogg]);
		// playlist_adventure.add_songs([AssetPaths.vpered__ogg, AssetPaths.characternik__ogg, AssetPaths.polushko__ogg]);

		max_volume = 0.45;
	}

	public static var max_volume:Float = 1;

	public static function play_music():Void
	{
		if (current_playlist == null)
			return;
		if (current_playlist.current_song == null)
			return;
		FlxG.sound.playMusic(current_playlist.current_song.asset, max_volume, false);
	}

	public static function update_volume():Void
	{
		var dm:Float = max_volume / 20;

		if (FlxG.sound.music.volume > max_volume)
			FlxG.sound.music.volume = max_volume;

		if (next_playlist == null)
		{
			if (FlxG.sound.music.volume < max_volume)
			{
				// trace('raising music', FlxG.sound.music.volume);
				FlxG.sound.music.volume += dm;
				if (FlxG.sound.music.volume > max_volume)
					FlxG.sound.music.volume = 1;
			}
		}
		else
		{
			if (FlxG.sound.music.volume > 0)
			{
				FlxG.sound.music.volume -= dm;
				// trace('lovering music',FlxG.sound.music.volume);
				if (FlxG.sound.music.volume <= 0)
				{
					FlxG.sound.music.volume = 0;
					trace('save position', FlxG.sound.music.time);
					current_playlist.current_song.position = FlxG.sound.music.time;
					current_playlist = next_playlist;
					next_playlist = null;
					trace(' setting next playlist', current_playlist.name);
					resume_playlist();
				}
			}
		}
	}

	public static function resume_playlist():Void
	{
		trace('resuming at ', current_playlist.current_song.position);
		FlxG.sound.playMusic(current_playlist.current_song.asset, 0, false);
		FlxG.sound.music.time = current_playlist.current_song.position;
	}

	public static function check_playing():Void
	{
		if (FlxG.sound.music == null)
		{
			// trace('music NULL');
		}
		else if (!FlxG.sound.music.playing)
		{
			// trace('New track', current_track_i);
			if (current_playlist != null)
			{
				current_playlist.next_track();
				play_music();
			}
			else {}
		}
		else
		{
			update_volume();
		}
	}

	public static var next_playlist:Playlist = null;

	// public static var current_song:Song;

	public static function set_playlist_name(s:String):Void
	{
		set_playlist(AF.getObjectWith(Playlist.all_playlists, {name: s}));
	}

	public static function set_playlist(_new:Playlist):Void
	{
		trace('set playlist ', _new);

		if (_new == null)
			return;

		trace(_new.name);

		if (_new == current_playlist)
		{
			trace('same playlist');
			next_playlist = null;
			check_playing();
			return;
		}

		// current_song = null;
		var current_song:Song = null;
		if (FlxG.sound.music != null)
			if (current_playlist != null)
			{
				trace('current playlist', current_playlist.name);
				current_song = current_playlist.current_song;
				if (current_song == null) {}
			}

		next_playlist = _new;
		var have_song:Int = _new.songs.indexOf(current_song);
		if (have_song != -1)
		{
			trace('same music');
			current_playlist = next_playlist;
			next_playlist.song_i = have_song;
			next_playlist = null;
			return;
		}

		// next_playlist.song_i = have_song;
	}
}
