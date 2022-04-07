package cheknikot.quests_results.conditions;

import cheknikot.quests_results.conditions.QC_Event;
import cheknikot.quests_results.conditions.QC_TalkWith;
import cheknikot.quests_results.conditions.QC_Timer;
import cheknikot.saving.SaveLoad;
import flixel.FlxG;

// import haxe.macro.Type;
// import addit_cond_res.QC_KillAll;

/**
 * ...
 * @author ...
 */
class QuestCondition
{
	public var completed:Bool = false;
	public var complete_timer:Float = 1;

	// public var string_data:String;
	// public var char_arr:Array<Character>;
	// public var x:Int = 0;
	// public var y:Int = 0;
	// public var rect:Dynamic;
	//
	public var _of_quest:Quest;
	public var type:String = 'QuestCondition';

	public static var save_vars:Array<String> = ['type'];

	public function get_save_array():Array<Dynamic>
	{
		return SaveLoad.get_save_data(this);
	}

	private static function no_use():Void
	{
		new QC_Event();
		// new QC_KillAll();
		new QC_TalkWith();
		new QC_Timer();
	}

	public static function get_condition(_t:String):QuestCondition
	{
		var qc:QuestCondition = null;
		var _class:Class<Dynamic> = Type.resolveClass('cheknikot.quests_results.conditions.' + _t);
		if (_class == null)
			_class = Type.resolveClass('addit_cond_res.' + _t);

		if (_class != null)
		{
			qc = Type.createInstance(_class, []);
		}
		else
		{
			trace('NULL CLASS', _t);
		}

		return qc;
	}

	public static function load(data:Array<Dynamic>):QuestCondition
	{
		// SaveLoad.set_data_unic(this data);

		var _class_name:String = SaveLoad.get_attr('type', data, save_vars);
		var qc:QuestCondition = get_condition(_class_name);
		SaveLoad.set_data_unic(qc, data);

		return qc;
	}

	public function new()
	{
		this.type = Type.getClassName(Type.getClass(this));
		var _i:Int = type.lastIndexOf('.');
		type = type.substring(_i + 1);
	}

	public function check_clicking(clicked_on:String, clicked_who:String):Void {}

	public function check():Void {}

	private function complete_tick():Void
	{
		complete_timer -= FlxG.elapsed;
		if (complete_timer <= 0)
		{
			completed = true;
		}
	}

	public function complete():Void
	{
		trace('CONDITION', type, 'COMPLETED IN SUPERCLASS');
		completed = true;
	}
	/*public function have_condition(s:String):Bool
		{
			return false;
	}*/
}
