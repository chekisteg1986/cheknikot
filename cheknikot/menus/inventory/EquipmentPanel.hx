package cheknikot.menus.inventory;

import char_addits.CharAttributes;
import cheknikot.char_additions.CharAttributesBasic;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author ...
 */
class EquipmentPanel extends MenuBase
{
	public var equipment_slots:Array<EquipmentBtn> = new Array();
	public var equipment_types:Array<MyFlxText> = new Array();
	public var char_face:FlxSprite = new FlxSprite();
	public var char_name:MyFlxText = new MyFlxText();

	private var char:CharAttributesBasic;

	public function new()
	{
		super();
		add(char_face);
		add(char_name);
	}

	public function select_char(_c:CharAttributesBasic):Void
	{
		char = _c;
		char_face.loadGraphicFromSprite(char.face);
		char_face.animation.copyFrom(char.face.animation);
		char_name.x = char_face.getHitbox().right;
		char_name.new_text(char.name);
	}

	public function show_equipment(char:CharAttributesBasic):Void
	{
		// eq_panel.show_equipment();

		trace('show equipment');
		var current_slot_i:Int = 0;
		var btn:EquipmentBtn = null;
		var txt:MyFlxText = null;

		for (btn in equipment_slots)
		{
			remove(btn);
			remove(btn.name_txt);
			remove(btn.description_txt);
		}

		for (txt in equipment_types)
		{
			remove(txt);
		}

		if (char.equipment == null)
			trace('NO INVENTORY');

		if (char.equipment != null)
		{
			trace('show eq', char.equipment.slots.length);
			for (e in char.equipment.slots)
			{
				trace('slot:' + current_slot_i);

				if (current_slot_i <= equipment_slots.length)
				{
					btn = new EquipmentBtn(this);
					equipment_slots.push(btn);
					txt = new MyFlxText();
					equipment_types.push(txt);
				}

				btn = equipment_slots[current_slot_i];
				btn.set_slot(e);

				txt = equipment_types[current_slot_i];

				add(btn);

				add(txt);

				// trace('inv '+txt.text);

				var _name_type:String = e.get_class_name();

				/*for (s in Item.ITEM_CLASSES)
					{
						if (s[0] == e.item_type)
						{
							_name_type = s;
							break;
						}
				}*/

				txt.text = _name_type;
				txt.text += ':';
				txt.x = 0;
				txt.y = current_slot_i * 40 + char_face.getHitbox().bottom;

				btn.setPosition(0, txt.getHitbox().bottom);

				current_slot_i++;
			}
		}

		// set_scroll();
	}
}
