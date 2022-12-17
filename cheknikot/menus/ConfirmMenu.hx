package cheknikot.menus;

import cheknikot.MenuBase;
import cheknikot.MyFlxButton;
import cheknikot.MyFlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class ConfirmMenu extends MenuBase
{
	private static var state:ConfirmMenu;

	private var background2:FlxSprite;
	private var text:MyFlxText;
	private var yes_btn:MyFlxButton;
	private var no_btn:MyFlxButton;
	private var yes_func:Void->Void;

	override public function new()
	{
		super();
		state = this;
		background.makeGraphic(1, 1, FlxColor.TRANSPARENT);
		background.scale.set(FlxG.width, FlxG.height);
		background.updateHitbox();

		text = new MyFlxText(0, 0, 0, ['Are you sure?', 'Вы уверены?', 'Ви впевнені?']);
		yes_btn = new MyFlxButton(0, 0, ['Yes', 'Да', 'Так'], yesClick);
		no_btn = new MyFlxButton(0, 0, ['No', 'Нет', 'Ні'], noClick);
		background2 = new FlxSprite();
		background2.makeGraphic(250, 250, FlxColor.GRAY);
		background2.screenCenter();

		add(background);
		add(background2);
		add(text);
		add(yes_btn);
		add(no_btn);

		text.x = background2.x + 10;
		text.y = background2.y + 10;

		yes_btn.setPosition(text.x, text.y + text.height);
		no_btn.setPosition(text.x + text.width - 10 - no_btn.width, yes_btn.y);
	}

	private function yesClick():Void
	{
		yes_func();
		hide();
	}

	private function noClick():Void
	{
		hide();
	}

	public static function confirm(_func:Void->Void, _state:FlxGroup = null):Void
	{
		state.yes_func = _func;
		state.parent = _state;
		state.show();
	}
}
