package cheknikot.menus;

import cheknikot.MenuBase;
import cheknikot.MyFlxText;
import cheknikot.menus.LinkButton;
import flash.net.URLRequest;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

// import flixel.input.mouse.FlxMouseEventManager;

/**
 * ...
 * @author ...
 */
class CreditsMenu extends MenuBase
{
	public static var menu:CreditsMenu;

	private var return_btn:MyFlxButton;

	public function new(MaxSize:Int = 0)
	{
		super(MaxSize);
		active = visible = false;

		background = new FlxSprite(0, 0);
		add(background);
		// _bg.screenCenter();

		return_btn = new MyFlxButton(0, 0, ['Return'], return_click);
		add(return_btn);
		return_btn.screenCenter();
		return_btn.y = FlxG.height - return_btn.height;

		var y:Int = 0;
		var dy:Int = 40;

		// var link_id:Int = 0;
		function add_txt(s:String, url:String = null, gr:FlxGraphicAsset = null, url2:String = null, gr2:FlxGraphicAsset = null):Void
		{
			y += dy;

			var _txt:MyFlxText = new MyFlxText(0, y, 0, [s], 20);
			add(_txt);

			if (url != null)
			{
				var s:LinkButton = new LinkButton(_txt.width, y, gr, url);
				add(s);
				s.scale.set(1.4, 1.4);
				s.updateHitbox();
				if (url2 != null)
				{
					var s2:LinkButton = new LinkButton(_txt.width + s.width, y, gr2, url2);
					add(s2);
					s2.scale.set(1.4, 1.4);
					s2.updateHitbox();
				}
			}
		}
		add_txt('Programming, Artwork - Demenkov Dmitry `Chekist`', 'https://www.facebook.com/dmitry.demenkov.92', AssetPaths.fb__png);
		// add_txt('Second Artwork - Petrovska Olha `Nikotrissa`', 'https://www.facebook.com/profile.php?id=100023635891681', AssetPaths.fb__png);
		// add_txt('Second Artwork2 - Egor Kutcenko');
		add_txt('Music by - Chris Logsdon ', 'https://itch.io/profile/chrislsound', AssetPaths.itch__png);

		add_txt('Sound: www.freesoundeffects.com', 'https://www.freesoundeffects.com/', AssetPaths.freesound__png);
		add_txt('opengameart.org `RPG Sound Pack`');
		add_txt('by artisticdude', 'https://opengameart.org/users/artisticdude', AssetPaths.opengameart__png);
		add_txt('opengameart.org `Fantasy Sound Effects Library`');
		add_txt('by Little Robot Sound Factory', 'https://opengameart.org/users/little-robot-sound-factory', AssetPaths.opengameart__png);

		set_scroll();
		menu = this;
	}

	// private static function txt_click(_txt:FlxSprite):Void
	// {
	// var i:Int = _txt.ID;
	// trace('link click',i);
	// flash.Lib.getURL(new URLRequest(urls[i]));
	//
	// trace('url:'+urls[i]);
	// }
	// private static var urls:Array<String> = new Array();
	public function return_click():Void
	{
		hide();
		MyMainMenu.state.show();
	}

	override public function show():Void
	{
		super.show();
		menu.active = menu.visible = true;
		// PlayState.state.add(menu);
		// FlxMouseEventManager.reorder();
	}

	override public function exit_click():Void
	{
		super.exit_click();
		FlxG.state.remove(this, true);
	}
}
