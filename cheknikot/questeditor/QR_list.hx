package cheknikot.questeditor;

import cheknikot.MyScrollablePanel;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class QR_list extends MyScrollablePanel
{
	public static var RES_TYPES:Array<String> = [
		'QR_RemoveObjects', 'QR_SetTileRect', 'QR_NextLevel', 'QR_ShowPicture', 'QR_SetPath', 'QR_AddQuest', 'QR_Message', 'QuestResult', 'QR_Event',
		'QR_SetProperty', 'QR_ObjectAction', 'Cancel'
	];
	public static var state:QR_list;

	public function new()
	{
		super(200, 200);
		drawBackground(FlxColor.GRAY);
		// make_back(FlxColor.BLACK);

		// panel = new MyScrollablePanel(200, 200);
		x = 0;
		y = 400;
		state = this;
		// for()
		// creating_btns
		var _b:QR_list_btn = null;
		for (t in RES_TYPES)
		{
			// QuestCondition.get_condition(t)
			_b = new QR_list_btn(t);
			container.add(_b);
		}

		set_positions();
		DX = _b.frameWidth;
		DY = _b.frameHeight;
		container_sort();
	}
}
