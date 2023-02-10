package cheknikot.quests_results.results;

import cheknikot.dungeoncrawler.DC_GameObject;

class QR_SetProperty extends QuestResult
{
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
		var _objects:Array<DC_GameObject> = AF.getObjectsWith(DC_GameObject.objects, {string_id: object_name});
		for (_object in _objects)
			if (Reflect.hasField(_object, property) Reflect.setField(_object, property, value);
	}
}
