package cheknikot.menus;

import cheknikot.MenuBase;
import cheknikot.MyFlxButton;
import cheknikot.menus.saveload.SaveMenu;

class GameMenu extends MenuBase
{
	private var return_btn:MyFlxButton;
	private var save_btn:MyFlxButton;
	private var load_btn:MyFlxButton;
	private var to_main_menu_btn:MyFlxButton;

	public function new()
	{
		super();
		return_btn = new MyFlxButton(200, 100, ['Return', 'Вернуться', 'Вернутися'], returnClick);
		save_btn = new MyFlxButton(200, 200, ['Save', 'Сохранить', 'Зберегти'], saveClick);
		load_btn = new MyFlxButton(200, 300, ['Load', 'Загрузить', 'Загрузити'], loadClick);
		to_main_menu_btn = new MyFlxButton(200, 400, ['To main menu', 'На главную', 'На головну'], toMainMenuClick);
		add(return_btn);
		add(save_btn);
		add(load_btn);
		add(to_main_menu_btn);
	}

	private function saveClick():Void
	{
		this.hide();
		SaveMenu.state.show();
	}

	private function loadClick():Void {}

	private function toMainMenuClick():Void {}

	private function returnClick():Void
	{
		this.hide();
	}
}
