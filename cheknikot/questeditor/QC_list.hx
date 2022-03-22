package cheknikot.questeditor;


import flixel.util.FlxColor;
/**
 * ...
 * @author ...
 */
class QC_list extends MyScrollablePanel
{
	public static var COND_TYPES:Array<String> = 
	['QC_KillAll','QC_CharAtPosition','QC_Event','QC_Timer','QC_TalkWith','QuestCondition','Cancel'];
	public static var state:QC_list;
	
	
	//public var panel:MyScrollablePanel;
	public function new() 
	{
		super(200, 200);
		draw_background(FlxColor.GRAY);
		//make_back(FlxColor.BLACK);
		
		//panel = new MyScrollablePanel(200, 200);
		x = 0;
		y = 400;
		state = this;
		//for()
		//creating_btns
		var _b:QC_list_btn = null;
		for (t in COND_TYPES)
		{
			//QuestCondition.get_condition(t)
			_b = new QC_list_btn(t);
			container.add(_b);
		}
		
		set_positions();
		DX = _b.frameWidth;
		DY = _b.frameHeight;
		container_sort();
	}
	
}