package cheknikot.menus.inventory;

import cheknikot.MyScrollablePanel;
import cheknikot.char_additions.EquipmentStatsBasic;

/**
 * ...
 * @author ...
 */
class SackPanel extends MyScrollablePanel
{
	public var sack_slots:Array<SackBtn> = new Array();

	public function new(_width:Int, _height:Int)
	{
		super(_width, _height);
		sort_type = MyScrollablePanel.SORT_LIST;
		DY = 30;
	}

	public function show_sack(sack:Array<EquipmentStatsBasic>):Void
	{
		container.clear();
		var n:Int = 0;
		var btn:SackBtn = null;
		for (item in sack)
		{
			if (n <= sack_slots.length)
			{
				sack_slots.push(new SackBtn());
			}
			btn = sack_slots[n];

			btn.set_item(item);
			container.add(btn);
			if (InventoryMenu.shop_array == null)
				btn.sell_btn.visible = false
			else
				btn.sell_btn.visible = true;

			n++;
		}

		container_sort();
		drawBackground();
		set_positions();
	}
}
