package cheknikot.quests_results.conditions;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class QC_Timer extends QuestCondition 
{

	public static var save_vars:Array<String> = ['type', 'time'];
	public var time:Float = 1;
	public function new() 
	{
		super();
		type = 'QC_Timer';
	}
	override public function check():Void 
	{
		super.check();
		time -= FlxG.elapsed;
		if (time <= 0) complete();
	}
	
}