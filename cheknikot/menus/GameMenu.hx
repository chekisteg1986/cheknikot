package cheknikot.menus;

import cheknikot.MenuBase;
import cheknikot.MyFlxButton;

class GameMenu extends MenuBase
{
	private var return_btn:MyFlxButton;
	private var save_btn:MyFlxButton;
	private var load_btn:MyFlxButton;
	private var to_main_menu_btn:MyFlxButton;

	public function new()
	{
		super();
		return_btn = new MyFlxButton(0, 0, ['Return', 'Вернуться', 'Вернутися'], returnClick);
		save_btn = new MyFlxButton(0, 0, ['Save', 'Сохранить', 'Зберегти'], saveClick);
		load_btn = new MyFlxButton(0, 0, ['Load', 'Загрузить', 'Загрузити'], loadClick);
		to_main_menu_btn = new MyFlxButton(0, 0, ['To main menu', 'На главную', 'На головну'], toMainMenuClick);
	}

	private function saveClick():Void {}

	private function loadClick():Void {}

	private function toMainMenuClick():Void {}

	private function returnClick():Void {}
}
