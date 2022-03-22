package cheknikot;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

// import menus.army_management.TroopsManageMenu;

/**
 * ...
 * @author ...
 */
class MyScrollablePanel extends FlxSpriteGroup
{
	public static inline var SORT_GRID:Int = 0;
	public static inline var SORT_LIST:Int = 1;

	public var container:FlxSpriteGroup;

	public var sort_type:Int = 0;

	public var WIDTH:Int = 0;
	public var HEIGHT:Int = 0;

	public var DX:Float = 16;
	public var DY:Float = 16;

	public var current_row:Int = 0;
	public var UP_btn:FlxButton;
	public var DOWN_btn:FlxButton;
	public var sprBack:FlxSprite;

	public function new(_width:Int, _height:Int)
	{
		super();

		sprBack = new FlxSprite();
		sprBack.visible = sprBack.active = false;
		add(sprBack);

		container = new FlxSpriteGroup();
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

		FlxMouseEventManager.add(sprBack, panel_click);

		forEach(function(spr:FlxBasic)
		{
			if (Std.isOfType(spr, FlxSprite))
			{
				cast(spr, FlxSprite).scrollFactor.set(0, 0);
			}
		});
	}

	public function panel_click(_):Void {}

	public function draw_background(color:FlxColor = -1):Void
	{
		if (color == -1)
			color = FlxColor.fromRGB(100, 100, 100, 200);
		sprBack.active = sprBack.visible = true;
		sprBack.makeGraphic(WIDTH, HEIGHT, color);
		sprBack.x = x;
		sprBack.y = y;
		sprBack.updateHitbox();
		FlxMouseEventManager.remove(sprBack);
		FlxMouseEventManager.add(sprBack, panel_click);
	}

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

			s.x = current_x;
			s.y = current_y;
			// s.active = s.visible = true;

			current_x += DX;
			if (current_x > max_x)
			{
				current_x = x;
				current_y += DY;
			}
		}
	}

	public var sprites_in_list_row:Int = 1;

	public var auto_DY:Bool = false;

	// public var change_x:Bool = true;
	private function container_sort_LIST():Void
	{
		var row:Int = current_row - 1;
		var sprite_in_row:Int = 0;
		var max_row:Int = Math.floor(container.length / sprites_in_list_row);
		var current_y:Float = y;
		var current_x:Float = 0;

		for (spr in container)
		{
			spr.active = spr.visible = false;
		}

		// trace('max row', max_row, 'objects',container.length );
		while (++row < max_row)
		{
			sprite_in_row = row * sprites_in_list_row;

			// trace('row',row);

			var sprite_n:Int = -1;

			current_x = x;

			var _max_dy:Float = 0;
			while (++sprite_n < sprites_in_list_row)
			{
				var spr:FlxSprite = container.members[sprite_in_row + sprite_n];

				if (auto_DY)
					_max_dy = Math.max(_max_dy, spr.height);
				spr.x = current_x;
				spr.y = current_y;
				// trace(current_x+' '+spr.frameWidth+' ' + spr.width);
				// current_x += spr.frameWidth;
				current_x += spr.width;
				spr.active = spr.visible = true;
			}

			if (auto_DY)
			{
				DY == _max_dy + 2;
			}

			current_y += DY;

			if ((current_y + DY) > (y + HEIGHT))
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
