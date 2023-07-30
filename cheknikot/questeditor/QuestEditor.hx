package cheknikot.questeditor;

import cheknikot.MenuBase;
import cheknikot.MyFlxButton;
import cheknikot.MyScrollablePanel;
import cheknikot.menus.MyMainMenu;
import cheknikot.quests_results.Quest;
import cheknikot.quests_results.conditions.QuestCondition;
import cheknikot.quests_results.results.QR_AddQuest;
import cheknikot.quests_results.results.QuestResult;
import cheknikot.saving.SaveLoad;
import flash.events.Event;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
// import menus.MainMenu;
import openfl.net.FileReference;

/**
 * ...
 * @author ...
 */
class QuestEditor extends MenuBase
{
	public static var state:QuestEditor;

	public var filename:String = 'quests.txt';
	public var quests:Array<Quest> = new Array();
	public var list_panel:MyScrollablePanel = new MyScrollablePanel(150, 300);
	public var cond_panel:MyScrollablePanel = new MyScrollablePanel(150, 300);
	public var res_panel:MyScrollablePanel = new MyScrollablePanel(150, 300);

	public function new(MaxSize:Int = 0)
	{
		super(MaxSize);

		var _dx:Int = 150;

		MyFlxButton.SIZE = 18;
		var _btn:MyFlxButton = new MyFlxButton(0, 0, ['LOAD FILE'], load_click);
		add(_btn);
		_btn = new MyFlxButton(100, 0, ['SAVE FILE'], save_click);
		add(_btn);

		var _y1:Int = 40;
		_btn = new MyFlxButton(_dx * 0, _y1, ['new QUEST'], new_quest_click);
		add(_btn);
		_btn = new MyFlxButton(_dx * 2, _y1, ['new CONDIT'], new_cond_click);
		add(_btn);
		_btn = new MyFlxButton(_dx * 4, _y1, ['new RESULT'], new_res_click);
		add(_btn);

		_btn = new MyFlxButton(_dx * 1, _y1, ['DEL QUEST'], del_quest_click);
		add(_btn);
		_btn = new MyFlxButton(_dx * 3, _y1, ['DEL CONDIT'], del_cond_click);
		add(_btn);
		_btn = new MyFlxButton(_dx * 5, _y1, ['DEL RESULT'], del_res_click);
		add(_btn);

		MyFlxButton.SIZE = 20;

		var _y2:Int = 80;
		add(list_panel);
		list_panel.y = _y2;
		list_panel.set_positions();
		list_panel.drawBackground(FlxColor.GRAY);
		add(cond_panel);
		cond_panel.x = _dx * 2;
		cond_panel.y = _y2;
		cond_panel.set_positions();
		cond_panel.drawBackground(FlxColor.GRAY);
		add(res_panel);
		res_panel.x = _dx * 4;
		res_panel.y = _y2;
		res_panel.set_positions();
		res_panel.drawBackground(FlxColor.GRAY);

		state = this;

		new QC_list();
		new QR_list();
		new VarEditorMenu();

		add(exit_btn);
	}

	override public function exit_click():Void
	{
		super.exit_click();

		MyMainMenu.state.show();
	}

	private function del_quest_click():Void
	{
		if (selected_quest != null)
		{
			quests.remove(selected_quest);
			selected_quest = null;
			refresh_list();
		}
	}

	private function del_cond_click():Void
	{
		if (selected_cond != null)
		{
			var _q:Quest = selected_quest;
			if (_q != null)
			{
				_q.conditions.remove(selected_cond);
				selected_cond = null;
				refresh_conditions();
			}
		}
	}

	private function del_res_click():Void
	{
		if (selected_result != null)
		{
			var _q:Quest = selected_quest;
			if (_q != null)
			{
				_q.results.remove(selected_result);
				selected_result = null;
				refresh_list();
				refresh_results();
			}
		}
	}

	public function remove_addit():Void
	{
		remove(QC_list.state, true);
		remove(QR_list.state, true);
		remove(VarEditorMenu.state, true);
	}

	public var selected_quest:Quest = null;

	private var buttons:Array<FlxButton> = new Array();

	public function refresh_list():Void
	{
		list_panel.container.clear();

		QuestBtn._btn_n = 0;
		var _btn_n:Int = 0;

		// for (b in list_panel)
		// {
		//	remove(b, true);
		// }

		function place_button_for(qst:Quest, _deep:Int):Void
		{
			var _b:QuestBtn = QuestBtn.get_free_button();
			_btn_n++;
			_b.quest = qst;
			_b.text = _btn_n + '.' + qst.trigger_name;
			_b.deep = _deep;
			// _b.y = _btn_n * 20;
			if (qst == selected_quest && selected_quest != null)
			{
				trace('CUR QUEST');
				// _b.label.color = FlxColor.GREEN;
				_b.label.setFormat(_b.label.font, _b.label.size, FlxColor.GREEN);
			}
			else
			{
				// _b.label.color = FlxColor.WHITE;
				_b.label.setFormat(_b.label.font, _b.label.size, FlxColor.WHITE);
			}

			list_panel.container.add(_b);

			for (qr in qst.results)
			{
				if (qr.type == 'QR_AddQuest')
				{
					trace('result QR_AddQuest');
					var qst2:Quest = cast(qr, QR_AddQuest).quest;
					trace(qst2);
					place_button_for(qst2, _deep + 1);
				}
			}
		}

		var _n:Int = -1;
		while (++_n < quests.length)
		{
			var _q:Quest = quests[_n];
			place_button_for(_q, 0);
		}
		list_panel.sort_type = MyScrollablePanel.SORT_LIST;
		list_panel.container_sort();

		for (btn in QuestBtn.BUTTONS)
		{
			btn.x += btn.deep * 3;
		}

		refresh_conditions();
		refresh_results();
	}

	public var selected_cond:QuestCondition = null;

	public function refresh_conditions():Void
	{
		cond_panel.container.clear();
		CondBtn._btn_n = 0;

		if (selected_quest == null)
			return;

		for (cond in selected_quest.conditions)
		{
			var _b:CondBtn = CondBtn.get_free_button();

			_b.condition = cond;
			_b.text = cond.type;

			// _b.y = _btn_n * 20;
			if (cond == selected_cond && selected_cond != null)
			{
				trace('CUR COND');
				// _b.label.color = FlxColor.GREEN;
				_b.label.setFormat(_b.label.font, _b.label.size, FlxColor.GREEN);
			}
			else
			{
				// _b.label.color = FlxColor.WHITE;
				_b.label.setFormat(_b.label.font, _b.label.size, FlxColor.WHITE);
			}

			cond_panel.container.add(_b);
		}
		cond_panel.sort_type = MyScrollablePanel.SORT_LIST;
		cond_panel.container_sort();
	}

	public var selected_result:QuestResult = null;

	public function refresh_results():Void
	{
		res_panel.container.clear();
		ResBtn._btn_n = 0;

		if (selected_quest == null)
			return;

		for (res in selected_quest.results)
		{
			var _b:ResBtn = ResBtn.get_free_button();

			_b.result = res;
			_b.text = res.type;

			// _b.y = _btn_n * 20;
			if (res == selected_result && selected_result != null)
			{
				trace('CUR COND');
				// _b.label.color = FlxColor.GREEN;
				_b.label.setFormat(_b.label.font, _b.label.size, FlxColor.GREEN);
			}
			else
			{
				// _b.label.color = FlxColor.WHITE;
				_b.label.setFormat(_b.label.font, _b.label.size, FlxColor.WHITE);
			}

			res_panel.container.add(_b);
		}
		res_panel.sort_type = MyScrollablePanel.SORT_LIST;
		res_panel.container_sort();
	}

	private function new_quest_click():Void
	{
		trace('new quest click');
		var _q:Quest = new Quest();
		quests.push(_q);
		refresh_list();
	}

	private function new_cond_click():Void
	{
		if (selected_quest == null)
			return;
		// show cond list
		remove_addit();
		add(QC_list.state);
	}

	private function new_res_click():Void
	{
		if (selected_quest == null)
			return;
		// show res_list
		remove_addit();
		add(QR_list.state);
	}

	private function load_click():Void
	{
		trace('clicked on LOAD FILE');
		var fr:FileReference = new FileReference();
		fr.addEventListener(Event.SELECT, _onSelect, false, 0, true);
		fr.addEventListener(Event.CANCEL, _onCancel, false, 0, true);
		fr.browse();
	}

	private function _onSelect(E:Event):Void
	{
		var fr:FileReference = cast(E.target, FileReference);
		// _text.text = fr.name;
		filename = fr.name;
		fr.addEventListener(Event.COMPLETE, _onLoad, false, 0, true);
		fr.load();
	}

	function _onLoad(E:Event):Void
	{
		var fr:FileReference = cast E.target;
		fr.removeEventListener(Event.COMPLETE, _onLoad);

		AF.clear_array(quests);
		trace('STR:' + fr.toString());
		trace('DATA:' + fr.data);

		Quest.load_quests_to_array(fr.data.toString(), quests);

		refresh_list();

		// var loader:Loader = new Loader();
		// loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onImgLoad);
		// loader.loadBytes(fr.data);
	}

	private function _onCancel(_):Void
	{
		trace('CANCELED');
	}

	/*private function reading_data(_):Void
		{
			trace('LOADED, reading data');
			
	}*/
	private function save_click():Void
	{
		trace('clicked on SAVE FILE');
		var fr:FileReference = new FileReference();
		// fr.addEventListener(Event.SELECT, _onSelect, false, 0, true);
		// fr.addEventListener(Event.CANCEL, _onCancel, false, 0, true);
		// fr.browse();

		var data_arr:Array<Dynamic> = new Array();
		for (q in quests)
		{
			data_arr.push(q.getSaveData());
		}

		fr.save(SaveLoad.serialize(data_arr), filename);
	}
}
