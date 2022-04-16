package cheknikot.menus;

import cheknikot.MyStandartText;
import cheknikot.questeditor.QuestEditor;
import flash.net.URLRequest;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

// import SettingsMenu;
// import flixel.system.FlxAssets;

/**
 * ...
 * @author ...
 */
class MyMainMenu extends MenuBase
{
	public static var state:MyMainMenu;

	private var start_game_btn:MyFlxButton;
	private var credits_btn:MyFlxButton;
	private var settings_btn:MyFlxButton;
	private var title:MyFlxText;
	private var title2:MyFlxText;
	private var FB:FlxButton;
	private var version_txt:FlxText;

	private var erase:FlxSpriteGroup;
	private var erase_txt:MyFlxText;
	private var erase_yes:MyFlxButton;
	private var erase_no:MyFlxButton;
	private var erase_back:FlxSprite;

	private function erase_yes_click():Void
	{
		// saving.SaveLoad.erase_slot();

		remove(continue_btn, true);
		remove_all_additional();
	}

	private function erase_no_click():Void
	{
		remove_all_additional();
	}

	private function add_confirm():Void
	{
		trace('ADD CONFIRM');
		add(erase);

		// add(erase_back);
		// add(erase_txt);
		// add(erase_yes);
		// add(erase_no);
		//
		set_scroll();

		erase_back.screenCenter();
		erase_txt.screenCenter();
		erase_yes.screenCenter();
		erase_no.screenCenter();

		erase_back.y = 30;
		erase_txt.y = erase_back.y;
		erase_yes.y = erase_no.y = erase_txt.y + erase_txt.height;
		erase_yes.x = erase_yes.x - erase_yes.width / 2 - 2;
		erase_no.x = erase_no.x + erase_no.width / 2 + 2;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function remove_all_additional():Void
	{
		remove(erase, true);
	}

	public function have_saved_game():Bool
	{
		return false;
	}

	public function have_current_game():Bool
	{
		return false;
	}

	private var diff_x:Int = 70;

	public function new()
	{
		super();
		state = this;

		erase_back = new FlxSprite();
		erase_txt = new MyFlxText(0, 0, 0, [
			'Do you want to erase last save?',
			'Хотите удалить последнее сохранение?',
			'Бажаєте видалити останнє збереження?'
		]);
		erase_yes = new MyFlxButton(0, 0, MyStandartText.YES, erase_yes_click);
		erase_no = new MyFlxButton(0, 0, ['NO', 'НЕТ', 'НІ'], erase_no_click);
		erase_back.makeGraphic(Math.floor(erase_txt.width), Math.floor(erase_txt.height + erase_yes.height), FlxColor.BLACK);

		erase = new FlxSpriteGroup();
		erase.add(erase_back);
		erase.add(erase_txt);
		erase.add(erase_yes);
		erase.add(erase_no);
		erase.scrollFactor.set(0, 0);
		for (s in erase)
			s.scrollFactor.set(0, 0);

		trace('new');

		background = new FlxSprite(0, 0);
		add(background);

		// AF.scale_picture(background);

		var _dy:Int = 30;

		start_game_btn = new MyFlxButton(0, 0, ["New Game", 'Новая Игра', 'Нова Гра'], start_game_click);
		add(start_game_btn);
		start_game_btn.alpha = 0;
		start_game_btn.screenCenter();

		#if (debug)
		// FlxG.sound.toggleMuted();
		start_game_btn.alpha = 1;
		#end

		credits_btn = new MyFlxButton(0, 0, ['Credits', 'Титры', 'Титри'], credits_click);
		add(credits_btn);
		// credits_btn.alpha = 0;
		credits_btn.screenCenter();
		credits_btn.y = start_game_btn.y + _dy;
		credits_btn.alpha = 0;

		continue_btn = new MyFlxButton(0, 0, ['Continue', 'Продолжить', 'Продовжити'], continue_click);
		continue_btn.screenCenter();
		continue_btn.y = credits_btn.y + _dy;

		settings_btn = new MyFlxButton(0, 0, ['Settings', 'Настройки', 'Налаштування'], settings_click);
		settings_btn.screenCenter();
		settings_btn.y = continue_btn.y + _dy;
		settings_btn.alpha = 0;
		add(settings_btn);

		title = new MyFlxText(0, 10, 0, ['ORCISH RAGE', 'ЯРОСТЬ ОРКОВ', 'ЛЮТЬ ОРКІВ'], 15);
		title2 = new MyFlxText(0, title.y + title.height, 0, ['Chapter II: Conquest', 'Глава II: Завоевание', 'Глава II: Завоювання'], 10);

		title.borderStyle = title2.borderStyle = FlxTextBorderStyle.OUTLINE_FAST;
		title.color = title2.color = FlxColor.RED;
		title.borderColor = title2.borderColor = FlxColor.BLACK;

		title.screenCenter(FlxAxes.X);
		title2.screenCenter(FlxAxes.X);
		add(title);
		add(title2);
		title.alpha = title2.alpha = 0;

		function buttonsDone(_):Void
		{
			trace('Buttons Done');
		}

		function buttons(_):Void
		{
			trace('buttons', start_game_btn, credits_btn);

			FlxTween.tween(start_game_btn, {alpha: 1}, 1);
			FlxTween.tween(credits_btn, {alpha: 1}, 1);
			FlxTween.tween(settings_btn, {alpha: 1}, 1);

			trace('buttons tween start');

			if (have_saved_game())
			{
				trace('have save game');
				add(continue_btn);
				// add(export_save_btn);
				// export_save_btn.alpha = 0;
				continue_btn.alpha = 0;

				FlxTween.tween(continue_btn, {alpha: 1}, 1, {onComplete: buttonsDone});
				// FlxTween.tween(export_save_btn, {alpha:1}, 1);
				trace(' "continue" tween start');
			}
			else
			{
				trace('have no save game');
			}
		}
		function title_2(_):Void
		{
			trace('title 2');
			FlxTween.tween(title2, {alpha: 1}, 1, {onComplete: buttons});
			// FlxTween.tween(title2, {alpha:1}, 1);
		}

		FlxTween.tween(title, {alpha: 1}, 1, {onComplete: title_2});

		#if mobile
		var pp_link:FlxButton = new FlxButton(0, 0, null, pp_click);
		pp_link.loadGraphic(AssetPaths.pp__png);
		add(pp_link);
		#end

		var site_link:FlxButton = new FlxButton(0, 17, null, site_click);
		site_link.loadGraphic(AssetPaths.site__png);
		add(site_link);

		FB = new FlxButton(0, 17 * 2, null, fb_click);
		FB.loadGraphic(AssetPaths.fb__png);
		add(FB);

		//
		add(new MuteBtn(0, FlxG.height - 10));

		// MusicPlaying.play_music();

		version_txt = new FlxText(0, 0, 0, 'ver.0.5.0');
		add(version_txt);
		version_txt.color = FlxColor.YELLOW;
		version_txt.x = FlxG.width - version_txt.width;
		version_txt.y = FlxG.height - version_txt.height;

		to_quest_editor = new FlxButton(0, 0, 'Quests', to_quest_editor_click);
		// add(to_quest_editor);

		set_scroll();
	}

	public var to_quest_editor:FlxButton;

	private function to_quest_editor_click():Void
	{
		hide();
		QuestEditor.state.show();
	}

	private function site_click():Void
	{
		flash.Lib.getURL(new URLRequest('http://cheknikot.net.ua/'));
	}

	private function pp_click():Void
	{
		flash.Lib.getURL(new URLRequest('http://cheknikot.net.ua/index.php/privacy-policy'));
	}

	private function fb_click():Void
	{
		flash.Lib.getURL(new URLRequest('https://www.facebook.com/Orcish-Rage-349564825555951/'));
	}

	override public function hide():Void
	{
		active = visible = false;
		remove_all_additional();
		FlxG.state.remove(this, true);
	}

	private function settings_click():Void
	{
		hide();
		MySettingsMenu.state.show();
		// SettingsMenu.show();
	}

	private function continue_click():Void
	{
		hide();
		// saving.SaveLoad.load_game();
	}

	private var continue_btn:MyFlxButton;
	private var load_btn:MyFlxButton;

	override public function show():Void
	{
		active = visible = true;
		FlxG.state.add(this);
	}

	private function easy_click():Void
	{
		hide();
		// GlobalMap.new_game();
		// GlobalMap.game_diff = 'easy';
	}

	private function normal_click():Void
	{
		hide();
		// GlobalMap.new_game();
		// GlobalMap.game_diff = 'normal';
	}

	private function hard_click():Void
	{
		hide();
		// GlobalMap.new_game();
		// GlobalMap.game_diff = 'hard';
	}

	private function campaign_click():Void
	{
		// add_difficulty();
	}

	private function start_game_click():Void
	{
		// active = visible = false;
		hide();
	}

	private function credits_click():Void
	{
		hide();
	}
}
