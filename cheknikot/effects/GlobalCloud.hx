package cheknikot.effects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.animation.FlxAnimation;
import flixel.FlxG;
import globalmap.GlobalMap;
import menus.settings_menu.SettingsMenu;
/**
 * ...
 * @author ...
 */
class GlobalCloud extends FlxSprite 
{

	public function new() 
	{
		super();
		loadGraphic(AssetPaths.clouds__png, true, 40, 30);
		this.x = FlxG.random.int( -100, Math.floor(GlobalMap.map.width));
		this.y = FlxG.random.int(0, Math.floor(GlobalMap.map.height ));
		set_cloud_animation();
		scrollFactor.set(0.5, 0.5);
	}
	private function set_cloud_animation():Void
	{
		var a:FlxAnimation = animation.getByName('play');
		if (a != null) a.destroy();
		
		animation.add('play', [FlxG.random.int(0, 3)], 0, false, FlxG.random.bool(), FlxG.random.bool());
		animation.play('play');
		scale.set(FlxG.random.float(2, 5), FlxG.random.float(1, 3));
		set_alpha(FlxG.random.float(0.5, 1));
		velocity.set(FlxG.random.int(2, 20));
		
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		//if (SettingsMenu.THIS.clouds_on_off)
		//{
			this.visible = SettingsMenu.THIS.clouds_on_off;
		//}
		
		if (!visible) return;
		
		if (x > GlobalMap.map.width )
		{
			set_cloud_animation();
		this.x = -100;
		this.y = FlxG.random.int(0, Math.floor(GlobalMap.map.height));
		}
	}
}