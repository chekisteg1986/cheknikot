package cheknikot.dungeoncrawler;

import flixel.FlxStrip;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxPoint;
/**
 * ...
 * @author ...
 */
class DC_row extends FlxStrip 
{

	public var sprites:Array<DC_sprite> = new Array();
	public var sprites_on_screen:FlxSpriteGroup = new FlxSpriteGroup();
	public var parent:DC_screen;
	public function new() 
	{
		super();
		this.scrollFactor.set(0, 0);
		sprites_on_screen.scrollFactor.set(0, 0);
	}
	public function add_quads(_arr:Array < DC_quad>):Void
	{
		var _n:Int = _arr.length;
		while (--_n >= 0)
		{
			add_quad(_arr[_n]);
		}
	}
	public function add_quad(_quad:DC_quad):Void
	{
		
		
		var _quad_index:Int = Math.floor(vertices.length/8);
		var _in_index:Int = _quad_index * 4;
		
		//trace('add_quad',_quad_index, _in_index);
		
		var _n:Int = -1;
		while (++_n < 8)
		{
			vertices.push(_quad.vertices[_n]);
			uvtData.push(_quad.uv[_n]);
		}
		
		_n = -1;
		while (++_n < 6)
		{
			_quad.indexes[_n] = _quad.indexes[_n] + _in_index;
			indices.push(_quad.indexes[_n]);
		}
		
		_quad.set_row(this);
		_quad.set_screen(parent);
		_quad.quad_index = _quad_index;
	}
	public function update_sprites(_dx_per_step:Int, _dx_per_side:Int, _dy_per_step:Int,_dy_per_side:Int):Void
	{
		
	
	
		
		var _len:Int = sprites.length;
		var _n:Int = -1;
		while (++_n <_len)
		{
			var _spr:DC_sprite = sprites[_n];
			_spr.update(_dx_per_step, _dy_per_step, _dx_per_side, _dy_per_side);
			
			if(_spr.step==0 && _spr.side==0)
			if (PlayState.mousepressed)
			{
				var _go:DC_GameObject = _spr.check_click_on_sprites();
				if (_go != null)
				{
					trace('CLICKED');
					_go.onClick();
				}
				else
				{
					if (PlayState.mouse_point.x > parent.left(1,0))
					if (PlayState.mouse_point.y > parent.up(1))
					if (PlayState.mouse_point.x < parent.right(1,0))
					if (PlayState.mouse_point.y < parent.down(1))
					{
						LocalGame.state.click_on_step_1();
					}
				
					
				}
			}
		}
	}
}