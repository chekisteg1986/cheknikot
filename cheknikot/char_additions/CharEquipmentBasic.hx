package cheknikot.char_additions;

import flixel.FlxSprite;

import objects.Item;

import cheknikot.AF;

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
		
		if(types != null)
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
		for ( s in slots)
		{
			if (s.current_item != null)
			if (s.current_item.id == _item_id) return s.current_item;
		}
		return null;
	}
	
	public function calculate_stats():Void
	{

	}
	
}