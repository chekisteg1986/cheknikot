package cheknikot.questeditor;

import flixel.ui.FlxButton;
import cheknikot.quests_results.results.QuestResult;
/**
 * ...
 * @author ...
 */
class QR_list_btn extends FlxButton 
{

	
	
	public var type:String;
	
	public function new(_type:String) 
	{
		super(0, 0, _type, OnClick);
		type = _type;
	}
	
	public function OnClick():Void
	{
		var _qr:QuestResult = QuestResult.get_result(type);
		if(_qr != null)	QuestEditor.state.selected_quest.results.push(_qr);
		QuestEditor.state.remove(QR_list.state, true);
		QuestEditor.state.refresh_list();
	}
	
}