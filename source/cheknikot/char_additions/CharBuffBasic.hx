package cheknikot.char_additions;

import cheknikot.game_objects.BaseCharacter;
import flixel.effects.particles.FlxEmitter;
/**
 * ...
 * @author ...
 */
class CharBuffBasic
{


	
	public var type:Int = 0;
	public var attributes:CharAttributesBasic;
	public var emitter:FlxEmitter;
	public function new(_char:CharAttributesBasic) 
	{
		attributes = _char;
		attributes.buffs.push(this);
	}
	
	public var time:Float = 10;
	
	public function actions(_elapsed:Float):Void
	{
		
		
	}
	
	public function remove():Void
	{
		attributes.buffs.remove(this);
		
	}
	
}