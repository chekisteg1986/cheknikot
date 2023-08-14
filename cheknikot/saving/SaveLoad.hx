package cheknikot.saving;

import flixel.addons.ui.FlxUICursor.WidgetList;
import flixel.util.FlxSave;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.utils.Object;

/**
 * ...
 * @author ...
 */
class SaveLoad
{
	public static var save:FlxSave;
	public static var autosave_slot:FlxSave;
	public static var dynamicSaveFunc:Void->Dynamic;

	public static function initSaveFile():Void
	{
		save = new FlxSave();
		save.bind('save');
		if (save.data.slots == null)
		{
			trace('New Save File');
			var _slots:Array<Dynamic> = save.data.slots = new Array<SaveSlot>();
			var _n:Int = 10;
			while (--_n >= 0)
			{
				_slots.push(new SaveSlot());
			}
		}
		else
		{
			trace('Old Save File');
		}
	}

	public static function serialize(d:Dynamic):String
	{
		var _s:Serializer = new Serializer();
		_s.serialize(d);
		return _s.toString();
	}

	public static function unserialize(s:String):Dynamic
	{
		var _s:Unserializer = new Unserializer(s);
		return _s.unserialize();
	}

	public static function getArraySaveData(_a:Array<Dynamic>, _class:Dynamic = null):Array<Dynamic>
	{
		if (_a == null)
			return null;

		var arr:Array<Dynamic> = new Array();

		var i:Int = -1;
		var arr_i:Int = 0;
		while (++i < _a.length)
		{
			if (_a[i] == null)
				continue;

			if (_class != null)
				if (Type.getClass(_a[i]) != _class)
					continue;

			arr[arr_i] = getSaveData(_a[i]);
			arr_i++;
		}
		return arr;
	}

	public static function getSaveVars(d:Dynamic):Array<String>
	{
		var _class:Dynamic = Type.getClass(d);
		var _vars:Array<String> = Reflect.getProperty(_class, 'save_vars');
		trace('type:', _class, 'vars:', _vars);
		return _vars;
	}

	public static function getSaveData(_obj:Dynamic, _pass_personal_function:Bool = false):Dynamic
	{
		if (!_pass_personal_function)
		{
			var _getSaveData_func:Void->Dynamic = Reflect.getProperty(_obj, 'getSaveData');
			if (_getSaveData_func != null)
			{
				#if html5
				return _obj.getSaveData();
				#else
				return _getSaveData_func();
				#end
			}
		}

		var _class:Dynamic = Type.getClass(_obj);
		var _save_vars:Array<String> = Reflect.getProperty(_class, 'save_vars');
		// trace(_class + ' save vars ' + _save_vars);
		if (_save_vars != null)
			return getSaveDataFromSavevars(_obj, _save_vars);

		// trace('ERROR No Save Data for class ' + _class);
		return null;
	}

	public static function export_save():Void {}

	public static function getSaveDataFromSavevars(_o:Dynamic, save_vars:Array<String>):Dynamic
	{
		var n:Int = save_vars.length;
		var result:Dynamic = new Object();
		var prop:String;
		while (--n >= 0)
		{
			prop = save_vars[n];
			var x:Dynamic = Reflect.getProperty(_o, prop);
			if (x != null)
			{
				var _x:Dynamic = getSaveData(x);
				if (_x != null)
					x = _x;
			}

			Reflect.setField(result, prop, x);
		}
		return result;
	}

	public static function setDataUnic(_o:Dynamic, _data:Dynamic):Void
	{
		var _class:Dynamic = Type.getClass(_o);
		setData(_o, _class, _data);
	}

	public static function setData(_o:Dynamic, _class:Dynamic, _data:Dynamic):Void
	{
		if (_o == null)
		{
			trace('ERROR:set_data to NULL object', _class, _data);
			return;
		}

		var save_vars:Array<String> = Reflect.getProperty(_class, 'save_vars');

		/*if (Std.isOfType(_data, Array))
			{
				trace('converting');
				_data = convert(_data, save_vars);
				trace(_data);
		}*/

		var n:Int = save_vars.length;
		var prop:String = 'prop';

		try
		{
			while (--n >= 0)
			{
				prop = save_vars[n];
				// property of blank object
				var x:Dynamic = Reflect.getProperty(_o, prop);
				var _data_x:Dynamic = Reflect.getProperty(_data, prop);

				// checking if property x is an object lo load
				if (x != null)
				{
					if (Reflect.getProperty(x, 'loadSaveData') != null)
					{
						trace(_data);
						trace(prop, 'have load_save_data function');

						#if html5
						x.loadSaveData(_data_x);
						#else
						var func:Array<Dynamic>->Void = Reflect.field(x, 'loadSaveData');
						func(_data_x);
						#end
						continue;
					}
					else
					{
						// trace(prop, 'Have no load_array function');
					}
				}
				else
				{
					trace('property ' + prop + ' is null');
				}

				// trace(_o, prop, _data);
				Reflect.setProperty(_o, prop, _data_x);
			}
		}
		catch (msg:String)
		{
			trace('error in set data' + prop + msg);
			return;
		}
	}

	/*public static function convert(_arr:Array<Dynamic>, _save_vars:Array<String>):Dynamic
		{
			trace('converting');
			trace(_arr);

			var _res:Object = new Object();
			var _i:Int = _save_vars.length;
			while (--_i >= 0)
			{
				Reflect.setProperty(_res, _save_vars[_i], _arr[_i]);
			}
			_i = _save_vars.length - 1;
			var _n:Int = 1;
			while (++_i < _arr.length)
			{
				Reflect.setProperty(_res, 'addit' + _n, _arr[_i]);
				_n++;
			}
			return _res;
	}*/
	public static function have_saved_game():Bool
	{
		autosave_slot = new FlxSave();
		trace('checking save game');
		autosave_slot.bind('autosave');
		trace('binded');
		// trace('autosave data', autosave_slot.data ==);

		if (autosave_slot.data == null)
		{
			autosave_slot.destroy();
			return false;
		}
		if (autosave_slot.data.serial_data == null)
		{
			autosave_slot.destroy();
			return false;
		}

		autosave_slot.destroy();
		return true;
	}

	public static function erase_slot():Void
	{
		autosave_slot = new FlxSave();
		autosave_slot.bind('autosave');
		trace('Erase slot');
		autosave_slot.data.serial_data = null;
		autosave_slot.close();
	}
	/*public static function get_attr(attr:String, data:Array<Dynamic>, save_vars:Array<String>):Dynamic
		{
			var i:Int = save_vars.indexOf(attr);
			if (i == -1)
				return null;
			return data[i];
	}*/
}
