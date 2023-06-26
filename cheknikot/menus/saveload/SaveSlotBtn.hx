package cheknikot.menus.saveload;

import flixel.ui.FlxButton;

class SaveSlotBtn extends FlxButton
{
	public function new() {}

	public function setSlot(_saveSlot:Dynamic):Void
	{
		this.text = _saveSlot.name;
	}
}
