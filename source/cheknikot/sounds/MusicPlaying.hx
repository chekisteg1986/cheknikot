package cheknikot.sounds;

import flixel.FlxG;
/**
 * ...
 * @author ...
 */
class MusicPlaying 
{

	//private static var music_list:Array<Dynamic>;
	private static var current_track_i:Int = 0;
	
	
	
	public static var current_playlist:Playlist;	
	//menu
	private static var all_music:Array<Song> = new Array();
	//private static var all_music_positions:Array<Float> = new Array();
	
	
	public static var playlist_menu:Playlist = new Playlist('menu');	
	public static var playlist_global:Playlist = new Playlist('global');	
	public static var playlist_adventure:Playlist = new Playlist('adventure');	
	public static var playlist_battle:Playlist = new Playlist('battle');	
	
	
	public static function init():Void
	{
		/*
		#if flash
			playlist_menu.add_songs([AssetPaths.Dragons_Breath_Short__mp3]);
			playlist_global.add_songs([AssetPaths.Outdoors__mp3, AssetPaths.Prince_Patrick__mp3, AssetPaths.Dragon_Breath_Full__mp3]);
			playlist_adventure.add_songs([AssetPaths.Creature__mp3, AssetPaths.Stormy_Sky__mp3, AssetPaths.Dragons_Breath_Short__mp3]);
			playlist_battle.add_songs([AssetPaths.Escapist__mp3, AssetPaths.Bostly_Hustled__mp3, AssetPaths.Dragons_Breath_Short__mp3]);
			
		#else
			playlist_menu.add_songs([AssetPaths.Dragons_Breath_Short__ogg]);
			playlist_global.add_songs([AssetPaths.Outdoors__ogg, AssetPaths.Prince_Patrick__ogg, AssetPaths.Dragon_Breath_Full__ogg]);
			playlist_adventure.add_songs([AssetPaths.Creature__ogg, AssetPaths.Stormy_Sky__ogg, AssetPaths.Dragons_Breath_Short__ogg]);
			playlist_battle.add_songs([AssetPaths.Escapist__ogg, AssetPaths.Bostly_Hustled__ogg, AssetPaths.Dragons_Breath_Short__ogg]);
		#end
		current_playlist = playlist_menu;
		*/
		#if flash
		playlist_menu.add_songs([AssetPaths.cossacks__mp3]);
		playlist_adventure.add_songs([AssetPaths.vpered__mp3, AssetPaths.characternik__mp3, AssetPaths.polushko__mp3]);
		#else
		playlist_menu.add_songs([AssetPaths.cossacks__ogg]);
		playlist_adventure.add_songs([AssetPaths.vpered__ogg, AssetPaths.characternik__ogg, AssetPaths.polushko__ogg]);
		
		#end
		max_volume = 0.45;
	}
	
	
	
	public static var max_volume:Float=1;
	public static function play_music():Void
	{
		
			FlxG.sound.playMusic(current_playlist.current_song.asset, max_volume, false);
	}
	
	
	public static function update_volume():Void
	{
		var dm:Float = max_volume / 20;
		
		if (FlxG.sound.music.volume > max_volume) FlxG.sound.music.volume = max_volume;
		
		if (next_playlist == null)
		{
			if (FlxG.sound.music.volume < max_volume)
			{
				//trace('raising music', FlxG.sound.music.volume);
				FlxG.sound.music.volume+= dm;
				if (FlxG.sound.music.volume > max_volume) FlxG.sound.music.volume = 1;
			}
		}
		else
		{
			if (FlxG.sound.music.volume > 0)
			{
				
				FlxG.sound.music.volume-= dm;
				//trace('lovering music',FlxG.sound.music.volume);
				if (FlxG.sound.music.volume <= 0) 
				{
					FlxG.sound.music.volume = 0;
					trace('save position', FlxG.sound.music.time);
					current_playlist.current_song.position = FlxG.sound.music.time;
					current_playlist = next_playlist;
					next_playlist = null;
					trace(' setting next playlist',current_playlist.name);
					resume_playlist();
					
				}
			}
		}
		
	}
	
	
	public static function resume_playlist():Void
	{
		trace('resuming at ',current_playlist.current_song.position);
		FlxG.sound.playMusic(current_playlist.current_song.asset, 0, false);
		FlxG.sound.music.time = current_playlist.current_song.position;
		
	}
	
	
	public static function check_playing():Void
	{
		
		
		
		if (FlxG.sound.music == null)
		{
			//trace('music NULL');
		}
		else
		if (!FlxG.sound.music.playing)
		{
			trace('Новый трек', current_track_i);
			current_playlist.next_track();
			play_music();
		}
		else
		{
			update_volume();
		}
		
		
	}
	
	
	
	public static var next_playlist:Playlist = null;
	//public static var current_song:Song;
	
	public static function set_playlist_name(s:String):Void
	{
		set_playlist(AF.get_object_with(Playlist.all_playlists, 'name', s)); 
	}
	
	public static function set_playlist(_new:Playlist):Void
	{
		trace('set playlist ', _new);
		
		if ( _new == null) return;
		
		trace(_new.name);
		
		if (_new == current_playlist)
		{
			trace('same playlist');
			next_playlist = null;
			check_playing();
			return;
		}
		
		
		//current_song = null;
		var current_song:Song = null;
		if (FlxG.sound.music != null)
		if(current_playlist != null)
		{
			trace('current playlist',current_playlist.name);
			current_song = current_playlist.current_song;
			if (current_song == null)
			{
				
			}
		}
		
		
		next_playlist = _new;
		var have_song:Int = _new.songs.indexOf(current_song);
		if ( have_song != -1)
		{
			trace('same music');
			current_playlist = next_playlist;
			next_playlist.song_i = have_song;
			next_playlist = null;
			return;
		}
		
		
		//next_playlist.song_i = have_song;
		
		
	}
	
}