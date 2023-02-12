package cheknikot.menus.inventory;

import cheknikot.MyFlxText;
import cheknikot.char_additions.EquipmentSlotBasic;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import objects.Item;

/**
 * ...
 * @author ...
 */
class EquipmentBtn extends ItemBtn
{
	public var slot:EquipmentSlotBasic;

	public var panel:EquipmentPanel;

	public function new(_panel:EquipmentPanel)
	{
		super();
		panel = _panel;
		unequip_btn = new MyFlxButton(0, 0, ['Unequip'], unequipClick);
	}

	public function set_slot(s:EquipmentSlotBasic):Void
	{
		slot = s;
		set_item(s.current_item);
	}

	override function unequipClick():Void
	{
		if (item == null)
			return;
		// put item into sack
		InventoryMenu.sack.push(item);
		slot.current_item = null;
		InventoryMenu.menu.show_equipment();
		InventoryMenu.menu.show_sack();
	}
}
