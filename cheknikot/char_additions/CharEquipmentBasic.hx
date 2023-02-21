package cheknikot.char_additions;

import cheknikot.AF;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class CharEquipmentBasic
{
	public var slots:Array<EquipmentSlotBasic> = new Array();

	public var picture:FlxSprite;
	public var summary_stats:EquipmentStatsBasic = new EquipmentStatsBasic();
	public var sack:Array<EquipmentStatsBasic> = new Array();

	public function new(types:Array<String>)
	{
		if (types != null)
			for (str in types)
			{
				var slot:EquipmentSlotBasic = new EquipmentSlotBasic();
				slot.item_type = str;
				slots.push(slot);
			}
		trace('CREATE EQ', slots.length);
	}

	public function get_item_by_id(_item_id:String):EquipmentStatsBasic
	{
		for (s in slots)
		{
			if (s.current_item != null)
				if (s.current_item.id == _item_id)
					return s.current_item;
		}
		return null;
	}

	// public function calculate_stats():Void {}

	public function getSum(_stat:String):Int
	{
		var _res:Int = 0;
		for (_s in slots)
			if (_s.current_item != null)
			{
				_res += Reflect.getProperty(_s.current_item, '_stat');
			}
		return _res;
	}
}
