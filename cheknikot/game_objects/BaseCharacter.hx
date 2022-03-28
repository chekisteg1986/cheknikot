package cheknikot.game_objects;

import cheknikot.ai.BasicAI;
import cheknikot.char_additions.CharBuffBasic;
import cheknikot.char_additions.CharSkillsBasic;
import cheknikot.effects.TextEffect;
import cheknikot.game_objects.GameObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxAnimation;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class BaseCharacter extends GameObject
{
	public static var characters:Array<BaseCharacter> = new Array();
	public static var effects:FlxGroup;

	public var player:Bool = false;
	public var on_ladder:Bool = false;
	public var speed:Int = 100;
	public var left_right:Bool = true;
	public var ai:BasicAI;

	public var attack_sound:Void->Void;
	public var current_hit:GameObject->Void;
	public var skills:Array<CharSkillsBasic> = new Array();
	public var buffs:Array<CharBuffBasic> = new Array();

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);

		isometric = true;
		gravity = true;
		current_hit = hit_melle;
		// legspoint = midpoint;
		legspoint = midpoint;
		attackpoint = midpoint;
	}

	public var anim_walking:FlxAnimation;
	public var anim_b_attack:FlxAnimation;
	public var anim_a_attack:FlxAnimation;
	public var anim_current:FlxAnimation;
	public var anim_stands:FlxAnimation;

	private function set_standart_animations():Void
	{
		if (animation.getByName('walking') == null)
			animation.add('walking', [0], 6, true);
		if (animation.getByName('b_attack') == null)
			animation.add('b_attack', [0], 2, false);
		if (animation.getByName('a_attack') == null)
			animation.add('a_attack', [0], 2, false);
		if (animation.getByName('stands') == null)
			animation.add('stands', [0], 2, false);

		anim_walking = animation.getByName('walking');
		anim_b_attack = animation.getByName('b_attack');
		anim_a_attack = animation.getByName('a_attack');
		anim_stands = animation.getByName('stands');
	}

	public function look_dir(c:FlxSprite):Void
	{
		if (!left_right)
			return;

		if (x < c.x)
		{
			flipX = false;
		}
		else
		{
			flipX = true;
		}
	}

	public function look_dir_p(c:FlxPoint):Void
	{
		if (!left_right)
			return;

		if (x < c.x)
		{
			flipX = false;
		}
		else
		{
			flipX = true;
		}
	}

	override public function add_to_map():Void
	{
		super.add_to_map();
		characters.push(this);
		MyGameObjectLayer.state.active_objects.push(this);
	}

	override public function remove_from_map():Void
	{
		super.remove_from_map();
		characters.remove(this);
		MyGameObjectLayer.state.active_objects.remove(this);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		// FlxG.collide(this, LocalGame.state.walls);
	}

	override public function update_coords():Void
	{
		super.update_coords();
		// legspoint.x = midpoint.x;
		// legspoint.y = midpoint.y;
	}

	public var attack_recharge:Float = 0;
	public var attack_recharge_need:Float = 1;

	public function attack_visual():Void
	{
		new TextEffect(this.x, this.y, 0, 'HIT', 10, FlxColor.RED, effects);
		// AnimationEffect.slash(midpoint, e.midpoint,attack_effect);
	}

	public function attack(e:GameObject):Void
	{
		// animate = true;
		look_dir(e);

		if (anim_a_attack != null)
			anim_current = anim_a_attack;
		if (on_screen)
			if (attack_sound != null)
			{
				attack_sound();
			}

		attack_visual();

		current_hit(e);
	}

	public function shoot(e:GameObject):Void
	{
		var _bullet:BulletBase = new BulletBase(this.attackpoint.x, attackpoint.y, e.attackpoint, this, ai.enemies, null);
	}

	public function hit_melle(e:GameObject):Void
	{
		if (Std.isOfType(e, BaseCharacter))
		{
			// trace('hit char');
			// e.hurt(10);
			// trace('HIT',e.health);
		}
	}

	override public function kill():Void
	{
		super.kill();
		MyGameObjectLayer.state.active_objects.remove(this);
	}
	/*public function attack_gates(bo:BlockObject):Void
		{
			var damage:Int = get_random_damage();
			bo.hurt(damage);
			EmitterEffect.explosion_hit(bo.getMidpoint(), EmitterEffect.rubble_color);
			
			
	}*/
}
