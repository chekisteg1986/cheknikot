package cheknikot.menus.inventory;

import cheknikot.MyFlxText;
import cheknikot.char_additions.EquipmentStatsBasic;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * ...
 * @author ...
 */
class ItemBtn extends FlxButton
{
	public var item:EquipmentStatsBasic = null;

	public var name_txt:MyFlxText;
	public var description_txt:MyFlxText;

	public var equip_btn:MyFlxButton;
	public var sell_btn:MyFlxButton;
	public var buy_btn:MyFlxButton;
	public var price_txt:MyFlxText;

	public function new()
	{
		super(0, 0, null, onClick);

		// centerOrigin();
		// offset.scale(1.5);
	}

	public function set_item(i:EquipmentStatsBasic):Void
	{
		item = i;
		refresh();
	}

	private function refresh():Void
	{
		if (item == null)
		{
			loadGraphic(AssetPaths.no_item__png);
			if (name_txt != null)
			{
				name_txt.new_text(['none', 'ничего', 'нічого']);
			}

			if (description_txt != null)
			{
				description_txt.text = ' ';
			}
		}
		else
		{
			// loadGraphic(item.graphic,);
			loadGraphicFromSprite(item.inventory_spr);

			if (animation.getByName('0') != null)
				animation.remove('0');

			animation.add('0', item.inventory_spr.animation.curAnim.frames, 0);
			statusAnimations = ['0', '0', '0'];
			animation.play('0');

			if (name_txt != null)
			{
				// name_txt.new_text(item.name);
				name_txt.text = item.get_name();
			}
			if (description_txt != null)
			{
				description_txt.text = item.get_text_info();
			}
			if (price_txt != null)
			{
				price_txt.text = item.get_price() + ' Coins';
			}
		}

		// setSize(30, 30);
		// var max:Int = FlxMath.MAX_VALUE_INT(frameWidth, frameHeight);
		// this.graph

		// this.setGraphicSize(20);
		// offset.set((30 - width) / 2, (30 - height) / 2);
	}

	public function set_positions():Void
	{
		name_txt.y = description_txt.y = this.y;
	}

	private function onClick():Void {}
}
