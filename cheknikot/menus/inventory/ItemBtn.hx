package cheknikot.menus.inventory;

import cheknikot.MyFlxText;
import cheknikot.char_additions.EquipmentStatsBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * ...
 * @author ...
 */
class ItemBtn extends MenuBase
{
	public var item:EquipmentStatsBasic = null;

	public var sprite:FlxSprite;
	public var name_txt:MyFlxText;
	public var description_txt:MyFlxText;

	public var equip_btn:MyFlxButton;
	public var unequip_btn:MyFlxButton;
	public var sell_btn:MyFlxButton;
	public var buy_btn:MyFlxButton;
	public var price_txt:MyFlxText;

	public function new()
	{
		super();
		sprite = new FlxSprite();
		name_txt = new MyFlxText(0, 0, 0, null);
		description_txt = new MyFlxText(0, 0, 0, null);

		price_txt = new MyFlxText(0, 0, 0, null);
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
			sprite.loadGraphic(AssetPaths.no_item__png);
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
			sprite.loadGraphicFromSprite(item.inventory_spr);

			if (sprite.animation.getByName('0') != null)
				sprite.animation.remove('0');

			if (item.inventory_spr.animation.curAnim != null)
			{
				sprite.animation.add('0', item.inventory_spr.animation.curAnim.frames, 0);
				sprite.animation.play('0');
			}

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

	override function setPosition(_x:Float, _y:Float)
	{
		trace('SetPositions');
		super.setPosition(_x, _y);
		setAddPosition(_x, _y);
		addNextH(sprite);
		addNextH(description_txt);

		setAddPosition(_x, _y + Math.max(sprite.height, description_txt.height));
		addNextH(buy_btn);
		addNextH(sell_btn);
		addNextH(price_txt);
		addNextH(equip_btn);
		addNextH(unequip_btn);
	}

	private function onClick():Void {}
}
