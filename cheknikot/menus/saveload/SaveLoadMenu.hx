package cheknikot.menus.saveload;

class SaveLoadMenu extends MenuBase
{
	private var slots_group:FlxGroup = new FlxGroup();
	private var slots_btns:Array<SaveSlotBtn> = new Array();
	private var for_save:Bool;

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

		if (SaveLoad.save == null || SaveLoad.save.data.slots == null)
			SaveLoad.initSaveFile();
		var _array:Array<SaveSlot> = SaveLoad.save.data.slots;

		var _n:Int = 0;
		function _new():SaveSlotBtn
		{
			return new SaveSlotBtn(for_save);
		}

		for (_slot in _array)
		{
			var _btn:SaveSlotBtn = AF.get_free_object(slots_btns, _n, _new);
			_btn.x = 200;
			_btn.y = 50 * _n;
			slots_group.add(_btn);
			_btn.setSlot(_slot);
			_n++;
		}
	}
}
