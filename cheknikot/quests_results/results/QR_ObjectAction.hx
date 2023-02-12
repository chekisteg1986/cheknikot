package cheknikot.quests_results.results;

import cheknikot.dungeoncrawler.DC_GameObject;
import openfl.utils.Object;

class QR_ObjectAction extends QuestResult
{
	public static var save_vars:Array<String> = ['type', 'object_array', 'object_name', 'action'];

	public var object_array:String = 'array';
	public var object_name:String = 'name';
	public var action:String = 'function';

	// public var value:String = 'value';

	override public function new()
	{
		super();
		this.type = 'QR_ObjectAction';
	}

	override function make_result_actions()
	{
		var _array:Array<Dynamic> = Quest.getObjectArray(object_array);
		var _objects:Array<Object> = AF.getObjectsWith(_array, {string_id: object_name});

		trace(this.type + ' ' + _objects.length);
		trace(object_name, object_name.length);

		for (_object in _objects)
			if (Reflect.getProperty(_object, action) != null)
			{
				#if html5
				trace(_object[action]);
				// trace('oop');

				Reflect.callMethod(_object, _object[action], []);

				// Reflect.getProperty(_object, action)();
				#else
				Reflect.getProperty(_object, action)();
				#end
			}
			else
			{
				trace('NO ACTION', action, action.length);
			}
	}
}
