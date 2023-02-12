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
class SackBtn extends ItemBtn
{
	public var sack_array:Array<Item>;

	public function new()
	{
		super();

		equip_btn = new MyFlxButton(0, 0, ['Equip'], equip_click);
		sell_btn = new MyFlxButton(0, 0, ['Sell'], sell_click);
	}

	private function sell_click() {}

	private function equip_click()
	{
		var _class:String = item.item_class;
		var slot:EquipmentSlotBasic = cast(AF.getObjectWith(InventoryMenu.menu.char.equipment.slots, {item_type: _class}), EquipmentSlotBasic);
		trace(slot);
		if (slot == null)
		{
			// no such slot
			trace('NO SUCH SLOT', _class);
			return;
		}

		var i1:EquipmentStatsBasic = slot.current_item;
		var i2:EquipmentStatsBasic = this.item;

		slot.current_item = i2;
		InventoryMenu.sack.remove(i2);
		if (i1 != null)
			InventoryMenu.sack.push(i1);
		InventoryMenu.menu.show_equipment();
		InventoryMenu.menu.show_sack();
	}

	override function onClick():Void
	{
		super.onClick();
	}
}
