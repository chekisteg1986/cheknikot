package cheknikot.quests_results.results;

import cheknikot.game_objects.GameObject;
import flixel.math.FlxPoint;
import flixel.util.FlxPath;

/**
 * ...
 * @author ...
 */
class QR_SetPath extends QuestResult
{
	public static var save_vars:Array<String> = ['type', 'obj_name', 'position_name', 'on_complete_event'];

	public var obj_name:String = 'name';
	public var position_name:String = 'pos name';
	public var on_complete_event:String = '';

	public function new()
	{
		super();
		type = 'QC_SetPath';
	}

	override public function make_result_actions():Void
	{
		super.make_result_actions();

		var obj:GameObject = AF.get_object_with(MyGameObjectLayer.state.active_objects, 'name', obj_name);
		var pos:IntPoint = AF.get_object_with(MyGameObjectLayer.state.positions, 'name', position_name);
		obj.path = new FlxPath();
		var _path:Array<FlxPoint> = MyGameObjectLayer.state.ground.findPath(obj.getMidpoint(), new FlxPoint(pos.x, pos.y));
		obj.path.onComplete = path_completed;
		obj.path.start(_path);
	}

	public function path_completed(p:FlxPath):Void
	{
		Quest.events.push(on_complete_event);
	}
}
