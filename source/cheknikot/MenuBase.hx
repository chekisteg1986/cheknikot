package cheknikot;

import cheknikot.MyEducationSprite;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class MenuBase extends FlxGroup
{
	// public static var menu:MenuBase;
	// spublic var interactive:Bool = true;
	public var exit_btn:MyFlxButton;
	public var tooltips_on_off:FlxButton;
	public var educ_spr:MyEducationSprite;

	/*public var backspr:FlxSprite = null;

		public function make_back(color:FlxColor):Void
		{
			backspr =  new FlxSprite();
			backspr.makeGraphic(1, 1, FlxColor.BLACK);
			backspr.scale.set(FlxG.width, FlxG.height);
			add(backspr);
	}*/
	public var mute_on_off:MuteBtn;

	public function place_mute_btn():Void
	{
		mute_on_off = new MuteBtn();
		// tooltips_on_off.loadGraphic(AssetPaths.tooltips__png, true, 7, 14);
		// tooltips_on_off.scale.set(3, 3);

		// tooltips_on_off.x = FlxG.width - tooltips_on_off.width;
		mute_on_off.x = 0;
		mute_on_off.y = FlxG.height - mute_on_off.height;
		// PlayState.state.tooltips.add(tooltips_on_off, {title:'Tooltips', body:'on/off'});
		add(mute_on_off);
	}

	public function place_tooltip_btn():Void
	{
		tooltips_on_off = new FlxButton(0, 0, null, tooltips_click);
		tooltips_on_off.loadGraphic(AssetPaths.tooltips__png, true, 7, 14);
		// tooltips_on_off.scale.set(3, 3);

		// tooltips_on_off.x = FlxG.width - tooltips_on_off.width;
		tooltips_on_off.x = 10;
		tooltips_on_off.y = FlxG.height - tooltips_on_off.height;
		// PlayState.state.tooltips.add(tooltips_on_off, {title:'Tooltips', body:'on/off'});
		add(tooltips_on_off);
	}

	public function new(MaxSize:Int = 0)
	{
		super(MaxSize);

		exit_btn = new MyFlxButton(0, 0, MyStandartText.EXIT, exit_click);
		exit_btn.x = FlxG.width - exit_btn.width;
		exit_btn.y = FlxG.height - exit_btn.height;
	}

	public function tooltips_click():Void
	{
		if (this.members.indexOf(educ_spr) == -1)
		{
			create_tooltips();
			add(educ_spr);
			educ_spr.show_group();
		}
		else
		{
			educ_spr.exit_click();
		}
	}

	private function create_tooltips():Void
	{
		educ_spr.texts = new Array();
		educ_spr.shown_object = new Array();
	}

	public function exit_click():Void
	{
		// if (!interactive) return;
		// if (GameMessage.messanger.visible) return;
		hide();
		// PlayState.state.remove(this,true);
	}

	public function set_scroll():Void
	{
		this.forEach(function(spr:FlxBasic)
		{
			if (Std.isOfType(spr, FlxSprite))
			{
				cast(spr, FlxSprite).scrollFactor.set(0, 0);
			}
		});
	}

	public function show():Void
	{
		PlayState.state.add(this);
	}

	public function hide():Void
	{
		PlayState.state.remove(this, true);
	}
}
