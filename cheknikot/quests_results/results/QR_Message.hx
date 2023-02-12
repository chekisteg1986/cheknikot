package cheknikot.quests_results.results;

import cheknikot.messanger.GameMessage;
import cheknikot.quests_results.results.QuestResult;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class QR_Message extends QuestResult
{
	public static var save_vars:Array<String> = ['type', 'message'];

	public var message:Array<Array<String>>;

	public function new()
	{
		super();
		type = 'QR_Message';
		message = new Array();
		message.push(['face', 'eng', 'ru', 'ua']);
	}

	public function add_message(text:Array<String>):Void
	{
		if (message == null)
			message = new Array();
		message.push(text);
	}

	private var message_i:Int = 0;

	public function show_message(t:Array<String>, btns:Array<Array<String>>, res:Array<Void->Void>, face:String, image:FlxSprite = null):Void
	{
		// GameMessage.messanger.set_text(
		GameMessage.messanger.set_text(t, btns, res, face);
	}

	public function next_message():Void
	{
		trace('message_i', message_i, message);
		if (message_i < message.length)
		{
			var _face:String = message[message_i][0];
			var _text:Array<String> = message[message_i].slice(1);
			show_message(_text, [['ok']], [next_message], _face);
			message_i++;
		}
		else {}
	}

	override public function make_result_actions():Void
	{
		if (message != null)
		{
			next_message();
		}
	}
}
