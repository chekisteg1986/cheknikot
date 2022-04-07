package cheknikot.messanger;

import cheknikot.MyFlxButton;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class AnswerBtn extends MyFlxButton
{
	public var func:Void->Void;

	private var messanger:GameMessage;

	public function new(_messanger:GameMessage)
	{
		super(0, 0, [' '], OnClick, true);

		messanger = _messanger;
	}

	public function OnClick():Void
	{
		trace('ANSWER CLICK');
		if (func == null)
			return;

		if (alpha <= 0.2)
			return;

		alpha = 0;

		messanger.visible = false;
		FlxG.state.remove(messanger, true);

		func();
	}

	public function activate(_):Void
	{
		// set_active(true);
		this.alpha = 1;
		if (func == null)
			this.alpha = 0.5;
		this.updateHitbox();
		trace('Activate btn', x, y, text, alpha);
	}

	override public function update(elapsed:Float):Void
	{
		GameMessage.messanger.remove(this, true);
		GameMessage.messanger.add(this);

		super.update(elapsed);
	}
}
