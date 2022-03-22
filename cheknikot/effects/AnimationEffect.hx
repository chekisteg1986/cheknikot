package cheknikot.effects;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.math.FlxVector;

import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

import flixel.FlxG;


import flixel.math.FlxVelocity;

import locationmap.game_objects.GameObject;
/**
 * ...
 * @author ...
 */
class AnimationEffect extends FlxSprite
{
	private static var random_int:?Int -> ?Int -> ?Null<Array<Int>> -> Int = FlxG.random.int;
	public var rotation_90:Bool = false;
	public var scaling:Float = 0;
	
	public var emitter:FlxEmitter;
	public var parent:FlxGroup;
	
	
	public static function shoot(from:FlxPoint, to:FlxPoint):Void
	{
		var eff:AnimationEffect = new AnimationEffect(from.x, from.y, EffectTypes.shoot);
		GameObjectLayer.effects.add(eff);
		
		eff.angle = from.angleBetween(to) + 90;	
		
		var _dx:Float =  to.x - from.x;
		var _dy:Float =  to.y - from.y;
		
		//var p:FlxPoint = new FlxPoint(_dx, _dy);
		var  abs_x:Float = Math.abs(_dx);
		var  abs_y:Float = Math.abs(_dy);
		var abs_max:Float = 0;
		
		if(_dx != 0 || _dy != 0)
		{
			abs_max = abs_x;
			if (abs_y > abs_max) abs_max = abs_y;
			_dy = _dy / abs_max;
			_dx = _dx / abs_max;
		}
		
		
		FlxVelocity.moveTowardsPoint(eff, to, 200);
		//eff.velocity.set(_dx * 20, _dy * 20);
		eff.x +=  _dx*8;
		eff.y += _dy * 8;
		eff.x -= eff.width/2;
		eff.y -= eff.height / 2;
		
		
	}
	public static function slash(from:FlxPoint,to:FlxPoint,type:Int):Void
	{
		var eff:AnimationEffect = new AnimationEffect(from.x, from.y, type);
		eff.x -= eff.width/2;
		eff.y -= eff.height/2;
		eff.angle = from.angleBetween(to)  + 90;		
		FlxVelocity.moveTowardsPoint(eff, to, 200);
		GameObjectLayer.effects.add(eff);
		
	}
	
	public static function arrow(from:FlxPoint, to:FlxPoint, type:Int):Void
	{
		var eff:AnimationEffect = new AnimationEffect(from.x, from.y, type);
		eff.x -= eff.width / 2;
		eff.y -= eff.height / 2;
		
		eff.angle = from.angleBetween(to) + 90;
		
		FlxVelocity.moveTowardsPoint(eff, to, 500);
		
		GameObjectLayer.effects.add(eff);
		if (eff.emitter != null)
		{
			
		GameObjectLayer.effects.add(eff.emitter);
		}
	}

	public var follow:FlxSprite = null;
	public function new(?X:Float = 0, ?Y:Float = 0, type:Int = 0, one_frame:Bool = false, reverse:Bool = false ) 
	{
		super(X, Y);
		parent = GameObjectLayer.effects;
		switch(type)
		{
			case 1:
				loadGraphic(AssetPaths.slash__png, true, 16, 16);				
				animation.add("goes", [0, 1, 2, 3], 60, false);
				animation.play("goes");
				
					
				
			case 2:
				loadGraphic(AssetPaths.thrust__png, true, 16, 16);				
				animation.add("goes", [0, 1, 2, 3], 60, false);
				animation.play("goes");
			case 3:
				loadGraphic(AssetPaths.bite__png, true, 16, 16);				
				animation.add("goes", [0, 1, 2, 3], 60, false);
				animation.play("goes");	
			case 4:
				loadGraphic(AssetPaths.thrust__png, true, 16, 16);				
				animation.add("goes", [0, 1, 2, 3], 30, false);
				animation.play("goes");
			case 5:
				loadGraphic(AssetPaths.black_lightning__png, true, 8, 8);				
				animation.add("goes", [0,1,2,3,4,5,6],60, false);
				animation.play("goes");
			case 6:
				loadGraphic(AssetPaths.lightning_2__png, true, 8, 8);				
				animation.add("goes", [random_int(0,8)],60, false);
				animation.play("goes");
			case 7:
				loadGraphic(AssetPaths.cross__png, true, 5, 5);				
				animation.add("goes", [0,1,2],60, false);
				animation.play("goes");
				
			case 8:
				loadGraphic(AssetPaths.biomass_armour__png, true, 16, 16);
				animation.add('goes', [0, 0, 0], 1);
				animation.play('goes');
				FlxTween.tween(this, {alpha:0}, 1);
				scale.set(1.2, 1.2);
				
			case 9:
				loadGraphic(AssetPaths.spidercurse__png, true, 30, 30);
				animation.add("goes", [0,1,2,3,4,5,6], 30, false);
				animation.play("goes");
				
			case 10:
				loadGraphic(AssetPaths.mystic_strike__png, true, 16, 16);				
				animation.add("goes", [0,1,2,3,4], 20, false);
				animation.play("goes");
				
			case 11:
				loadGraphic(AssetPaths.deffence_ward__png, true, 16, 16);
				
				animation.add("goes", [0,1,2,3,4], 40, false);
				animation.play("goes");
				
			case 12:
				loadGraphic(AssetPaths.curse_weakness__png, true, 16, 16);
				
				animation.add("goes", [0,1,2,3,4,5],30, false);
				animation.play("goes");
			case 13:
				loadGraphic(AssetPaths.reflection__png, true, 16, 16);
				
				animation.add("goes", [0,1,2,3,4], 40, false);
				animation.play("goes");
			
			case 14:
				loadGraphic(AssetPaths.web__png, true, 16, 16);
				FlxTween.tween(this, { alpha: 0}, .33);
				animation.add("goes", [0,0,0,0,0,0], 40, false);
				animation.play("goes");
				
			case 15:
				loadGraphic(AssetPaths.talking__png,true, 20, 14);
				animation.add("goes", [0], 40, false);
				animation.play("goes");
			case 16:
				loadGraphic(AssetPaths.bloodsplash__png, true, 4, 4);
				if (one_frame)
				{
					animation.add("goes", [random_int(0,5)], 40, false);
				}
				else
				{
					animation.add("goes", [0, 1, 2, 3, 4, 5], 40, false);
				}
				animation.play("goes");
				
			
				
				
			case 17:
				loadGraphic(AssetPaths.levelup__png, true, 23, 5);
				FlxTween.tween(this, { alpha: 0, y: y - 16 }, .33);
				animation.add("goes", [0, 0, 0, 0, 0, 0], 40, false);
				animation.play("goes");
			case 18:
				loadGraphic(AssetPaths.cracking__png, true, 16, 16);
				animation.add("goes", [0, 1, 2, 3], 10, false);
				animation.play("goes");
			
			
			case 19:
				loadGraphic(AssetPaths.shoot__png, true, 16, 16);				
				animation.add("goes", [0, 1, 2, 3], 60, false);
				animation.play("goes");
				
	
			case 20:
				loadGraphic(AssetPaths.smash__png, true, 16, 16);				
				animation.add("goes", [0, 1, 2, 3], 60, false);
				animation.play("goes");
			
				
			case 21:
				loadGraphic(AssetPaths.flame_hit__png, true, 16, 16);				
				animation.add("goes", [0, 1, 2, 3], 60, false);
				animation.play("goes");
			case 22:
				loadGraphic(AssetPaths.arrow__png, true, 8, 8);				
				animation.add("goes", [0, 0, 0, 0], 40, false);
				animation.play("goes");
			case 23:
				loadGraphic(AssetPaths.stone_1__png, true, 2, 2);
				animation.add("goes", [0, 0, 0, 0], 40, false);
				animation.play("goes");
			case 24:
				loadGraphic(AssetPaths.poison_arrow__png, false, 8, 8);				
				animation.add("goes", [0, 0, 0, 0], 40, false);
				animation.play("goes");
			case 25:
				loadGraphic(AssetPaths.lightning__png, true, 16, 16);				
				animation.add("goes", [random_int(0,8)],60, false);
				animation.play("goes");
			case 26:
				loadGraphic(AssetPaths.black_lightning__png, true, 8, 8);				
				animation.add("goes", [random_int(0,8)],60, false);
				animation.play("goes");
			
			case 27:
				loadGraphic(AssetPaths.lightning_2__png, true, 8, 8);				
				animation.add("goes", [0,1,2,3,4,5,6],60, false);
				animation.play("goes");
			
			case 28:
				loadGraphic(AssetPaths.full_healing__png, true, 16, 16);
				animation.add("goes", [0, 1, 2], 20, false);
				//scale.set(2, 2);
				animation.play("goes");
			case 29:
				loadGraphic(AssetPaths.squad_healing__png, true, 6, 6);
				animation.add("goes", [0, 1, 2], 20, false);
				
				//scale.set(2, 2);
				
				animation.play("goes");
				
			case 30:
				loadGraphic(AssetPaths.lightning__png, true, 16, 16);
				animation.add("goes", [0, 1, 2, 3, 4, 5, 6, 7, 8], 60, false);
				//scale.set(2, 2);
				animation.play("goes");
			case 31:
				loadGraphic(AssetPaths.lightning__png, true, 16, 16);				
				animation.add("goes", [8,7,6,5,4,3,2,1,0],60, false);
				animation.play("goes");
				
				
		
			
			case 32:
				loadGraphic(AssetPaths.fireball__png, true, 5, 5);
				animation.add("goes", [0,0,0,0], 40, false);
				animation.play("goes");
				emitter = EmitterEffect.get_fire_emitter();
				
			case 33:
				loadGraphic(AssetPaths.explosion__png, true, 20, 20);
				animation.add("goes", [0, 1, 2,3,4], 30, false);
				animation.play("goes");
				
		}
		
		
	}
	override public function update(elapsed:Float):Void 
	{
					
			
			if (animation.finished)
			{
				parent.remove(this,true);
				if (emitter != null)
				{
					parent.remove(emitter,true);
					emitter.destroy();
				}
				this.destroy();
				super.destroy();
				//trace(PlayState.effects.length);
			}
			else
			{
				if (rotation_90)
				{
					angle+= 90;
				}
				if (scaling != 0)
				{
					scale.x += scaling;
					scale.y += scaling;
				}
				
				if (follow != null)
				{
					this.x = follow.x;
					this.y = follow.y;
				}
				
				if (emitter != null)
				{
					emitter.x = this.x;
					emitter.y = this.y;
				}
				super.update(elapsed);
			}
		
		}
	
}