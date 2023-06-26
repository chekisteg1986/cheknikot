package cheknikot.menus.saveload;

import cheknikot.saving.SaveLoad;
import flixel.group.FlxGroup;
import flixel.util.FlxSave;

class SaveMenu extends MenuBase
{
	private var slots_group:FlxGroup = new FlxGroup();
	private var slots_btns:Array<SaveSlotBtn> = new Array();

	public function new()
	{
		super();

		add(exit_btn);
		add(slots_group);
	}

	override function show()
	{
		super.show();
		showSlots();
	}

	private function showSlots():Void
	{
		for (_slot in slots_btns)
			slots_group.remove(_slot);
		if (SaveLoad.save == null || SaveLoad.save.slots == null)
			SaveLoad.initSaveFile();
		var _array:Array<Dynamic> = save.slots;

		var _n:Int = 0;
		function _new():SaveSlotBtn
		{
			return new SaveSlotBtn();
		}
		for (_slot in _array)
		{
			var _btn:SaveSlotBtn = AF.get_free_object(slots_btns, _n, _new);
			_btn.y = 20 * _n;

			slots_group.add(_btn);
			_btn.setSlot(_slot);
			_n++;
		}
	}

	override function exit_click()
	{
		super.exit_click();
	}
}
