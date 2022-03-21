package cheknikot.quests_results.results;

/**
 * ...
 * @author ...
 */
class QR_ChangeLocation extends QuestResult 
{
	public static var save_vars:Array<String> = ['type', 'location'];
	public var location:String = '';
	public function new() 
	{
		super();
		
	}
	override public function make_result_actions():Void 
	{
		super.make_result_actions();
		MyGameObjectLayer.state.load_level(location);
		//MyGameObjectLayer.state.change_location(location);
	}
	
}