package cheknikot;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic;

/**
 * ...
 * @author ...
 */
class MyFlxTypedGroup<T:FlxBasic> extends FlxTypedGroup<T>
{

	
	public var name:String = null;
	public function new(_name:String,MaxSize:Int=0) 
	{
		super(MaxSize);
		name = _name;
	}
	override public function update(elapsed:Float):Void 
	{
		var last_time:Float = Date.now().getTime();
		//if(AF.timer_on_screen) 
		super.update(elapsed);
		var time:Float = Date.now().getTime() - last_time;
		AF.add_timer(name, time);
		
	}
	
}