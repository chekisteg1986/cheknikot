package cheknikot.char_additions;

import cheknikot.char_additions.CharSkillsBasic;
import cheknikot.sounds.MySounds;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class CharSkillsBasic
{
	public var level:Int = 0;
	public var bonus_level:Int = 0;
	public var charge:Int = 0;
	public var charge_needed:Int = 0;
	public var attributes:CharAttributesBasic;
	public var type:Int = 0;
	// public var autorecharge:Bool = true;
	public var active:Bool = true;

	public function get_tooltip():Dynamic
	{
		return {
			name: 'Skill'
		};
	}

	public function new(_attr:CharAttributesBasic)
	{
		attributes = _attr;
	}

	public function use():Void {}
}
