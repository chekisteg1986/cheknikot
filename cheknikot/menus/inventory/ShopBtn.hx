package cheknikot.menus.inventory;

import cheknikot.AF;
import cheknikot.MyFlxText;
import cheknikot.char_additions.EquipmentSlotBasic;
import cheknikot.char_additions.EquipmentStatsBasic;
import flixel.FlxG;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import objects.Item;

/**
 * ...
 * @author ...
 */
class ShopBtn extends ItemBtn
{
	public var sack_array:Array<Item>;

	public function new()
	{
		super();
		buy_btn = new MyFlxButton(0, 0, ['Buy'], buy_click);
	}

	private function buy_click():Void
	{
		if (InventoryMenu.money >= item.get_price())
		{
			InventoryMenu.money -= item.get_price();
			InventoryMenu.sack.push(item);
			InventoryMenu.shop_array.remove(item);
			InventoryMenu.menu.show_sack();
			InventoryMenu.menu.show_shop();
		}
	}

	override function onClick():Void
	{
		super.onClick();
	}
}
