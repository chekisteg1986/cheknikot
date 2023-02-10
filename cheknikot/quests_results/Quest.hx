package cheknikot.quests_results;

import cheknikot.questeditor.QuestEditor;
import cheknikot.quests_results.conditions.QC_TalkWith;
import cheknikot.quests_results.conditions.QuestCondition;
import cheknikot.quests_results.results.QR_AddQuest;
import cheknikot.quests_results.results.QuestResult;
import cheknikot.saving.SaveLoad;
import openfl.utils.Assets;

/**
 * ...
 * @author ...
 */
class Quest
{
	public static var current_quests:Array<Quest> = new Array();

	public var completed:Bool = false;
	public var conditions:Array<QuestCondition> = [];
	public var results:Array<QuestResult> = [];
	public var trigger_name:String = 'name';
	public var description:Array<String> = ['en', 'ru', 'ua'];
	public var name:Array<String> = ['en', 'ru', 'ua'];
	public var visible:Bool = true;
	public var check_on_global:Bool = false;

	public static var save_vars:Array<String> = ['trigger_name', 'name', 'description', 'visible', 'check_on_global'];

	public var parent:Quest = null;

	public static function load_quests(_filename:String):Void
	{
		if (QuestEditor.state == null || QuestEditor.state.quests.length == 0)
		{
			trace('loading quests from file');
			AF.clear_array(Quest.current_quests);
			// trace(Assets.list());

			var _str:String = Assets.getText('assets/data/' + _filename);

			Quest.load_quests_to_array(_str, Quest.current_quests);
		}
		else
		{
			trace('copy quests from editor');
			Quest.current_quests = QuestEditor.state.quests;
			QuestEditor.state.quests = new Array();
		}
	}

	public static function load_quests_to_array(_str:String, _arr:Array<Quest>):Void
	{
		var _data:Array<Dynamic> = SaveLoad.unserialize(_str);
		for (d in _data)
		{
			var _q:Quest = new Quest();
			_q.loadSaveData(d);
			_arr.push(_q);
			// SaveLoad.set_data(_q,Quest,
		}
	}

	public function loadSaveData(data:Dynamic):Void
	{
		trace(' == loading Quest == ');

		// data = SaveLoad.convert(data, save_vars);

		SaveLoad.setData(this, Quest, data);
		// trace(data);
		// trace(this);
		var _qc_arr:Array<Dynamic> = Reflect.getProperty(data, 'conditions');
		if (_qc_arr == null)
			_qc_arr = Reflect.getProperty(data, 'addit1');

		trace(_qc_arr);

		for (qc in _qc_arr)
		{
			// trace(conditions);
			conditions.push(QuestCondition.load(qc));
		}
		var _qr_arr:Array<Dynamic> = Reflect.getProperty(data, 'results');
		if (_qr_arr == null)
			_qr_arr = Reflect.getProperty(data, 'addit2');

		for (qr in _qr_arr)
		{
			results.push(QuestResult.load(qr));
		}

		trace('Loaded quest', name, 'cond', conditions.length, 'res', results.length);
	}

	public function getSaveData():Dynamic
	{
		// trace('== Saving Quest ==');
		var res:Dynamic = SaveLoad.getSaveData(this, true);

		var _qc_arr:Array<Dynamic> = new Array();
		for (qc in conditions)
		{
			_qc_arr.push(SaveLoad.getSaveData(qc));
		}

		Reflect.setField(res, 'conditions', _qc_arr);
		// trace('conditions', _qc_arr.length, Reflect.getProperty(res, 'conditions'));
		var _qr_arr:Array<Dynamic> = new Array();
		for (qr in results)
		{
			_qr_arr.push(SaveLoad.getSaveData(qr));
		}
		Reflect.setField(res, 'results', _qr_arr);
		// trace('results', _qr_arr.length, Reflect.getProperty(res, 'results'));

		return res;
	}

	public static function clickOn(_object_name:String, _who_clicks:String = 'any'):Void
	{
		Quest.event('click ' + _object_name + ' ' + _who_clicks);
	};

	public static var last_quest:Quest = null;

	public static function fast(add_to_quests:Bool = true, _name:Array<String> = null, _descr:Array<String> = null /*,_clue:String = null*/):Quest
	{
		var q:Quest = new Quest();

		q.name = _name;
		q.description = _descr;
		// q.clue = _clue;

		if (add_to_quests)
			current_quests.push(q);
		last_quest = q;

		if (q.name[0] == null)
			q.visible = false;
		if (_descr[0] == null)
			q.visible = false;

		return q;
	}

	public static function check_quests():Void
	{
		// trace('check quests');
		var n:Int = current_quests.length;
		var q:Quest;

		while (--n >= 0)
		{
			q = current_quests[n];
			q.check();
			if (q.completed)
			{
				current_quests.splice(n, 1);
				q.make_result();
				// trace('REMOVING QUEST', q.trigger_name);
			}
		}
	}

	public static function event(_event:String):Void
	{
		for (_q in current_quests)
			for (_qc in _q.conditions)
				_qc.checkEvent(_event);
	}

	// public static var events:Array<String> = new Array();

	public function new() {}

	public function check():Void
	{
		if (completed)
			return;

		var n:Int = conditions.length;

		while (--n >= 0)
		{
			if (!conditions[n].completed)
				conditions[n].check();

			if (conditions[n].completed)
				conditions.splice(n, 1);
		}

		if (conditions.length == 0)
		{
			completed = true;
		}
	}

	public function make_result():Void
	{
		var len:Int = results.length;
		var n:Int = -1;
		while (++n < len)
		{
			trace(results[n].type);
			results[n].make_result_actions();
			trace('result completed');
		}
		trace('all results completed');
	}
}
