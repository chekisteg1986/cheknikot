package cheknikot.questeditor;
import cheknikot.quests_results.results.QuestResult;
import flixel.ui.FlxButton;
import cheknikot.quests_results.conditions.QuestCondition;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class ResBtn extends FlxButton 
{
	public static var BUTTONS:Array<ResBtn> = new Array();
	public static var _btn_n:Int = 0;
	
	public var result:QuestResult = null;
	
	public static function get_free_button():ResBtn
	{
		if (_btn_n >= BUTTONS.length)
		{
			BUTTONS.push(new ResBtn());
		}
		var _b:ResBtn = BUTTONS[_btn_n];
		
		_btn_n ++;
		return _b;
	}
	public function new() 
	{
		super(0, 0, null, OnClick);
		this.makeGraphic(this.frameWidth, this.frameHeight, FlxColor.BLACK);
		
	}
	public function OnClick():Void
	{
		QuestEditor.state.remove_addit();
		
		QuestEditor.state.selected_result = result;
		QuestEditor.state.refresh_results();
		
		QuestEditor.state.add(VarEditorMenu.state);
		VarEditorMenu.state.show_vars_for(result/*, result.get_save_vars()*/);
	}
	
}