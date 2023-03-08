package cheknikot.menus.inventory;

import cheknikot.MyFlxText;
import cheknikot.char_additions.EquipmentSlotBasic;
import cheknikot.char_additions.EquipmentStatsBasic;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

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

	override function set_item(i:EquipmentStatsBasic)
	{
		super.set_item(i);
		if (item == null)
			unequip_btn.visible = false
		else
			unequip_btn.visible = true;
	}

	public function unequipClick():Void
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
