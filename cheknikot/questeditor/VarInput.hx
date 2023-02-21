package cheknikot.questeditor;

import cheknikot.quests_results.Quest;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseButton;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import texter.flixel.FlxInputTextRTL;

/**
 * ...
 * @author ...
 */
class VarInput extends FlxGroup
{
	public var text:FlxText = new FlxText();
	public var input:FlxInputTextRTL = new FlxInputTextRTL();

	public var object:Dynamic = null;
	public var var_name:String = null;
	public var var_obj:Dynamic = null;

	public var edit_arr_btn:FlxButton;
	public var edit_bool_btn:FlxButton;
	public var add_array_slot_btn:FlxButton;
	public var remove_array_slot_btn:FlxButton;

	public function new(X:Float = 0, Y:Float = 0, MaxSize:Int = 0)
	{
		super();
		add(text);
		// add(input);

		input.font = MyFlxText.FONT;

		input.size = 15;
		input.wordWrap = true;
		input.fieldWidth = 800;

		edit_arr_btn = new FlxButton(0, 0, 'EDIT', edit_arr_click);
		edit_bool_btn = new FlxButton(0, 0, 'true', edit_bool_click);
		add_array_slot_btn = new FlxButton(0, 0, '+', add_array_slot);
		add_array_slot_btn.makeGraphic(15, 15, FlxColor.GRAY);
		remove_array_slot_btn = new FlxButton(0, 0, '-', remove_array_slot);
		remove_array_slot_btn.makeGraphic(15, 15, FlxColor.RED);
	}

	private function edit_bool_click()
	{
		trace('bool click');
		var _b:Bool = Reflect.getProperty(object, var_name);
		trace(_b);
		_b = !_b;
		trace(_b);

		Reflect.setProperty(object, var_name, _b);
		edit_bool_btn.text = _b + '';
	}

	private function add_array_slot():Void
	{
		var arr:Array<Dynamic> = cast(object, Array<Dynamic>);
		var index:Int = Std.parseInt(var_name);

		if (Std.isOfType(arr[index], Array))
		{
			var _arr1:Array<Dynamic> = cast(arr[index], Array<Dynamic>);
			arr.insert(index, _arr1.copy());
		}
		else
			// if (Std.is(arr[index], Int))
		{
			arr.insert(index, arr[index]);
		}

		VarEditorMenu.state.show_vars_for(object);
	}

	private function remove_array_slot():Void
	{
		var arr:Array<Dynamic> = cast(object, Array<Dynamic>);
		var index:Int = Std.parseInt(var_name);

		arr.splice(index, 1);

		VarEditorMenu.state.show_vars_for(object);
	}

	private function edit_arr_click():Void
	{
		if (Std.isOfType(var_obj, Array))
			VarEditorMenu.state.show_vars_for(var_obj /*, null*/);

		if (Std.isOfType(var_obj, Quest))
		{
			QuestEditor.state.selected_quest = cast(var_obj, Quest);
			QuestEditor.state.refresh_list();
			// VarEditorMenu.state.show_vars_for(object, Quest.save_vars);
		}
	}

	private var update_input:Bool = true;

	public var x:Float = 0;
	public var y:Float = 0;

	public function setPosition(_x:Float, _y:Float):Void
	{
		x = _x;
		y = _y;
	}

	public function connect(_d:Dynamic, _var_name:String):Void
	{
		clear();
		add(text);

		object = _d;
		var_name = _var_name;
		text.text = var_name;

		if (Std.isOfType(object, Array))
		{
			var_obj = cast(object, Array<Dynamic>)[Std.parseInt(_var_name)];
		}
		else
			var_obj = Reflect.getProperty(_d, var_name);

		// var_obj = Reflect.field(_d, var_name);
		// remove(input, true);
		// remove(edit_arr_btn, true);

		// trace(object + ':' + var_name + ':' + var_obj);
		update_input = true;
		if (Std.isOfType(var_obj, Array))
		{
			update_input = false;
			trace('ARRAY FINDED', var_name);
			add(edit_arr_btn);
			var _arr:Array<Dynamic> = cast(var_obj, Array<Dynamic>);
			var _str:String = '';
			if (_arr != null)
			{
				_str = '' + _arr[0];
				if (_str.length > 7)
				{
					_str = _str.substr(0, 7);
				}
			}
			edit_arr_btn.text = 'Edit: ' + _str;
		}
		else if (Std.isOfType(var_obj, Quest))
		{
			update_input = false;
			add(edit_arr_btn);

			trace('QUEST FINDED', var_name);
		}
		else if (Std.isOfType(var_obj, Bool))
		{
			update_input = false;
			add(edit_bool_btn);
			edit_bool_btn.text = var_obj + '';
		}
		else
		{
			add(input);
			trace('not quest', var_name, length, Reflect.getProperty(_d, var_name));
			// input.text = var_obj + '';
			update_input = true;
		}

		if (Std.isOfType(_d, Array))
		{
			trace('this is ARRAY, add +- btns');
			// update_input = false;
			add(add_array_slot_btn);
			add(remove_array_slot_btn);
			input.text = '' + cast(object, Array<Dynamic>)[Std.parseInt(_var_name)];
		}
		else
		{
			trace('object:', _d);
			trace('var', var_name);
			trace('text:', Reflect.getProperty(_d, var_name));
			input.text = '' + Reflect.getProperty(_d, var_name);
		}

		trace(text.x, text.y);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		text.y = this.y;
		edit_bool_btn.y = input.y = remove_array_slot_btn.y = add_array_slot_btn.y = edit_arr_btn.y = text.y;

		var _x:Float = text.x + text.width;

		if (this.members.indexOf(edit_arr_btn) >= 0)
		{
			edit_arr_btn.x = _x;
			_x += edit_arr_btn.width;
		}
		if (this.members.indexOf(edit_bool_btn) >= 0)
		{
			edit_bool_btn.x = _x;
			_x += edit_bool_btn.width;
			// trace('edit_bool_btn.x', edit_bool_btn.x);
		}

		if (this.members.indexOf(add_array_slot_btn) >= 0)
		{
			add_array_slot_btn.x = _x;
			_x += add_array_slot_btn.width;

			remove_array_slot_btn.x = _x;
			_x += remove_array_slot_btn.width;
		}

		if (this.members.indexOf(input) >= 0)
		{
			input.x = _x;
			_x += input.width;
			input.updateHitbox();
			// input.text = _x + '';
			try
			{
				var _c:String = String.fromCharCode(8203);
				var _i:Int = input.text.indexOf(_c);
				if (_i != -1)
				{
					var _s1:String = input.text.substring(0, _i);
					var _s2:String = input.text.substr(_i + 1, input.text.length - _i - 1);
					input.text = _s1 + _s2;
				}
				if (input.text.charCodeAt(input.text.length - 1) == 8203)
				{
					input.text = input.text.substr(0, input.text.length - 1);
				}

				if (Std.isOfType(object, Array))
				{
					cast(object, Array<Dynamic>)[Std.parseInt(var_name)] = input.text;
				}
				else
				{
					Reflect.setProperty(object, var_name, input.text);
				}
			}
		}
	}
}
