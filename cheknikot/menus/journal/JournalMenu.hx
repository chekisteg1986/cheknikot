package cheknikot.menus.journal;

import cheknikot.MenuBase;
import cheknikot.MyEducationSprite;
import cheknikot.MyScrollablePanel;
import cheknikot.quests_results.Quest;
import cheknikot.quests_results.results.QR_AddQuest;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

// import menus.ScrollableList;

/**
 * ...
 * @author ...
 */
class JournalMenu extends MenuBase
{
	public static var menu:JournalMenu;

	public var quests_btns:Array<QuestBtn> = new Array();
	public var quests_panel:MyScrollablePanel;

	public var description_txt:MyFlxText;

	public var selected_quest:Quest;

	// public var educ_spr:EducationSprite;

	public function new(MaxSize:Int = 0)
	{
		super(MaxSize);

		// var spr:FlxSprite = new FlxSprite(0, 0, AssetPaths.picture_3__png);
		// add(spr);
		// AF.scale_picture(spr);
		// spr.screenCenter();

		menu = this;
		add(exit_btn);

		quests_panel = new MyScrollablePanel(Math.floor(FlxG.width / 3), FlxG.height);
		quests_panel.x = 0;
		quests_panel.sort_type = MyScrollablePanel.SORT_LIST;
		// quests_panel.sprites_in_list_row = 1;
		if (GameParams.testing)
			quests_panel.DY = 15;
		add(quests_panel);

		var _x:Float = quests_panel.x + quests_panel.WIDTH;
		var _w:Float = FlxG.width - _x;

		description_txt = new MyFlxText(_x, 0, _w, [' ']);
		add(description_txt);
		educ_spr = new MyEducationSprite(this);
		add(new MuteBtn(0, FlxG.height - 10));
		place_tooltip_btn();
	}

	override public function exit_click():Void
	{
		super.exit_click();
	}

	override function show()
	{
		super.show();
		show_quests();
		if (educ_spr.firstshow)
		{
			create_tooltips();
			educ_spr.show_group();
		}
	}

	override function create_tooltips():Void
	{
		super.create_tooltips();
		educ_spr.shown_object.push(quests_panel.background);
		educ_spr.texts.push([
			'This is your current quest list. Click on a quest button to show quest description.',
			'Это ваш список текущих заданий. Нажмите на кнопку задания, чтобы посмотреть её описание.',
			'Це ваш список поточних завдань. Натисніть на кнопку завдання, щоб подивитись її опис.'
		]);

		educ_spr.shown_object.push(description_txt);
		educ_spr.texts.push([
			'This is quest description. Read it to get some clues.',
			'Это описание задания. Прочтите, чтобы получить подсказки.',
			'Це опис завдання. Прочитайте, щоб отримати підказки.'
		]);
	}

	public function show_quests():Void
	{
		for (qb in quests_btns)
		{
			qb.set_quest(null);
			quests_panel.container.remove(qb, true);
		}

		var i:Int = 0;
		var _add_txt:String = '';

		function setquest(_q:Quest, child:Int = 0):Void
		{
			if ((_q.visible && _q.description[0] != 'none') || GameParams.testing)
			{
				var btn:QuestBtn;
				if (i >= quests_btns.length)
				{
					btn = new QuestBtn();
					quests_btns.push(btn);
				}
				btn = quests_btns[i];
				quests_panel.container.add(btn);

				btn.child = child;
				btn.set_quest(_q);

				if (selected_quest == null)
				{
					btn.onClick();
				}
				i++;

				if (GameParams.testing)
				{
					for (qr in _q.results)
						if (Std.is(qr, QR_AddQuest))
							setquest(cast(qr, QR_AddQuest).quest, child + 1);
				}
			}
		}

		for (q in Quest.current_quests)
			setquest(q);

		quests_panel.container_sort();
		quests_panel.set_positions();
		quests_panel.drawBackground(FlxColor.fromRGB(255, 255, 255, 20));

		set_scroll();
	}
}
