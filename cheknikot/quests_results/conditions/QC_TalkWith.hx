package cheknikot.quests_results.conditions;

import cheknikot.quests_results.Quest;

/**
 * ...
 * @author ...
 */
class QC_TalkWith extends QuestCondition
{
	public static var save_vars:Array<String> = ['type', 'who_talk', 'talk_with'];

	public var who_talk:String = 'any';
	public var talk_with:String = 'name';

	public function new()
	{
		super();
		type = 'QC_TalkWith';
	}

	override function checkEvent(_event:String)
	{
		if (_event == 'click ' + talk_with + ' ' + who_talk)
			complete();
	}
}
