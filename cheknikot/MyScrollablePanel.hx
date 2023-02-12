package cheknikot;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

// import menus.army_management.TroopsManageMenu;

/**
 * ...
 * @author ...
 */
class MyScrollablePanel extends MenuBase
{
	public static inline var SORT_GRID:Int = 0;
	public static inline var SORT_LIST:Int = 1;

	public var container:FlxGroup;

	public var sort_type:Int = 0;

	public var WIDTH:Int = 0;
	public var HEIGHT:Int = 0;

	public var DX:Float = 16;
	public var DY:Float = 16;

	public var current_row:Int = 0;
	public var UP_btn:FlxButton;
	public var DOWN_btn:FlxButton;

	public var x:Float = 0;
	public var y:Float = 0;

	public function new(_width:Int, _height:Int)
	{
		super();

		container = new FlxGroup();
		WIDTH = _width;
		HEIGHT = _height;
		UP_btn = new FlxButton(0, 0, null, up_click);
		DOWN_btn = new FlxButton(0, 0, null, down_click);
		UP_btn.loadGraphic(AssetPaths.up__png, true, 15, 20);
		DOWN_btn.loadGraphic(AssetPaths.up__png, true, 15, 20);
		DOWN_btn.flipY = true;

		add(container);
		add(UP_btn);
		add(DOWN_btn);

		// FlxMouseEventManager.add(sprBack, panel_click);

		forEach(function(spr:FlxBasic)
		{
			if (Std.isOfType(spr, FlxSprite))
			{
				cast(spr, FlxSprite).scrollFactor.set(0, 0);
			}
		});
	}

	public function drawBackground(_color:Int = -1):Void
	{
		if (_color == -1)
			_color = FlxColor.fromRGB(100, 100, 100, 200);
		createBackground(WIDTH, HEIGHT, _color);
		setBackgroundPosition(this.x, this.y);
	}

	public function panel_click(_):Void {}

	private function up_click():Void
	{
		if (current_row > 0)
			current_row--;
		container_sort();
	}

	private function down_click():Void
	{
		current_row++;
		container_sort();
	}

	public function set_positions():Void
	{
		UP_btn.x = x + WIDTH - UP_btn.width;
		DOWN_btn.x = x + WIDTH - DOWN_btn.width;
		UP_btn.y = y;
		DOWN_btn.y = y + HEIGHT - DOWN_btn.height;
	}

	private function container_sort_GRID():Void
	{
		UP_btn.visible = UP_btn.active = false;
		if (current_row > 0)
			UP_btn.visible = UP_btn.active = true;
		DOWN_btn.visible = DOWN_btn.active = false;

		// пределы правой или нижней частии
		var max_x:Float = x + WIDTH - UP_btn.width;
		var max_y:Float = y + HEIGHT;

		// trace('max_y',max_y);

		for (spr in container)
		{
			// spr.active = spr.visible = false;
		}

		var current_x:Float = x;
		var current_y:Float = y;

		var index:Int = 0;
		// var teoretical_row:Int;
		var positions_in_row:Int = Math.ceil((max_x - x) / DX);
		// trace('positions_in_row',positions_in_row);

		for (s in container)
		{
			// if (!s.visible) continue;

			if (current_y > max_y)
			{
				// trace('current_y',current_y);
				DOWN_btn.visible = DOWN_btn.active = true;
				break;
			}

			index = container.members.indexOf(s);
			if (index / positions_in_row < current_row)
				continue;

			if (Reflect.getProperty(s, 'setPosition') != null)
				Reflect.callMethod(s, Reflect.getProperty(s, 'setPosition'), [current_x, current_y]);
			else
			{
				trace('ERRORRRR');
			}
			// s.active = s.visible = true;

			current_x += DX;
			if (current_x > max_x)
			{
				current_x = x;
				current_y += DY;
			}
		}
	}

	public var auto_DY:Bool = false;

	// public var change_x:Bool = true;
	private function container_sort_LIST():Void
	{
		var _row:Int = current_row - 1;
		var _max_row:Int = container.length;
		var _current_y:Float = y;

		for (_spr in container)
		{
			_spr.active = _spr.visible = false;
		}

		// trace('max row', max_row, 'objects',container.length );
		while (++_row < _max_row)
		{
			var _spr:Dynamic = container.members[_row];

			_spr.setPosition(x, _current_y);
			_spr.active = _spr.visible = true;

			_current_y += DY;

			if ((_current_y + DY) > (y + HEIGHT))
			{
				DOWN_btn.visible = DOWN_btn.active = true;
				break;
			}
		}

		// trace('rows:', row,max_row, current_y, (y+HEIGHT));
	}

	public function container_sort():Void
	{
		UP_btn.visible = UP_btn.active = false;
		if (current_row > 0)
			UP_btn.visible = UP_btn.active = true;
		DOWN_btn.visible = DOWN_btn.active = false;

		switch (sort_type)
		{
			case SORT_GRID:
				container_sort_GRID();
			case SORT_LIST:
				container_sort_LIST();
		}
	}
}
