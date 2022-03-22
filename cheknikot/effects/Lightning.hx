package cheknikot.effects;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.FlxG;
import locationmap.game_objects.Character;
import locationmap.game_objects.GameObject;
/**
 * ...
 * @author ...
 */
class Lightning extends FlxGroup
{
private static var random_int:?Int -> ?Int -> ?Null<Array<Int>> -> Int = FlxG.random.int;	

	public var targets:Array<Character> = new Array();
	private var diapasone:Float = 5 * 16;
	private var source:FlxSprite;
	
	private var look_in:FlxTypedGroup<Character>;
	private var current_target:GameObject;
	private var visual:Int = 0;

	private var targets_count:Int;
	private var strength:Int;
	private var max_stenght:Int;
	public function new(_source:Character, _target_1:Character, _look_in:FlxTypedGroup<Character>, _visual:Int, _str:Int = 1 ):Void
	{
		super();
		//trace('LIGHTNING BOLT!');
		max_stenght = strength = _str;
		targets_count = 1+ strength;
		look_in = _look_in;
		source = _source;
		visual = _visual;
		targets.push(_source);
		targets.push(_target_1);
		current_target = _target_1;
		
		if(look_in != null)
			find_new_target();
		
		trace('targets:', targets.length);
		GameObjectLayer.effects.add(this);
	}
	
	private function find_new_target():Void
	{
		var c:Character;
		if (targets_count == 0) return;
		
		for (c in look_in)
		{
			if (!c.alive) continue;
			
			if(targets.indexOf(c) == -1)
			if ( FlxMath.distanceBetween(c, current_target) < diapasone)
			if	( GameObjectLayer.walls.ray(c.midpoint,current_target.midpoint))
			{
				
				targets.push(c);
				targets_count--;
				
				current_target = c;
				diapasone *= (0.5 + strength * 0.1);
				
				if(diapasone>1)
					find_new_target();
				
				break;
			}
		}
		
	}
	
	private var current_sprite_n:Int = 0;
	private var lifetime:Float = 0.3;
	override public function update(elapsed:Float):Void
	{
		//trace('update',elapsed);
		if (GameObjectLayer.game_goes)
		{
			lifetime-=elapsed;
			if (lifetime <= 0)
			{
				GameObjectLayer.effects.remove(this,true);
				this.kill();
				this.destroy();
				return;
			}
			else
			{
				//смена кадров спрайтов, смена позиций
				current_sprite_n = 0;
				var len:Int = targets.length;
				var n:Int = 0;
				while (++n < len)
				{
					//trace('draw line',targets[n - 1].x,targets[n - 1].y,'to',targets[n].x,targets[n].y);
					draw_line(targets[n - 1], targets[n]);
				}
			
			}
			
		}
		super.update(elapsed);
	}
	private function draw_line(_from:Character,_to:Character):Void
	{
				
		var current_x:Float = _from.midpoint.x;
		var current_y:Float = _from.midpoint.y;
		
		//var dx:Float=_to.midpoint.x - _from.x;
		//var dy:Float = _to.midpoint.y - _from.y;
		var dx:Float=_to.midpoint.x - current_x;
		var dy:Float = _to.midpoint.y - current_y;
		
		
		var nx:Int = Math.floor(dx / 8);
		if (nx < 0) 
		{
			nx = -nx;
			dx = -8;
		}
		else
		{
			dx = 8;
		}
		
		var ny:Int = Math.floor(dy / 8);
		if (ny < 0) 
		{
			ny = -ny;
			dy = -8;
		}
		else
		{
			dy = 8;
		}
				
		var dir:Int;
		var last_dir:Int = 2;
		var sprite:AnimationEffect;
		while(ny != 0 || nx!=0)
		{
			if (ny != 0)
			{
				if (nx != 0)
				{
					dir = random_int(0, 2);
					if (dir == 0)
					{
						//horizont
						current_x += dx;
						nx--;
						
					}
					else if (dir == 1)
					{
						//vertic
						current_y += dy;
						ny--;
					}
					else if (dir == 2)
					{
						//diag
						current_x += dx;
						current_y += dy;
						nx--;
						ny--;
					}
				}
				else
				{
					//vertic
					dir = 1;
					current_y += dy;
					ny--;
				}
			}
			else
			{
				//horizont
				dir = 0;
				current_x += dx;
				nx--;
			}
			//create sprite
			
			sprite = new AnimationEffect(current_x, current_y, visual,true);
			add(sprite);
			
			
			
		}
		
		
	}
	
	
	
}