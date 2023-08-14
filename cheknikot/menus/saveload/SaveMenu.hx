package cheknikot.menus.saveload;

import cheknikot.saving.SaveLoad;
import cheknikot.saving.SaveSlot;
import flixel.group.FlxGroup;
import flixel.util.FlxSave;

class SaveMenu extends SaveLoadMenu
{
	public static var state:SaveMenu;

	public function new()
	{
		for_save = true;
		super();
		state = this;
	}
}
