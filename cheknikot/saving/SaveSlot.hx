package cheknikot.saving;

class SaveSlot
{
	public var name:String = 'Free Slot';
	public var data:Dynamic;

	public function new() {}

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
}
