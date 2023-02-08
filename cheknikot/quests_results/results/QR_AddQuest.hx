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
	}
}
