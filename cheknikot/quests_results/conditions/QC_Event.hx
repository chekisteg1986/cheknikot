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

	override public function check():Void
	{
		super.check();
		// this.event == 'reach meet';
		for (s in Quest.events)
		{
			trace('Event:' + s + ':' + s.length);

			trace('Cond:' + this.event + ':' + this.event.length);

			if (s == event)
			{
				trace('Event Complete');
				complete();
				return;
			}
		}
	}
}
