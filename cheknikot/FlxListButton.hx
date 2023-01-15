package cheknikot;

import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;

class FlxListButton extends FlxSpriteGroup
{
	public var button:FlxButton;
	public var list:Array<String>;

	// public var list_layer:FlxSpriteGroup = new FlxSpriteGroup();
	private var _buttons:Array<FlxListButtonSelect> = new Array();

	override public function new(_x:Int, _y:Int, _text:String, _list:Array<String>)
	{
		super(_x, _y);
		button = new FlxButton(0, 0, _text, onClick);
		list = _list;
		add(button);
	}

	public function hideList():Void
	{
		for (_b in _buttons)
		{
			remove(_b, true);
		}
		expanded = false;
	}

	private var expanded:Bool = false;

	public var callback_function:String->Void;

	private function onClick():Void
	{
		if (list.length == 0 || expanded)
		{
			hideList();
			return;
		}
		expanded = true;

		// list_layer.clear();
		function _new():FlxListButtonSelect
		{
			trace('create new');
			return new FlxListButtonSelect(0, 0, 'title');
		}
		// if (parent == null)
		//	parent = PlayState.state;

		var _n:Int = 0;
		for (_title in list)
		{
			var _b:FlxListButtonSelect = AF.get_free_object(_buttons, _n, _new);
			_b.parent = this;
			_b.label.text = _title;
			_b.x = button.width;
			_b.y = _n * 20;
			this.add(_b);
			_n++;
		}
		// this.add(list_layer);
	}
}

class FlxListButtonSelect extends FlxButton
{
	public var parent:FlxListButton;

	override public function new(_x:Float, _y:Float, _text:String)
	{
		super(_x, _y, _text, onClick);
	}

	private function onClick():Void
	{
		parent.hideList();
		parent.button.label.text = this.label.text;
		if (parent.callback_function != null)
			parent.callback_function(this.label.text);
	}
}
