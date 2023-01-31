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
	public static var state:ConfirmMenu;

	private var background2:FlxSprite;
	private var text:MyFlxText;
	private var yes_btn:MyFlxButton;
	private var no_btn:MyFlxButton;
	private var yes_func:Void->Void;

	override public function new()
	{
		super();
		state = this;
		this.createBackground(100, 200);
		background.screenCenter();
		border.screenCenter();
		this.mouseBlock();

		text = new MyFlxText(0, 0, 0, ['Are you sure?', 'Вы уверены?', 'Ви впевнені?']);
		yes_btn = new MyFlxButton(0, 0, ['Yes', 'Да', 'Так'], yesClick);
		no_btn = new MyFlxButton(0, 0, ['No', 'Нет', 'Ні'], noClick);
		// background2 = new FlxSprite();
		// background2.makeGraphic(250, 250, FlxColor.GRAY);
		// background2.screenCenter();

		// add(background);
		// add(background2);
		add(text);
		add(yes_btn);
		add(no_btn);

		text.x = background.x + 10;
		text.y = background.y + 10;

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

	public function confirm(_func:Void->Void, _text:String = null, _state:FlxGroup = null):Void
	{
		yes_func = _func;
		if (_text != null)
			text.change_text(_text)
		else
			text.new_text(['Are you sure?', 'Вы уверены?', 'Ви впевнені?']);
		parent = _state;
		show();
		setAddPosition(FlxG.width / 2 - text.width / 2, FlxG.height / 2 - text.height);
		addNextV(text);
		addNextV(yes_btn);
		no_btn.y = yes_btn.y;
		no_btn.x = text.x + text.width - no_btn.width;
		createBackground(text.width + 4, this.add_y - text.y + 4);
		setBackgroundPosition(text.x - 2, text.y - 2);
	}
}
