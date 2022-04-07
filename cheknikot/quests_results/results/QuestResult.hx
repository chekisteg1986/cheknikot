package cheknikot.quests_results.results;

// import addit_cond_res.QR_NextLevel;
import cheknikot.quests_results.results.QR_AddQuest;
import cheknikot.quests_results.results.QR_Message;
import cheknikot.quests_results.results.QR_SetTileRect;
import cheknikot.quests_results.results.QR_ShowPicture;
import cheknikot.quests_results.results.QuestResult;
import cheknikot.saving.SaveLoad;

// import addit_cond_res.QR_Spawn;

/**
 * ...
 * @author ...
 */
class QuestResult
{
	public var type:String = 'QuestResult';

	public static var save_vars:Array<String> = ['type'];

	/*public function get_save_vars():Array<String>
		{
			var _class:Dynamic = Type.getClass(this);
			var _vars:Array<String> = Reflect.getProperty(_class, 'save_vars');
			trace('type:',type,'vars:',_vars);
			return _vars;
	}*/
	public static function no_use():Void
	{
		new QR_AddQuest();
		new QR_Message();

		new QR_ShowPicture();
		// new QR_Spawn();
		// new QR_NextLevel();
		new QR_SetTileRect();
		new QR_RemoveObjects();
		new QR_Event();
	}

	public function set_data(_d:Array<Dynamic>):Void
	{
		SaveLoad.set_data(this, Type.getClass(this), _d);
	}

	public static function get_result(_t:String):QuestResult
	{
		trace('GET RESULT', _t);

		var qr:QuestResult = null;
		var _class:Class<Dynamic> = Type.resolveClass('cheknikot.quests_results.results.' + _t);
		if (_class == null)
		{
			trace('checking in local');
			_class = Type.resolveClass('addit_cond_res.' + _t);
		}

		if (_class != null)
			qr = Type.createInstance(_class, []);

		return qr;
	}

	public static function load(data:Array<Dynamic>):QuestResult
	{
		var _class_name:String = SaveLoad.get_attr('type', data, save_vars);
		var qr:QuestResult = get_result(_class_name);
		trace('load qr', qr.type);
		SaveLoad.set_data(qr, Type.getClass(qr), data);

		return qr;
	}

	public function get_save_array():Array<Dynamic>
	{
		// var _class:Dynamic = Type.getClass(this);
		// var _save_vars:Array<String> = Reflect.getProperty(_class, 'save_vars');
		// return SaveLoad.get_save_data_from_savevars(this, _save_vars);
		trace('QR get save array', SaveLoad.get_save_data(this));
		return SaveLoad.get_save_data(this);
	}

	public function new()
	{
		this.type = Type.getClassName(Type.getClass(this));
		var _i:Int = type.lastIndexOf('.');
		type = type.substring(_i + 1);
	}

	public function make_result_actions():Void {}
}
