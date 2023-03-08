package cheknikot.char_additions;

import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class EquipmentStatsBasic
{
	public static var save_vars:Array<String> = ['id'];

	public var name:Array<String> = null;
	public var id:String = null;
	public var item_class:String = null;
	public var visual_spr:FlxSprite;
	public var inventory_spr:FlxSprite = new FlxSprite();

	public var price:Int = 100;

	// public var attack_mdf:Float = 1;

	public function get_price():Int
	{
		return price;
	}

	dynamic public function getInfo():String
	{
		return 'Info';
	}

	// private static var buf_skill:CharSkillsBasic = new CharSkillsBasic(null,0);

	private static function int(mdf:Int):String
	{
		var res:String = '';
		// mdf = (mdf - 1) * 100;
		if (mdf > 0)
		{
			res += '+';
		}
		else
		{
			res += '-';
		}
		res += mdf;
		return res;
	}

	private static function prc(mdf:Float):String
	{
		var res:String = '';
		mdf = (mdf - 1) * 100;
		if (mdf > 0)
		{
			res += '+';
		}
		else
		{
			res += '-';
		}
		res += (Math.round(mdf) + '%');
		return res;
	}

	public function new() {}

	public function get_name():String
	{
		if (name != null)
			return AF.get_text(name);
		return 'name';
	}
}
