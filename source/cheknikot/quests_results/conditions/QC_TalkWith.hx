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
	public var talk_with:String = 'any';

	public function new()
	{
		super();
		type = 'QC_TalkWith';
	}

	override public function check():Void
	{
		super.check();
		if (WHO == null)
			return;
		trace('checking talking:', who_talk, talk_with, '/', WHO, WITH);
		if (who_talk == WHO || who_talk == 'any')
		{
			trace('yeah');

			if (WITH == talk_with)
			{
				// talked = true;
				trace('YES');
				complete();
			}
		}
	}

	public static var WHO:String;
	public static var WITH:String;

	// private static var talked:Bool = false;
	public static function talk(_who:String = 'any', _with:String = 'any'):Void
	{
		WHO = _who;
		WITH = _with;
		// Quest.check_quests();
	}
}
