package cheknikot.menus;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.display.StageQuality;

/**
 * ...
 * @author ...
 */
class ChooseLanguageMenu extends FlxSpriteGroup
{
	public var eng_btn:MyFlxButton;
	public var rus_btn:MyFlxButton;
	public var ua_btn:MyFlxButton;

	public static var menu:ChooseLanguageMenu;
	public static var on_complete:Void->Void;

	public function new(_on_complete:Void->Void)
	{
		super();
		on_complete = _on_complete;
		menu = this;
		trace('LANGUAGE');

		eng_btn = new MyFlxButton(0, 0, ['English'], eng_click);

		rus_btn = new MyFlxButton(0, 0, ['Русский'], rus_click);
		ua_btn = new MyFlxButton(0, 0, ['Українська'], ua_click);
		// ua_btn.loadGraphic(AssetPaths.altar_health2__png);
		// eng_btn.label.setFormat(GameParams.FONT,10,FlxColor.BLACK);
		// rus_btn.label.setFormat(GameParams.FONT,10,FlxColor.BLACK);
		// ua_btn.label.setFormat(GameParams.FONT,10,FlxColor.BLACK);

		add(eng_btn);
		add(rus_btn);
		add(ua_btn);

		FlxG.stage.quality = StageQuality.LOW;
		/*
			var _y:Int = 0;
			var _s:Int = 5;
			while (++_s <= 20)
			{
				var t:FlxText = new FlxText(0, _y, FlxG.width-1, 'Попробуем  найти оптимальный размер шрифта для игры:'+_s);
				t.color = FlxColor.RED;
				t.setFormat("assets/fonts/Diary.ttf", _s, FlxColor.RED);
				
				add(t);
				_y = Math.floor(t.y+t.height);
			}
		 */

		eng_btn.screenCenter();
		eng_btn.y -= 40;
		rus_btn.screenCenter();
		ua_btn.screenCenter();
		ua_btn.y += 40;
		// AF.put_in_line([eng_btn, rus_btn, ua_btn], 70);

		// set_scroll();
	}

	private function eng_click():Void
	{
		GameParams.LANGUAGE = 0;
		FlxG.state.remove(this, true);
		on_complete();
	}

	private function rus_click():Void
	{
		GameParams.LANGUAGE = 1;
		FlxG.state.remove(this, true);
		on_complete();
	}

	private function ua_click():Void
	{
		GameParams.LANGUAGE = 2;
		FlxG.state.remove(this, true);
		on_complete();
	}
}
