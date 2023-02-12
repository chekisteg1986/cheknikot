package cheknikot;

import cheknikot.MyEducationSprite;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
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
	public var parent:FlxGroup = null;
	public var exit_btn:MyFlxButton;
	public var tooltips_on_off:FlxButton;
	public var educ_spr:MyEducationSprite;

	public var mouse_block:FlxSprite;
	public var background:FlxSprite;
	public var border:FlxSprite;

	/*public var backspr:FlxSprite = null;

		public function make_back(color:FlxColor):Void
		{
			backspr =  new FlxSprite();
			backspr.makeGraphic(1, 1, FlxColor.BLACK);
			backspr.scale.set(FlxG.width, FlxG.height);
			add(backspr);
	}*/
	public var last_added_object:FlxBasic;

	override function add(Object:FlxBasic):FlxBasic
	{
		last_added_object = Object;
		return super.add(Object);
	}

	public var on_screen:Bool = false;
	public var mute_on_off:MuteBtn;

	private var add_x:Float = 0;
	private var add_y:Float = 0;

	public function setAddPosition(_x:Float, _y:Float):Void
	{
		add_x = _x;
		add_y = _y;
	}

	public function addNextV(_obj:FlxObject, _dy:Float = 0):FlxBasic
	{
		if (_obj == null)
			return null;
		add(_obj);
		_obj.setPosition(add_x, add_y);
		if (_dy == 0)
			_dy = _obj.height;
		add_y += _dy;
		return _obj;
	}

	public function addNextH(_obj:FlxObject, _dx:Float = 0):FlxBasic
	{
		if (_obj == null)
			return null;
		add(_obj);
		_obj.setPosition(add_x, add_y);
		if (_dx == 0)
			_dx = _obj.width;
		add_x += _dx;
		return _obj;
	}

	public function setPosition(_x:Float, _y:Float):Void
	{
		setBackgroundPosition(_x, _y);
	}

	public function createBackground(_width:Float, _height:Float, _back_color:FlxColor = FlxColor.BLACK, _border_color:FlxColor = FlxColor.WHITE):Void
	{
		border.makeGraphic(1, 1, _border_color);
		background.makeGraphic(1, 1, _back_color);
		border.scale.set(_width, _height);
		background.scale.set(_width - 2, _height - 2);
		border.updateHitbox();
		background.updateHitbox();
		background.visible = border.visible = true;
		setBackgroundPosition(0, 0);
	}

	public function setBackgroundPosition(_x:Float, _y:Float):Void
	{
		border.setPosition(_x, _y);
		background.setPosition(_x + 1, _y + 1);
	}

	public function load_background(_ass:FlxGraphicAsset):Void
	{
		background.loadGraphic(_ass);
		AF.scale_picture(background);
		background.screenCenter();
		background.visible = true;
	}

	public function place_mute_btn():Void
	{
		mute_on_off = new MuteBtn();
		// tooltips_on_off.loadGraphic(AssetPaths.tooltips__png, true, 7, 14);
		// tooltips_on_off.scale.set(3, 3);

		// tooltips_on_off.x = FlxG.width - tooltips_on_off.width;
		mute_on_off.x = 0;
		mute_on_off.y = FlxG.height - mute_on_off.height;
		// FlxG.state.tooltips.add(tooltips_on_off, {title:'Tooltips', body:'on/off'});
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
		// FlxG.state.tooltips.add(tooltips_on_off, {title:'Tooltips', body:'on/off'});
		add(tooltips_on_off);
	}

	public function new(MaxSize:Int = 0)
	{
		super(MaxSize);

		border = new FlxSprite();
		border.visible = false;
		add(border);
		background = new FlxSprite();
		background.visible = false;
		add(background);

		exit_btn = new MyFlxButton(0, 0, MyStandartText.EXIT, exit_click);
		exit_btn.x = FlxG.width - exit_btn.frameWidth;
		exit_btn.y = FlxG.height - exit_btn.frameHeight;
	}

	public function mouseBlock():Void
	{
		mouse_block = new FlxSprite();
		mouse_block.makeGraphic(1, 1, FlxColor.fromRGB(255, 255, 255, 50));
		mouse_block.scale.set(FlxG.width, FlxG.height);

		this.insert(0, mouse_block);
		mouse_block.updateHitbox();
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
		// FlxG.state.remove(this,true);
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

	public function showHide():Void
	{
		if (!on_screen)
		{
			// hideMenus();
			show();
		}
		else
			hide();
	}

	public function show():Void
	{
		if (parent == null)
			FlxG.state.add(this);
		else
			parent.add(this);
		on_screen = true;
		// FlxG.state.add(this);
	}

	public function hide():Void
	{
		if (parent == null)
			FlxG.state.remove(this, true);
		else
			parent.remove(this, true);
		on_screen = false;
		// FlxG.state.remove(this, true);
	}
}
