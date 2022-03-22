package cheknikot.char_additions;


/**
 * ...
 * @author ...
 */
class EquipmentSlotBasic 
{
	public var item_type:String;
	public var current_item:EquipmentStatsBasic;
	
	

	public function new() 
	{
		
	}
	
	public function get_class_name():String
	{
		return item_type;
	}
	
}