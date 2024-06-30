package cheknikot.saving;

import flixel.util.FlxSave;

class SaveSlot
{
	public var name:String = 'Free Slot';
	public var data:Dynamic;
	public var index:Int = -1;

	public function new(_index:Int)
	{
		this.index = _index;
	}

	public function save():Void
	{
		var _date:Date = Date.now();
		this.name = _date.toString();
		if (SaveLoad.dynamicSaveFunc == null)
		{
			trace('ERROR: Have no SaveLoad.dynamicSaveFunc');
		}
		else
			this.data = SaveLoad.dynamicSaveFunc();
	}

	public function load():Void
	{
		// getting data from save file
		var _save:FlxSave = SaveLoad.getSaveFile();
		var _slot:Dynamic = _save.data[index];
		if (SaveLoad.dynamicLoadFunc == null)
		{
			trace('ERROR: Have no SaveLoad.dynamicLoadFunc');
		}
		else
			SaveLoad.dynamicLoadFunc(_slot);
	}
}
