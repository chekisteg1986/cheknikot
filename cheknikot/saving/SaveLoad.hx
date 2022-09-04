package cheknikot.saving;

import flixel.util.FlxSave;
import haxe.Serializer;
import haxe.Unserializer;

/**
 * ...
 * @author ...
 */
class SaveLoad
{
	public static var autosave_slot:FlxSave;

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

	public static function get_array_save_data(_a:Array<Dynamic>, _class:Dynamic = null):Array<Dynamic>
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

			arr[arr_i] = get_save_data(_a[i]);
			arr_i++;
		}
		return arr;
	}

	public static function get_save_vars(d:Dynamic):Array<String>
	{
		var _class:Dynamic = Type.getClass(d);
		var _vars:Array<String> = Reflect.getProperty(_class, 'save_vars');
		trace('type:', _class, 'vars:', _vars);
		return _vars;
	}

	public static function get_save_data(_obj:Dynamic, _pass_personal_function:Bool = false):Array<Dynamic>
	{
		if (!_pass_personal_function)
		{
			var _get_save_data_func:Void->Dynamic = Reflect.getProperty(_obj, 'get_save_data');
			if (_get_save_data_func != null)
			{
				return _get_save_data_func();
			}
		}

		var _class:Dynamic = Type.getClass(_obj);
		var _save_vars:Array<String> = Reflect.getProperty(_class, 'save_vars');
		// trace(_class + ' save vars ' + _save_vars);
		if (_save_vars != null)
			return get_save_data_from_savevars(_obj, _save_vars);

		// trace('ERROR No Save Data for class ' + _class);
		return null;
	}

	public static function export_save():Void {}

	public static function get_save_data_from_savevars(_o:Dynamic, save_vars:Array<String>):Array<Dynamic>
	{
		var len:Int = save_vars.length;
		var n:Int = -1;
		var result:Dynamic = new Array();
		var prop:String;
		while (++n < len)
		{
			prop = save_vars[n];
			var x:Dynamic = Reflect.getProperty(_o, prop);
			if (x != null)
			{
				/*if (Reflect.hasField(x, 'get_save_data'))
					{
						trace(prop + ' hasField get_save_data');
					}
					if (Reflect.getProperty(x, 'get_save_data') != null)
					{
						trace(prop, ' getProperty get_save_data');
						var func:Void->Array<Dynamic> = Reflect.field(x, 'get_save_data');
						x = func();
				}*/
				var _x:Array<Dynamic> = get_save_data(x);
				if (_x != null)
					x = _x;
			}

			result[n] = x;
		}
		return result;
	}

	private static function load_array_from_data(_data:Array<Dynamic>):Array<Dynamic>
	{
		trace('load array');
		return null;
	}

	public static function set_data_unic(_o:Dynamic, _data:Array<Dynamic>):Void
	{
		var _class:Dynamic = Type.getClass(_o);
		// var _save_vars:Array<String> = Reflect.getProperty(_class, 'save_vars');
		set_data(_o, _class, _data);
	}

	public static function set_data(_o:Dynamic, _class:Dynamic, _data:Array<Dynamic>):Void
	{
		var save_vars:Array<String> = Reflect.getProperty(_class, 'save_vars');
		var len:Int = save_vars.length;
		var len2:Int = _data.length;
		if (len2 < len)
			len = len2;

		var n:Int = -1;
		var prop:String = 'prop';

		try
		{
			while (++n < len)
			{
				prop = save_vars[n];
				var x:Dynamic = Reflect.getProperty(_o, prop);

				if (x != null)
				{
					if (Reflect.getProperty(x, 'load_save_data') != null)
						// if (Reflect.hasField(x, 'load_array'))
					{
						trace(prop, 'have load_save_data function');
						var func:Array<Dynamic>->Void = Reflect.field(x, 'load_save_data');
						func(_data[n]);
						continue;
					}
					else
					{
						// trace(prop, 'Have no load_array function');
					}
				}
				else
				{
					// trace('property ' + prop + ' is null');
				}

				Reflect.setProperty(_o, prop, _data[n]);
			}
		}
		catch (msg:String)
		{
			trace('error in set data' + prop + msg);
			return;
		}
	}

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

	public static function get_attr(attr:String, data:Array<Dynamic>, save_vars:Array<String>):Dynamic
	{
		var i:Int = save_vars.indexOf(attr);
		if (i == -1)
			return null;
		return data[i];
	}
}
