package cheknikot.menus.inventory;

import cheknikot.AF;
import cheknikot.MenuBase;
import cheknikot.MyEducationSprite;
import cheknikot.MyFlxText;
import cheknikot.MyScrollablePanel;
import cheknikot.char_additions.CharAttributesBasic;
import cheknikot.char_additions.EquipmentStatsBasic;
import cheknikot.menus.inventory.EquipmentBtn;
import cheknikot.menus.inventory.InventoryCharBtn;
import cheknikot.menus.inventory.SackBtn;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import objects.Item;

/**
 * ...
 * @author ...
 */
class InventoryMenu extends MenuBase
{
	public static var sack:Array<EquipmentStatsBasic>;

	public var eq_panel:EquipmentPanel;

	public var shop_panel:ShopPanel;
	public var char:CharAttributesBasic;
	public var background:FlxSprite;

	public var sack_panel:SackPanel;

	public static var all_chars:Array<InventoryCharBtn> = new Array();
	public static var menu:InventoryMenu;

	// public static var educ_spr:EducationSprite;
	// private var characters:Array<HeroIcon>;
	private var center_line_x:Int;

	public function new()
	{
		super(0);
		menu = this;
		active = visible = false;
		background = new FlxSprite(0, 0, AssetPaths.picture_2__png);
		AF.scale_picture(background);
		add(background);
		background.screenCenter();

		eq_panel = new EquipmentPanel();

		add(eq_panel);

		add(exit_btn);

		sack_panel = new SackPanel(Math.floor(FlxG.width / 3), FlxG.height - 30);
		sack_panel.x = FlxG.width / 3;
		add(sack_panel);

		shop_panel = new ShopPanel(Math.floor(FlxG.width / 3), FlxG.height - 30);
		shop_panel.x = FlxG.width * 2 / 3;
		add(shop_panel);

		educ_spr = new MyEducationSprite(this);
		// add(new MuteBtn(0,FlxG.height-10));
		place_tooltip_btn();
	}

	public var return_to:String;

	public static var shop_array:Array<EquipmentStatsBasic>;

	override function show():Void
	{
		super.show();
		// return_to = _from_where;

		active = visible = true;
		refresh_parties();
		sack = char.equipment.sack;
		show_equipment();
		show_sack();

		if (shop_array != null)
		{
			shop_panel.visible = true;
			show_shop();
		}
		else
		{
			shop_panel.visible = false;
		}

		if (educ_spr.firstshow)
		{
			create_tooltips();
			educ_spr.show_group();
		}
	}

	private function show_shop():Void
	{
		shop_panel.show_shop(shop_array);
	}

	override function create_tooltips():Void
	{
		/*	super.create_tooltips();
			educ_spr.shown_object.push(char_face);
			educ_spr.texts.push(['This is your selected hero.'
			,'Это ваш выбранный герой.'
			,'Це ваш обраний герой.']);

			educ_spr.shown_object.push(equipment_slots[0]);
			educ_spr.texts.push(
			['This is equipment slots. Every hero can equip certain types of items. Click on a item to unequip it and put it into your sack.'
			,'Это ячейки экипировки. Каждый герой может одеть определённый тип вещей. Нажмите на вещь, чтобы снять её и положить в мешок.'
			,'Це ячейки екіпіровки. Кожен герой може одягти певний тип речей. Натисніть на річ, щоб зняти її та покласти у мішок.']);

			educ_spr.shown_object.push(sack_panel.sprBack);
			educ_spr.texts.push(['This is your item sack. Click on a item to equip it.'
			,'Это ваш мешок. Нажмите на вещь, чтобы одеть ей.'
			,'Це ваш мішок. Натисніть на річ, щоб одягти її. ']);

			educ_spr.shown_object.push(all_chars[0]);
			educ_spr.texts.push(['This is your hero list. Click on a character icon to select another hero.'
			,'Это список героев. Нажмите на иконку персонажа, чтобы выбрать другого героя.'
			,'Це список героїв. Натисніть на іконку персонажа, щоб обрати іншого героя.']); */
	}

	public var exit_to:MenuBase;

	override public function exit_click():Void
	{
		super.exit_click();
		active = visible = false;
		///FirstState.state.remove(this, true);

		exit_to.show();
	}

	public function refresh_parties():Void
	{
		for (spr in all_chars)
			remove(spr, true);

		var cur_y:Float = FlxG.height - 20 * 3 - 5;
		var i:Int = 0;

		// for (p in GlobalMap.party)
		// if (p.side == CharSide.YOURS)
		{
			var cur_x:Int = 0;

			for (h in LocalGame.state.party)
			{
				var char_btn:InventoryCharBtn;
				if (i >= all_chars.length)
				{
					char_btn = new InventoryCharBtn();
					all_chars.push(char_btn);
				}
				else
				{
					char_btn = all_chars[i];
				}
				char_btn.set_char(h.attributes);
				add(char_btn);
				char_btn.x = cur_x;
				char_btn.y = cur_y;
				cur_x += 20;
				i++;
			}
			cur_y += 20;
		}
	}

	public function select_char(_c:CharAttributesBasic):Void
	{
		char = _c;
		// char_face
		eq_panel.select_char(_c);

		sack = char.equipment.sack;
		trace('select char', sack);
		show_equipment();
		show_sack();
	}

	public function show_equipment():Void
	{
		eq_panel.show_equipment(char);
		set_scroll();
	}

	public function show_sack():Void
	{
		trace('show sack', sack);
		sack_panel.show_sack(sack);
	}
}
