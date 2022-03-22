package cheknikot.menus.inventory;

import cheknikot.MyFlxText;
import cheknikot.char_additions.EquipmentSlotBasic;
import flixel.FlxG;
import flixel.text.FlxText;
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
	public var unequip_btn:MyFlxButton;

	public function new(_panel:EquipmentPanel)
	{
		super();
		panel = _panel;
		name_txt = new MyFlxText(0, 0, 0, null, 7);
		name_txt.fieldWidth = (FlxG.width / 2 - 20) / 3;
		description_txt = new MyFlxText(0, 0, 0, null, 7);
		description_txt.fieldWidth = name_txt.fieldWidth * 2;
	}

	public function set_slot(s:EquipmentSlotBasic):Void
	{
		slot = s;
		set_item(s.current_item);
	}

	override function onClick():Void
	{
		super.onClick();
		if (item == null)
			return;

		// put item into sack

		InventoryMenu.sack.push(item);
		slot.current_item = null;
		InventoryMenu.menu.show_equipment();
		InventoryMenu.menu.show_sack();
	}
}
