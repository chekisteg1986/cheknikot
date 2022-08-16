package cheknikot.menus;

import cheknikot.MenuBase;
import cheknikot.MySlider;
import cheknikot.controllers.MobileMoving;
import cheknikot.sounds.MusicPlaying;
import cheknikot.sounds.MySounds;
import flixel.FlxG;
import flixel.FlxSprite;
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

	public var wasd_size:MySlider;
	public var wasd_position:MyFlxButton;

	public var ads:Float = 20;

	public var test_sound_func:Void->Void;

	public function new(MaxSize:Int = 0)
	{
		super(MaxSize);

		state = this;

		load_settings();

		var _size:Int = Math.floor(FlxG.width / 2);
		var _heigh:Int = Math.floor(FlxG.height / 20);
		var _dy:Int = Math.floor(FlxG.height / 9);
		var _thickness:Int = Math.floor(FlxG.height / 50);
		var _font_size:Int = 20;
		// general volume
		volume_slider = new MySlider(FlxG.sound, 'volume', 0, _dy, 0, 1, _size, _heigh, _thickness, FlxColor.WHITE, FlxColor.BROWN);
		volume_slider.setTexts('General Volume', false, '0', '100', _font_size);
		add(volume_slider);
		volume_slider.hoverAlpha = 1;
		volume_slider.screenCenter(FlxAxes.X);
		volume_slider.callback = function(f:Float)
		{
			if (test_sound_func != null)
				test_sound_func();
		}

		// sound volume
		sound_slider = new MySlider(FlxG.sound.defaultSoundGroup, 'volume', 0, _dy * 2, 0, 1, _size, _heigh, _thickness, FlxColor.WHITE, FlxColor.BROWN);
		sound_slider.setTexts('Sound Volume', false, '0', '100', _font_size);
		add(sound_slider);
		sound_slider.screenCenter(FlxAxes.X);
		sound_slider.callback = function(f:Float)
		{
			if (test_sound_func != null)
				test_sound_func();
		}

		// sound_slider.hoverSound = 'assets/sounds/magic1.wav';

		// music volume
		music_slider = new MySlider(MusicPlaying, 'max_volume', 0, _dy * 3, 0, 1, _size, _heigh, _thickness, FlxColor.WHITE, FlxColor.BROWN);
		music_slider.setTexts('Music Volume', false, '0', '100', _font_size);
		add(music_slider);
		music_slider.screenCenter(FlxAxes.X);
		music_slider.hoverAlpha = 1;

		// ads - 20 min 40 min 1hr , standart - 40
		ads_slider = new MySlider(this, 'ads', 0, _dy * 4, 10, 40, _size, _heigh, _thickness, FlxColor.WHITE, FlxColor.BROWN);
		ads_slider.setTexts('Show ADS every', true, '10 min', '40 min', _font_size);
		ads_slider.decimals = 0;
		// add(ads_slider);
		ads_slider.screenCenter(FlxAxes.X);
		ads_slider.hoverAlpha = 1;
		// wasd size
		wasd_size = new MySlider(MobileMoving, 'size', 0, _dy * 5, 1, 2, _size, _heigh, _thickness, FlxColor.GRAY, FlxColor.BROWN);
		wasd_size.setTexts('Joystick Size', false, '0', '100', _font_size);
		add(wasd_size);
		wasd_size.screenCenter(FlxAxes.X);
		wasd_size.hoverAlpha = 1;

		add(exit_btn);
		exit_btn.x = 10;

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
		MyMainMenu.state.show();
	}

	override function show()
	{
		super.show();
		if (MobileMoving.wasd != null)
		{
			wasd_size.value = MobileMoving.size;
			add(MobileMoving.wasd);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (MobileMoving.wasd != null)
		{
			MobileMoving.wasd.setting_scale(MobileMoving.size);
			MobileMoving.wasd.setting_positions(800 - 137 * MobileMoving.size, 600 - 91 * MobileMoving.size);
		}
	}
}
