package cheknikot.questeditor;

import cheknikot.quests_results.Quest;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class QuestBtn extends FlxButton 
{

	public static var BUTTONS:Array<QuestBtn> = new Array();
	public static var _btn_n:Int = 0;
	
	public var quest:Quest = null;
	public var deep:Int = 0;
	public static function get_free_button():QuestBtn
	{
		if (_btn_n >= BUTTONS.length)
		{
			BUTTONS.push(new QuestBtn());
		}
		var _b:QuestBtn = BUTTONS[_btn_n];
		
		_btn_n ++;
		return _b;
	}
	
	public function new() 
	{
		super(0,0,null,onClick);
		this.makeGraphic(this.frameWidth, this.frameHeight, FlxColor.BLACK);
	}
	private function onClick():Void
	{
		AF.clear_array(VarEditorMenu.state.history);
		QuestEditor.state.selected_quest = quest;
		VarEditorMenu.state.show_vars_for(quest);
		QuestEditor.state.refresh_list();
	}
	
}