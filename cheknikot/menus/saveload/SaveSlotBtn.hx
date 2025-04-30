package cheknikot.menus.saveload;

import cheknikot.messanger.GameMessage;
import cheknikot.saving.SaveSlot;
import flixel.ui.FlxButton;

/**
	Button of SaveSlot in SaveMenu
**/
class SaveSlotBtn extends FlxButton
{
	public var parent:SaveLoadMenu;

	private var for_save:Bool;

	public var save_slot:SaveSlot;

	public function new(_save:Bool = true)
	{
		for_save = _save;
		super(0, 0, ' ', onClick);
	}

	public function setSlot(_saveSlot:SaveSlot):Void
	{
		save_slot = _saveSlot;
		this.text = _saveSlot.name;
	}

	private function onClick():Void
	{
		if (for_save)
		{
			trace('click on SAVE SLOT');
			ConfirmMenu.state.confirm(save);
		}
		else
		{
			trace('click on LOAD SLOT');
			ConfirmMenu.state.confirm(load);
		}
	}

	private function save():Void
	{
		save_slot.save();
		parent.showSlots();
	}

	private function load():Void
	{
		parent.hide();
		// parent.exit_click();
		save_slot.load();
	}

	private function cancel():Void {}
}
