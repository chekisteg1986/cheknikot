package cheknikot.menus.saveload;

import cheknikot.saving.SaveLoad;
import cheknikot.saving.SaveSlot;
import flixel.group.FlxGroup;
import flixel.util.FlxSave;

class LoadMenu extends SaveLoadMenu
{
	public static var state:LoadMenu;

	public function new()
	{
		for_save = false;
		super();
		state = this;
	}
}
