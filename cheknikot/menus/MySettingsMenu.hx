package cheknikot.menus;

import cheknikot.MenuBase;
import cheknikot.MySlider;
import cheknikot.sounds.MusicPlaying;
import cheknikot.sounds.MySounds;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUICheckBox;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

// import MySlider;

/**
 * ...
 * @author ...
 */
class MySettingsMenu extends MenuBase
{
	public static var state:MySettingsMenu;

	public var volume_slider:MySlider;
	public var sound_slider:MySlider;
	public var music_slider:MySlider;
	public var ads_slider:MySlider;

	public var ads:Float = 20;

	public function new(MaxSize:Int = 0)
	{
		super(MaxSize);

		state = this;

		load_settings();

		// general volume
		volume_slider = new MySlider(FlxG.sound, 'volume', 0, 0, 0, 1, 150, 15, 3, FlxColor.WHITE, FlxColor.BROWN);
		volume_slider.setTexts('General Volume', false, '0', '100');
		add(volume_slider);
		volume_slider.hoverAlpha = 1;
		volume_slider.screenCenter(FlxAxes.X);
		volume_slider.callback = function(f:Float)
		{
			MySounds.test_sound();
		}

		// sound volume
		sound_slider = new MySlider(FlxG.sound.defaultSoundGroup, 'volume', 0, 40, 0, 1, 150, 15, 3, FlxColor.WHITE, FlxColor.BROWN);
		sound_slider.setTexts('Sound Volume', false, '0', '100');
		add(sound_slider);
		sound_slider.screenCenter(FlxAxes.X);
		sound_slider.callback = function(f:Float)
		{
			MySounds.test_sound();
		}

		// sound_slider.hoverSound = 'assets/sounds/magic1.wav';

		// music volume
		music_slider = new MySlider(MusicPlaying, 'max_volume', 0, 80, 0, 1, 150, 15, 3, FlxColor.WHITE, FlxColor.BROWN);
		music_slider.setTexts('Music Volume', false, '0', '100');
		add(music_slider);
		music_slider.screenCenter(FlxAxes.X);
		music_slider.hoverAlpha = 1;

		// ads - 20 min 40 min 1hr , standart - 40
		ads_slider = new MySlider(this, 'ads', 0, 120, 10, 40, 150, 15, 3, FlxColor.WHITE, FlxColor.BROWN);
		ads_slider.setTexts('Show ADS every', true, '10 min', '40 min');
		ads_slider.decimals = 0;
		add(ads_slider);
		ads_slider.screenCenter(FlxAxes.X);
		ads_slider.hoverAlpha = 1;

		add(exit_btn);

		set_scroll();
	}

	public function save_settings():Void
	{
		var settings_slot = new FlxSave();

		settings_slot.bind('settings');

		settings_slot.data.volume = FlxG.sound.volume;
		settings_slot.data.sound = FlxG.sound.defaultSoundGroup.volume;
		settings_slot.data.music = MusicPlaying.max_volume;
		settings_slot.data.ads = ads;
		settings_slot.data.init = 'inited';
		settings_slot.close();
	}

	public function load_settings():Void
	{
		var settings_slot = new FlxSave();
		settings_slot.bind('settings');
		if (settings_slot.data.init != 'inited')
		{
			save_settings();
			return;
		}

		FlxG.sound.volume = settings_slot.data.volume;
		FlxG.sound.defaultSoundGroup.volume = settings_slot.data.sound;
		MusicPlaying.max_volume = settings_slot.data.music;
		ads = settings_slot.data.ads;
		settings_slot.close();
	}

	override public function exit_click():Void
	{
		super.exit_click();

		save_settings();
		// FirstState.state.remove(this, true);
		// MainMenu.show();
	}
}
