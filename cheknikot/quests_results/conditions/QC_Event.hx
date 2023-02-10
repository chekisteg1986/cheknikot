package cheknikot.quests_results.conditions;

/**
 * ...
 * @author ...
 */
class QC_Event extends QuestCondition
{
	public var event:String = '';

	public static var save_vars:Array<String> = ['type', 'event'];

	public function new()
	{
		super();
	}

	override public function checkEvent(_event:String):Void
	{
		if (_event == event)
		{
			trace('Event Complete');
			complete();
			return;
		}
	}
}
