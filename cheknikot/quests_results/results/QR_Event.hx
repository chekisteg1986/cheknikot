package cheknikot.quests_results.results;

class QR_Event extends QuestResult
{
	public static var save_vars:Array<String> = ['type', 'event'];

	public var event:String = 'none';

	public function new()
	{
		super();
		type = 'QR_Event';
	}

	override public function make_result_actions():Void
	{
		super.make_result_actions();
		Quest.events.push(event);
	}
}
