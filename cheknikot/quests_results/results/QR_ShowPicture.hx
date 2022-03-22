package cheknikot.quests_results.results;
import cheknikot.menus.PictureMenu;
/**
 * ...
 * @author ...
 */
class QR_ShowPicture extends QuestResult 
{

	public var picture:Int = 0;
	public var text:Array<Array<String>> = [['eng','ru','ua']];
	
	public static var save_vars:Array<String> = ['type','picture','text'];	
	
	
	public function new() 
	{
		super();
		
	}
	override public function make_result_actions():Void 
	{
		super.make_result_actions();
		trace('QR_ShowPicture');
		
		
		
			PictureMenu.enter(picture, text);
		
	}
	
}