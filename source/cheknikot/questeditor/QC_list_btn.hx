package cheknikot.questeditor;

import flixel.ui.FlxButton;
import cheknikot.quests_results.conditions.QuestCondition;
/**
 * ...
 * @author ...
 */
class QC_list_btn extends FlxButton 
{

	
	
	public var type:String;
	
	public function new(_type:String) 
	{
		super(0, 0, _type, OnClick);
		type = _type;
	}
	
	public function OnClick():Void
	{
		var _qc:QuestCondition = QuestCondition.get_condition(type);
		if(_qc != null)	QuestEditor.state.selected_quest.conditions.push(_qc);
		QuestEditor.state.remove(QC_list.state, true);
		QuestEditor.state.refresh_list();
	}
}