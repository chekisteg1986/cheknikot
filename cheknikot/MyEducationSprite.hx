package cheknikot;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author ...
 */
class MyEducationSprite extends MenuBase
{
	// public var shown:Bool = false;
	public var backspr:FlxSprite;
	public var info_txt:MyFlxText;
	public var firstshow:Bool = true;

	public var current_message_index:Int = 0;

	public var texts:Array<Array<String>> = new Array();
	public var shown_object:Array<Dynamic> = new Array();

	private var left_arrow:FlxSprite = new FlxSprite(0, 0);
	private var right_arrow:FlxSprite = new FlxSprite(0, 0);
	private var up_arrow:FlxSprite = new FlxSprite(0, 0);
	private var down_arrow:FlxSprite = new FlxSprite(0, 0);

	public var next_btn:MyFlxButton;
	public var back_btn:MyFlxButton;

	// public var next_btn:FlxButton;
	public var parent:MenuBase;

	public function new(p:MenuBase)
	{
		super(0);

		parent = p;

		next_btn = new MyFlxButton(0, 0, MyStandartText.NEXT, next_click);
		back_btn = new MyFlxButton(0, 0, MyStandartText.BACK, back_click);
		info_txt = new MyFlxText(0, 0, next_btn.frameWidth * 3);
		info_txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		info_txt.borderColor = FlxColor.BLACK;
		backspr = new FlxSprite();

		for (s in [left_arrow, right_arrow, up_arrow, down_arrow])
		{
			s.loadGraphic(AssetPaths.highlight_arrow__png, true, 9, 16);
			s.animation.add('arrow', [0, 1, 2, 3, 2, 1]);
			s.animation.play('arrow');
		}
		right_arrow.flipX = true;
		up_arrow.angle = 90;
		down_arrow.angle = -90;

		add(backspr);
		add(info_txt);
		add(up_arrow);
		add(down_arrow);
		add(left_arrow);
		add(right_arrow);
		add(exit_btn);

		visible = false;
	}

	public function show_group():Void
	{
		parent.add(this);
		this.visible = true;
		firstshow = false;
		current_message_index = 0;
		show();
	}

	private var cur_spr:Dynamic;

	private function update_coords():Void
	{
		if (cur_spr == null)
		{
			info_txt.screenCenter();
		}
		else
		{
			var p:FlxPoint = null;

			if (Std.isOfType(cur_spr, FlxSprite))
			{
				// trace('sprite');
				p = cast(cur_spr, FlxSprite).getScreenPosition();
			}
			else
			{
				// trace('other');
				p = new FlxPoint(cur_spr.x, cur_spr.y);
			}

			var _x:Float = p.x;
			var _y:Float = p.y;
			var _maxx:Float = _x + cur_spr.width;
			var _maxy:Float = _y + cur_spr.height;

			// trace('screen pos:',_x,_y,_maxx,_maxy);

			left_arrow.x = _x - left_arrow.width;
			right_arrow.x = _maxx;
			left_arrow.y = right_arrow.y = p.y + cur_spr.height / 2 - left_arrow.height / 2;

			up_arrow.y = _y - up_arrow.height;
			down_arrow.y = _maxy;
			up_arrow.x = down_arrow.x = p.x + cur_spr.width / 2 - up_arrow.width / 2;

			// FIND PLACE FOR TEXT AND NEXT_BTN
			info_txt.x = FlxG.width / 2 - info_txt.width / 2;
			var _h:Float = cur_spr.height + info_txt.height + next_btn.height;

			info_txt.y = down_arrow.y + down_arrow.height;

			if ((info_txt.y + _h) > FlxG.height)
			{
				info_txt.y = up_arrow.y - _h - 3;
				if ((info_txt.y + _h) > FlxG.height)
				{
					info_txt.y = FlxG.height - _h;
				}
				// _maxy = _y + cur_spr.height;
			}

			if (info_txt.y < 0)
			{
				info_txt.y = 0;
			}
		}

		next_btn.y = info_txt.y + info_txt.height;

		exit_btn.y = back_btn.y = next_btn.y;
		back_btn.x = FlxG.width / 2 - (back_btn.width + next_btn.width + exit_btn.width) / 2;
		next_btn.x = back_btn.x + back_btn.width;
		exit_btn.x = next_btn.x + next_btn.width;

		backspr.makeGraphic(info_txt.frameWidth + 2, info_txt.frameHeight + 2 + next_btn.frameHeight, FlxColor.fromRGB(255, 255, 255));
		backspr.drawRect(1, 1, info_txt.frameWidth, backspr.frameHeight - 2, FlxColor.BLACK);
		backspr.x = info_txt.x - 1;
		backspr.y = info_txt.y - 1;
	}

	override public function update(elapsed:Float):Void
	{
		if (parent.members.indexOf(this) != (parent.members.length - 1))
		{
			parent.remove(this, true);
			parent.add(this);
		}
		super.update(elapsed);
		update_coords();
	}

	override public function show():Void
	{
		check_buttons();

		// show current message
		info_txt.new_text(texts[current_message_index]);
		cur_spr = shown_object[current_message_index];

		visible = true;

		trace(cur_spr, info_txt.text);

		update_coords();

		set_scroll();
	}

	private function check_buttons():Void
	{
		remove(next_btn, true);
		remove(back_btn, true);
		// remove(exit_btn, true);

		if (current_message_index < (shown_object.length - 1))
			add(next_btn);
		if (current_message_index > 0)
			add(back_btn);
		// add(exit_btn);
	}

	public function next_click():Void
	{
		current_message_index++;

		show();
	}

	public function back_click():Void
	{
		current_message_index--;
		show();
	}

	override public function exit_click():Void
	{
		parent.remove(this, true);
		this.visible = false;
		// if (GlobalMap._globalmap.visible) GlobalMap.game_goes = true;
		// if (GameObjectLayer.state.visible) GameObjectLayer.game_goes = true;
	}
}
