package cheknikot.menus.journal;

import cheknikot.quests_results.Quest;
import cheknikot.quests_results.conditions.QuestCondition;
import cheknikot.saving.SaveLoad;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class QuestBtn extends MyFlxButton
{
	public var quest:Quest;
	public var child:Int = 0;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y, [' '], onClick);
		if (GameParams.testing)
		{
			makeGraphic(100, 15, FlxColor.TRANSPARENT);
			label.color = FlxColor.RED;

			// loadGraphic(AssetPaths.freespr__png, true, 1, 1);
			// animation.add('1', [0], 0);
			// statusAnimations = ['1', '1', '1'];
			// label.setBorderStyle(FlxTextBorderStyle.NONE);

			scale.set(0.5, 0.5);
		}
	}

	public function set_quest(q:Quest):Void
	{
		quest = q;
		if (q != null)
		{
			// text = '';
			// var n:Int = child;
			// while (--n >= 0) text += '.';

			new_text(q.name);
			if (q.visible)
			{
				// visible = true;
				alpha = 1;
			}
			else
			{
				// visible = false;
				alpha = 0.7;
			}
		}
	}

	public function onClick():Void
	{
		trace('journal click');
		trace(quest.description);
		// trace(quest.clue);

		JournalMenu.menu.description_txt.text = ' ';
		if (quest.description != null)
			JournalMenu.menu.description_txt.new_text(quest.description);
		// if (quest.clue_on) JournalMenu.menu.description_txt.add_text( quest.clue);

		if (GameParams.testing)
		{
			var n:Int = quest.conditions.length;
			while (--n >= 0)
			{
				var qc:QuestCondition = quest.conditions[n];

				// var save_vars:Array<String> = Reflect.getProperty(Type.getClass(qc),'save_vars');
				var save_data:Array<Dynamic> = SaveLoad.getSaveData(qc);
				var m:Int = -1;
				JournalMenu.menu.description_txt.text += Type.getClass(qc);
				while (++m < save_data.length)
				{
					JournalMenu.menu.description_txt.text += save_data[m] + ' ';
				}
			}

			for (qr in quest.results)
			{
				JournalMenu.menu.description_txt.text += qr.type + ' ';
			}
		}
	}
}
