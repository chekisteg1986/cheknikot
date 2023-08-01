package cheknikot.menus.saveload;

import cheknikot.messanger.GameMessage;
import flixel.ui.FlxButton;

class SaveSlotBtn extends FlxButton
{
	private var forSave:Bool;

	public function new(_save:Bool = true)
	{
		forSave = _save;
		super(0, 0, ' ', onClick);
	}

	public function setSlot(_saveSlot:Dynamic):Void
	{
		this.text = _saveSlot.name;
	}

	private function onClick():Void
	{
		if (forSave)
		{
			ConfirmMenu.state.confirm(save);
		}
		else
		{
			ConfirmMenu.state.confirm(load);
		}
	}

	private function save():Void {}

	private function load():Void {}

	private function cancel():Void {}
}
