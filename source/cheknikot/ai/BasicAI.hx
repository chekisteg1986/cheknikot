package cheknikot.ai;
//import flash.events.GameInputEvent;
import cheknikot.pathfinding.PathMapBase;
import flixel.tile.FlxTilemap;

import cheknikot.pathfinding.topdown.PathfindMemory;
import cheknikot.pathfinding.WaySection;
import flixel.FlxG;

import cheknikot.game_objects.BaseCharacter;
import flixel.math.FlxPoint;
//import flixel.math.FlxVector;
//import flixel.math.FlxVelocity;
//import flixel.math.FlxMath;


//import flixel.group.FlxGroup.FlxTypedGroup;

//import pathfinding.*;
//import flixel.math.FlxAngle;
import flixel.animation.FlxAnimation;
import cheknikot.game_objects.GameObject;
/**
 * ...
 * @author ...
 */
class BasicAI 
{

	
	
	public var midpoint:FlxPoint;
	public var legspoint:FlxPoint;
	public var current_target:GameObject = null;
	public var current_action:Void->Void = null;
	public var decision_timer:Float = 0;
	
	public var cur_can_chase:GameObject -> Bool;
	public var cur_stands:Void->Void;
	public var cur_chase:Void->Void;
	public var cur_attack:Void->Void;
	public var cur_go_to_position:Void->Void;
	public var cur_walk_to_point:FlxPoint -> Void;
	public var cur_step:FlxPoint -> ?Int -> Void;
	public var position:FlxPoint = null;
	
	
	public var vision_radius:Float = 300;
	public var waiting_time:Float = 1;
	public var attached_to:BaseCharacter;
	public var hold_position:Bool = false;
	
	//public var ws_path:Array<WaySection>;
	//public var path_memory:PathfindMemory;
	
	public function new(c:BaseCharacter) 
	{
		attached_to	= c;
		
		cur_can_chase = can_chase;
		cur_stands = stands;
		cur_chase = chase;
		cur_attack = attack;
		cur_go_to_position = go_to_position;
		cur_walk_to_point = walk_to_point;
		cur_step = step_strait;		
		current_action = cur_stands;
		midpoint = c.midpoint;
		legspoint = c.legspoint;
		//velocity = c.velocity;
		
		
		
	}
	public function connect_vars():Void
	{
		
		anim_a_attack = attached_to.anim_a_attack;
		anim_b_attack = attached_to.anim_b_attack;
		anim_walking = attached_to.anim_walking;
		anim_stands = attached_to.anim_stands;
	}
	
	public function reset(wait:Bool = true ):Void
	{
		//if (attached_to.player) trace('reset(wait:'+wait+')');
		
		current_target = null;
		current_action = stands;
		path_memory = null;
		AF.clear_array(section_path);
		
		
		
		if (wait)
		{
			decision_timer = waiting_time;
		}
		else
		{
			decision_timer  = 0;	
		}
	}
	
	public var enemies:Array<BaseCharacter>;
	public function stands():Void
	{
		
		if (decision_timer > 0)
		{
			decision_timer -= FlxG.elapsed;
			return;
		}
		
		if (current_target == null)
		{
			current_target_dist = 0;
			if (enemies != null && enemies.length>0)
			{
				look_for_target();
			}
		}
		
		if (current_target == null)
		if (position != null)
		{
			cur_go_to_position();
		}
		
		if (current_target != null) current_action = cur_chase;
		
		
		if (position == null && current_target == null) reset(true);
		
	}
	
	
	public static var position_dx:Int = 15;
	public static var position_dy:Int = 15;
	
	
	public function stands_on_position(_p:FlxPoint):Bool
	{
		if (_p == null) return true;
		if (this.legspoint.distanceTo(_p) <= 5) return true;
		return false;
	}
	public function go_to_position():Void
	{
		//if (attached_to.player) trace('go_to_position()');
		
		if (!stands_on_position(position))
		{
			walk_to_point(position);
		}
		else
		{
			//position = null;
			attached_to.anim_current = anim_stands;
			slowdown();
		}
	}
	public function slowdown():Void
	{
		attached_to.velocity.x = attached_to.velocity.x / 3;
		attached_to.velocity.y = attached_to.velocity.y / 3;
		
	}
	
	
	/*public function walk_to_point(_p:FlxPoint):Void
	{
		
		if (ws_path == null)
		{
			path_memory = PathMapSS.state.get_trail_to(attached_to.legspoint, _p, path_memory );
			if (path_memory == null)
			{
				//NO PASS
			}
			else
			{
				if (path_memory.finded)
				{
					ws_path = path_memory.section_path;
					path_memory = null;
				}
			}
		}
		
		
	}*/
	
	
	public var target_ws:WaySection = null;
	public var last_target_ws:WaySection = null;
	public var section_path:Array<WaySection> = new Array();
	public var last_ws:WaySection = null;
	public var path_memory:PathfindMemory = null;
	private function walk_to_point(p:FlxPoint):Void
	{
		
		attached_to.anim_current = anim_walking;
		
		var current_ws:WaySection = attached_to.get_current_ws();// PathMap.way_zones[attached_to.tile_index];
		
		if (current_ws == null)
		{
			current_ws = last_ws;
		}
		
		if (current_ws == null)
		{
			trace('current ws null',attack_radius);
			cur_step(p);
			return;
		}
		
		if (false && !current_ws.rect.containsPoint(legspoint))
		{
			//если не уж точно дошел до новой вейсекции, считаем что он стоит на прошлой
			if(last_ws != null)
			{
				current_ws = last_ws;
			}
		}
		 
		//запоминаем предидущую вейсекцию
		last_ws = current_ws;
		
		
		var new_target_ws:WaySection = PathMapBase.state.get_way_zone(p);
		
		//смотрим целевую вейсекцию
		if (new_target_ws == null  || current_ws == null)
		{
			trace('Error, walking strait', attack_radius, new_target_ws, Math.floor(p.x / 40), Math.floor(p.y / 40), current_ws);
			block_object_dx = -block_object_dx;
			cur_step(p);
			reset(true);
			return;
		}		
		
		
		if ( current_ws == new_target_ws || current_ws.connected_with.indexOf(new_target_ws) != -1)
		{
			//если стоим на нужной вейсекции, либо на соседней, то идем напрямую
			if ( stands_on_position(p) ) 
			{
				reset(true);
				return;
			}
			
			//trace('walking strait',this.attack_radius, current_ws.number, new_target_ws.number);
			
			cur_step(p);
			
			AF.clear_array(section_path);
			attached_to.look_dir_p(p);
			
			return;
		}
		else
		{
			
			//find the way to waysection
			//if (attached_to.player) trace('finding way to waysection',current_ws.number,new_target_ws.number);
			
			if (section_path.length == 0 || target_ws != new_target_ws)
			{
				
				path_memory = PathMapBase.state.get_trail_to(legspoint, p, path_memory);
				
				if (path_memory == null) 
				{
					//attached_to.random_step();
					//trace('cant find path', current_ws.number, target_ws.number);
					reset(true);
					return;
				}
				
				if (path_memory.finded)
				{
					trace('path_memory.finded');
					
					section_path = path_memory.section_path;
					path_memory = null;
				}
				else
				{
					
				}
				
				target_ws = new_target_ws;
			}
			else
			{
				//var ws:WaySection = null;				
				//if (attached_to.player) trace('have path, walking on ');
				var ws:WaySection = section_path[0];
				
				if (current_ws == ws)
				{
					//trace('next ws');
					section_path.splice(0, 1);
				}
				else
				{
					if (current_ws.connected_with.indexOf(ws) == -1)
					{

						trace('not that section',current_ws.number,ws.number);
						AF.clear_array(section_path);
						return;
					}
					else
					{
						//if(attached_to == LocalGame.state.player) trace('STEP');
						cur_step(ws.midpoint);
						
						attached_to.look_dir_p(ws.midpoint);
					}
				}
			
			}
		}
		
	}
	
	
	public function step_strait(_p:FlxPoint, d:Int = 10):Void
	{
		
		var angle:Float = _p.angleBetween(legspoint) + 90;
		
		attached_to.velocity.set(attached_to.speed, 0);
		attached_to.velocity.rotate(FlxPoint.weak(), angle);
		if (attached_to.on_ladder == false)
		{
			//attached_to.velocity.y = 0;
		}
		
	}

	public function step_wasd(_p:FlxPoint,_d:Int = 10):Void
	{
		
		
		if (legspoint.x > (_p.x+_d))
		{
			attached_to.velocity.x =-attached_to.speed;
			//if(attached_to == LocalGame.state.player)trace('left');
			//attached_to.on_ladder = false;
			return;
		}
		if (legspoint.x < (_p.x-_d))
		{
			attached_to.velocity.x = attached_to.speed;
			//if(attached_to == LocalGame.state.player)trace('right');
			//attached_to.on_ladder = false;
			return;
		}
		
		if (legspoint.y > (_p.y+1))
		{
			attached_to.velocity.y =-attached_to.speed;
			attached_to.velocity.x = 0;
			//trace('up');
			//attached_to.on_ladder = true;
			return;
		}
		else
		if (legspoint.y < (_p.y - 1))
		{
			attached_to.velocity.y = attached_to.speed;
			attached_to.velocity.x = 0;
			//trace('down');
			//attached_to.on_ladder = true;
			return;
		}
		else
		{
			var dy:Float = attached_to.y - legspoint.y;
			legspoint.y = _p.y;
			attached_to.y = legspoint.y + dy;
			//
		}
		
		if (_d == 0) return;
		
		step_wasd(_p, Math.floor(_d / 2));
	}

	
	
	public function choose_random_enemy():Void
	{
		var _e:BaseCharacter = FlxG.random.getObject(enemies);
		current_target = _e;
	}
	
	public function look_for_target():Void
	{
		//if (attached_to.player) trace('look_for_target');
		
		
		var _n:Int = enemies.length;
		while (--_n >= 0)
		{
			var go:GameObject = enemies[_n];
			if (cur_can_chase(go)) 
			{
				return;
			}
		}
	}
	
	
	public static var check_attack_tilemap:FlxTilemap;
	public function can_see(e:GameObject):Bool
	{
		if(e.midpoint.distanceTo(midpoint) <= vision_radius)
		if (check_attack_tilemap.ray(this.midpoint, e.midpoint)) return true;
		return false;
	}
	
	
	public var current_target_dist:Float = 0;
	public function check_vision2(e:GameObject):Bool
	{
		
		if (e == current_target) return false;
		var dx:Float = this.midpoint.x - e.midpoint.x;
		if (dx > current_target_dist) return false;
		if (dx < -current_target_dist) return false;
		var dy:Float = this.midpoint.y - e.midpoint.y;
		if (dy > current_target_dist) return false;
		if (dy < -current_target_dist) return false;
		var dist:Float = Math.sqrt(dx * dx + dy * dy);
		if (dist > current_target_dist) return false;
		
		
		if(can_see(e))
		{
				current_target = e;
				current_target_dist = dist;
				return true;
		}
		return false;	
	}
	
	
	public var position_range:Float = 10;
	
	public function in_position_range(go:GameObject):Bool
	{
		if (position.distanceTo(go.midpoint) < (attack_radius + position_range)) return true;
		return false;
	}
	
	public function can_chase(go:GameObject):Bool
	{
		//simple function. chasing, when enemy is close
		if (hold_position)
		if(position != null)
		{
			if (!in_position_range(go)) return false;
		}
		
		if (can_see(go))
		{
			current_target = go;
			current_action = cur_chase;
			if (attached_to.player) trace('TARGET FOUND');
			return true;
		}
		return false;
	}
	
	public function can_attack(_e:GameObject):Bool
	{
		if (this.midpoint.distanceTo(current_target.midpoint) > (attack_radius+_e.size)) return false;
	
		if (attack_radius <= 50) return true;
		 
		return can_see(_e);
	}
	
	public var attack_radius:Float = 40;
	public function chase():Void
	{
		if (attached_to.player) trace('chase()');
		//trace('chase()');
		
		if (!current_target.alive)
		{
			reset(false);
			return;
		}
		
		if (hold_position)
		if (position != null)
		if ( !in_position_range(current_target))
		{
			reset(false);
			return;
		}
		
		if (can_attack(current_target))
		{
			//attacking
			current_action = cur_attack;
		}
		else
		{
			if (current_target.block_object)
			{
				walk_to_point(FlxPoint.weak(current_target.legspoint.x + block_object_dx, current_target.legspoint.y));
			}
			else walk_to_point(current_target.legspoint);
		}
	}
	
	public var block_object_dx:Int = 40;
	
	public var anim_walking:FlxAnimation;
	public var anim_stands:FlxAnimation;
	public var anim_b_attack:FlxAnimation;
	public var anim_a_attack:FlxAnimation;
	
	
	public function attack():Void
	{
		//trace('attack');
		
		current_action = b_attack;
		attached_to.anim_current = anim_b_attack;
		//anim_a_attack.
		
	}
	public function b_attack():Void
	{
		//anim_b_attack.play();
		if (anim_b_attack.finished)
		{
			hit();
			current_action = a_attack;
			attached_to.anim_current = anim_a_attack;
		}
	}
	public function a_attack():Void
	{
		//anim_a_attack.play();
		if (anim_a_attack.finished)
		{
			current_action = stands;
			attached_to.anim_current = anim_walking;
		}
	}
	public function hit():Void
	{
		attached_to.attack(current_target);
	}
	
	
	//public var hold_position:Bool = false;
	public function hit_by(_e:BaseCharacter):Void
	{
		if (current_target == null)
		{
			current_target = _e;
			current_action = cur_chase;
		}
	}
	
}