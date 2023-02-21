package cheknikot.quests_results.results;

import cheknikot.dungeoncrawler.DC_GameObject;
import js.html.ObserverCallback;
import openfl.utils.Object;

class QR_SetProperty extends QuestResult
{
	public static var save_vars:Array<String> = ['type', 'object_array', 'object_name', 'property', 'value'];

	public var object_array:String = 'array';
	public var object_name:String = 'name';
	public var property:String = 'property';
	public var value:String = 'value';

	override public function new()
	{
		super();
		this.type = 'QR_SetProperty';
	}

	override function make_result_actions()
	{
		// trace(object_array, object_name, object_name.length, property, value);
		var _array:Array<Dynamic> = Quest.getObjectArray(object_array);
		// trace(object_array + ':' + _array.length);
		var _objects:Array<Object> = AF.getObjectsWith(_array, {string_id: object_name});
		// trace(object_name + ':' + _objects.length);
		for (_object in _objects)
		{
			// trace('have object', object_name);
			if (Reflect.hasField(_object, property))
			{
				// if(Std.isOfType(Reflect.))
				//	trace('has field', property);
				Reflect.setField(_object, property, value);
			}
		}
	}
}
