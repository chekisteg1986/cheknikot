package cheknikot.quests_results.results;

import cheknikot.quests_results.Quest;
import cheknikot.saving.SaveLoad;

/**
 * ...
 * @author ...
 */
class QR_AddQuest extends QuestResult
{
	public var quest:Quest;

	public static var save_vars:Array<String> = ['type', 'quest'];

	/*override public function get_save_array():Array<Dynamic> 
		{
			var res:Array<Dynamic> = SaveLoad.get_save_data_from_savevars(this, save_vars);
			return res;
		}
		override public function get_save_vars():Array<String> 
		{
			return save_vars;
	}*/
	public function new()
	{
		super();

		type = 'QR_AddQuest';
		quest = new Quest();
	}

	override public function make_result_actions():Void
	{
		super.make_result_actions();
		Quest.current_quests.push(quest);
		trace('QUEST ADDED', quest.get_save_data());
	}
}
