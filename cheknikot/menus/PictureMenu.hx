package cheknikot.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class PictureMenu extends MenuBase
{
	private var history_text:FlxText;

	private static var messages:FlxTypedGroup<MyFlxText> = new FlxTypedGroup();

	private var next_btn:MyFlxButton;

	public static var THIS:PictureMenu;

	public function new()
	{
		super();
		active = visible = false;
		background = new FlxSprite();
		add(background);

		THIS = this;

		next_btn = new MyFlxButton(0, 0, ['Continue', 'Продолжить', 'Продовжити'], next_click);
		add(next_btn);
		next_btn.y = FlxG.height - next_btn.height;
		AF.put_in_center_x(next_btn, FlxG);

		add(messages);
		set_scroll();
	}

	public var current_y:Float = 0;

	public static var TEXT_SIZE:Int = 15;
	public static var TEXT_COLOR:FlxColor = FlxColor.WHITE;
	public static var BORDER_COLOR:FlxColor = FlxColor.BLACK;

	private function add_txt(s:Array<String>):Void
	{
		var t:MyFlxText = new MyFlxText(0, 0, FlxG.width - 40, s, TEXT_SIZE);
		t.borderStyle = FlxTextBorderStyle.OUTLINE;
		t.borderSize = 2;
		t.color = TEXT_COLOR;
		t.borderColor = BORDER_COLOR;

		t.x = 20;
		t.y = current_y;
		// t.text = s;
		t.alpha = 0;
		t.scrollFactor.set(0, 0);
		current_y += t.height;
		messages.add(t);
	}

	public function show_texts(_pict:FlxGraphicAsset, _texts:Array<Array<String>>):Void
	{
		if (_pict != null)
		{
			background.loadGraphic(_pict);
		}
		else
		{
			background.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		}

		messages.clear();
		current_member_fade_in = 0;

		current_y = 10;

		// background.loadGraphic(Assets[_pict]);

		for (t in _texts)
		{
			add_txt(t);
		}

		AF.scale_picture(background);
		// background.scale.set(Main.picture_scale, Main.picture_scale);
		background.screenCenter();

		set_scroll();
	}

	public static var game_completed:Int = 0;

	public static var exit_function:Void->Void;

	public function next_click():Void
	{
		hide();
		if (exit_function != null)
			exit_function();
	}

	public static function fade_in(_):Void
	{
		var t:FlxText = messages.members[current_member_fade_in];
		trace('fade_in', current_member_fade_in, t);
		if (t == null)
			return;

		FlxTween.tween(t, {alpha: 1}, 2, {onComplete: fade_in});
		current_member_fade_in++;
	}

	private static var current_member_fade_in:Int = 0;

	public static var assets:Array<FlxGraphicAsset> = [null];

	public static inline function enter(_pict:Int, _texts:Array<Array<String>>):Void
	{
		// return_to = _ret;
		trace('enter', _pict);

		current_member_fade_in = 0;

		if (THIS == null)
			new PictureMenu();

		FlxG.state.add(THIS);
		THIS.active = THIS.visible = true;

		THIS.show_texts(assets[_pict], _texts);
		fade_in(null);

		// THIS.next_click();
		// hide();
	}

	override public function hide():Void
	{
		FlxG.state.remove(THIS, true);
		THIS.active = THIS.visible = false;
	}
}
