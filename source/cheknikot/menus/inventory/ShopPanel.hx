package cheknikot.menus.inventory;

import cheknikot.MyScrollablePanel;
import cheknikot.char_additions.EquipmentStatsBasic;
import objects.Item;

/**
 * ...
 * @author ...
 */
class ShopPanel extends MyScrollablePanel
{
	public var sack_slots:Array<ShopBtn> = new Array();

	public function new(_width:Int, _height:Int)
	{
		super(_width, _height);
		sort_type = MyScrollablePanel.SORT_LIST;
		DY = 30;
	}

	public function show_shop(sack:Array<EquipmentStatsBasic>):Void
	{
		container.clear();
		var n:Int = 0;
		var btn:ShopBtn = null;
		for (item in sack)
		{
			if (n <= sack_slots.length)
			{
				sack_slots.push(new ShopBtn());
			}
			btn = sack_slots[n];

			btn.set_item(item);
			container.add(btn);
			container.add(btn.name_txt);
			container.add(btn.description_txt);
			container.add(btn.price_txt);
			container.add(btn.buy_btn);

			n++;
		}
		sprites_in_list_row = 5;
		container_sort();
		draw_background();
		set_positions();
	}
}
