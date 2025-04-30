package cheknikot.saving;

import flixel.util.FlxSave;

class SaveSlot
{
	// public var filename:String = 'save';
	public var name:String = 'Free Slot';
	public var data:Dynamic;
	public var index:Int = -1;

	public function new(_index:Int)
	{
		this.index = _index;
		var _savefile:FlxSave = new FlxSave();
		_savefile.bind('save' + index);
		if (_savefile.data.name == null)
		{
			_savefile.data.name = this.name;
			// _savefile.data.save = this.data;
		}
		_savefile.close();
		// this.filename = 'save' + _index;
	}

	public function save():Void
	{
		trace('Saving Slot');
		var _date:Date = Date.now();
		this.name = _date.toString();
		if (SaveLoad.dynamicSaveFunc == null)
		{
			trace('ERROR: Have no SaveLoad.dynamicSaveFunc');
		}
		else
		{
			this.data = SaveLoad.dynamicSaveFunc();
			var _savefile:FlxSave = new FlxSave();
			_savefile.bind('save' + index);
			_savefile.data.name = this.name;
			_savefile.data.save = this.data;
			_savefile.close();
		}
		//
	}

	public function load():Void
	{
		trace('Load Slot');
		// getting data from save file
		var _save:FlxSave = new FlxSave();
		_save.bind('save' + index);
		// var _slot:Dynamic = _save.data[index];

		if (SaveLoad.dynamicLoadFunc == null)
		{
			trace('ERROR: Have no SaveLoad.dynamicLoadFunc');
		}
		else
		{
			if (_save.data.save == null)
			{
				trace('ERROR: No Save Data');
			}
			else
				SaveLoad.dynamicLoadFunc(_save.data.save);
		}
		_save.close();
	}
}
