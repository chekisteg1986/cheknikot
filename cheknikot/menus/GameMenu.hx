package cheknikot.menus;

import cheknikot.MenuBase;
import cheknikot.MyFlxButton;
import cheknikot.menus.saveload.LoadMenu;
import cheknikot.menus.saveload.SaveMenu;
import flixel.util.FlxAxes;

class GameMenu extends MenuBase
{
	private var return_btn:MyFlxButton;
	private var save_btn:MyFlxButton;
	private var load_btn:MyFlxButton;
	private var to_main_menu_btn:MyFlxButton;

	public function new()
	{
		super();

		createBackground(300, 400);
		setBackgroundPosition(180, 80);
		// background.x = 180;
		// background.y = 80;
		return_btn = new MyFlxButton(200, 100, ['Return', 'Вернуться', 'Вернутися'], returnClick);
		save_btn = new MyFlxButton(200, 200, ['Save', 'Сохранить', 'Зберегти'], saveClick);
		load_btn = new MyFlxButton(200, 300, ['Load', 'Загрузить', 'Загрузити'], loadClick);
		to_main_menu_btn = new MyFlxButton(200, 400, ['To main menu', 'На главную', 'На головну'], toMainMenuClick);
		add(return_btn);
		add(save_btn);
		add(load_btn);
		add(to_main_menu_btn);
		return_btn.screenCenter(FlxAxes.X);
		save_btn.screenCenter(FlxAxes.X);
		load_btn.screenCenter(FlxAxes.X);
		to_main_menu_btn.screenCenter(FlxAxes.X);
	}

	private function saveClick():Void
	{
		this.hide();
		SaveMenu.state.show();
	}

	private function loadClick():Void
	{
		this.hide();
		SaveMenu.state.show();
	}

	private function toMainMenuClick():Void {}

	private function returnClick():Void
	{
		this.hide();
	}

	override function update(elapsed:Float)
	{
		if (SaveMenu.state.on_screen || LoadMenu.state.on_screen)
			elapsed = 0;
		super.update(elapsed);
	}
}
