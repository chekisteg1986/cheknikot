package cheknikot.quests_results.conditions;
//import characters.Character;
import cheknikot.IntPoint;
import cheknikot.game_objects.BaseCharacter;

/**
 * ...
 * @author ...
 */
class QC_CharAtPosition extends QuestCondition 
{

	public static var save_vars:Array<String> = ['type', 'char_name', 'position'];
	public var char_name:String = '';
	public var position:String = '';
	public function new() 
	{
		super();
		
	}
	override public function check():Void 
	{
		super.check();
		var _obj:cheknikot.game_objects.BaseCharacter = AF.get_object_with(MyGameObjectLayer.state.active_objects, 'name', char_name);
		if (_obj == null) return;
		var _pos:Array<Dynamic> = AF.get_objects_with(MyGameObjectLayer.state.positions, 'name', position);
		
		for (p in _pos)
		{
			var _p:IntPoint = cast(p, IntPoint);
			
			
			
			if (_obj.getHitbox().containsPoint(_p.flxpoint()))
			{
				complete();
				return;
			}
		}
	}
	
}