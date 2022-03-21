package cheknikot.questeditor;

import cheknikot.quests_results.conditions.QuestCondition;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class CondBtn extends FlxButton 
{
	
	public static var BUTTONS:Array<CondBtn> = new Array();
	public static var _btn_n:Int = 0;
	
	public var condition:QuestCondition = null;
	public static function get_free_button():CondBtn
	{
		if (_btn_n >= BUTTONS.length)
		{
			BUTTONS.push(new CondBtn());
		}
		var _b:CondBtn = BUTTONS[_btn_n];
		
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
		QuestEditor.state.selected_cond = condition;
		QuestEditor.state.refresh_conditions();
		
		QuestEditor.state.add(VarEditorMenu.state);
		VarEditorMenu.state.show_vars_for(condition/*, condition.get_save_vars()*/);
	}
	
}