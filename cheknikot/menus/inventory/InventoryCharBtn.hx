package cheknikot.menus.inventory;
import cheknikot.char_additions.CharAttributesBasic;
import flixel.ui.FlxButton;
import menus.FaceBtn;



/**
 * ...
 * @author ...
 */
class InventoryCharBtn extends FlxButton
{
	public var char:CharAttributesBasic;
	
	public function new() 
	{
		super(0,0,null,OnClick);		
	}
	
	public function set_char(c:CharAttributesBasic):Void
	{
		char = c;
		
		loadGraphicFromSprite(c.face);
		animation.copyFrom(c.face.animation);
	}
	public function OnClick():Void 
	{
		
		InventoryMenu.menu.select_char(this.char);
	}
	
}