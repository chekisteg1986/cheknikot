package cheknikot.questeditor;

import cheknikot.quests_results.conditions.QuestCondition;
import cheknikot.quests_results.results.QuestResult;
import cheknikot.saving.SaveLoad;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class VarEditorMenu extends MyScrollablePanel
{
	public static var BUTTONS:Array<VarInput> = new Array();
	public static var _btn_n:Int = 0;

	public static var state:VarEditorMenu;

	public var back_btn:FlxButton;

	public function new()
	{
		super(200, 200);

		state = this;
		back_btn = new FlxButton(0, 0, '<-', back_click);

		// auto_DY = true;

		DY = 40;
		x = 0;
		y = 400;
		drawBackground(FlxColor.GRAY);
	}

	private function back_click():Void
	{
		var len:Int = history.length;
		if (len > 0)
		{
			history.splice(len - 1, 1);
			show_vars_for(history[len - 2]);
		}
	}

	public static function get_free_button():VarInput
	{
		if (_btn_n >= BUTTONS.length)
		{
			BUTTONS.push(new VarInput());
		}
		var _b:VarInput = BUTTONS[_btn_n];

		_btn_n++;
		return _b;
	}

	public var history:Array<Dynamic> = new Array();

	public var object:Dynamic;

	public function show_vars_for(_d:Dynamic):Void
	{
		object = _d;
		if (history.length == 0)
		{
			history.push(_d);
		}
		else
		{
			if (history[history.length - 1] != _d)
				history.push(_d);
		}

		QuestEditor.state.remove_addit();
		container.clear();
		if (_d == null)
			return;
		_btn_n = 0;
		QuestEditor.state.add(this);
		var _b:VarInput = null;
		if (Std.isOfType(_d, Array))
		{
			var _arr:Array<Dynamic> = cast(_d, Array<Dynamic>);
			trace('showing vars for ARRAY', _arr.length);
			var _n:Int = -1;
			while (++_n < _arr.length)
			{
				_b = get_free_button();
				_b.connect(_d, _n + '');
				container.add(_b);
			}
			// place add/remove btns
		}
		else
		{
			var _vars:Array<String> = get_vars(_d);

			for (_var_name in _vars)
			{
				if (_var_name == 'type')
					continue;

				// EDIT BUTTON
				// var _var:Dynamic = Reflect.getProperty(_d, _var_name);
				_b = get_free_button();
				_b.connect(_d, _var_name);
				container.add(_b);
			}
		}

		container.add(back_btn);
		sort_type = MyScrollablePanel.SORT_LIST;
		// auto_DY = true;
		set_positions();
		container_sort();
	}

	public static function get_vars(_d:Dynamic):Array<String>
	{
		// if (Std.is(_d, QuestCondition)) return cast(_d, QuestCondition).get_save_vars();
		// if (Std.is(_d, QuestResult)) return cast(_d, QuestResult).get_save_vars();
		return SaveLoad.getSaveVars(_d);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (Std.isOfType(object, Array))
		{
			set_positions();
			container_sort();
		}
	}
}
