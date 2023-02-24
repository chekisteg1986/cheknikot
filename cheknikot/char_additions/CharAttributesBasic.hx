package cheknikot.char_additions;

import cheknikot.char_additions.CharStatsBasic;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class CharAttributesBasic
{
	public var name:Array<String>;

	public var stats:CharStatsBasic;

	public var equipment:CharEquipmentBasic;
	public var skills:Array<CharSkillsBasic>;
	public var buffs:Array<CharBuffBasic>;
	public var face:FlxSprite;

	public function new() {}
}
