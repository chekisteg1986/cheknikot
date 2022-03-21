package cheknikot.game_objects;

import flixel.FlxG;
import flixel.math.FlxVelocity;
import cheknikot.effects.EmitterEffect;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author ...
 */
class BulletBase extends GameObject
{
	private static var random_int:?Int->?Int->?Null<Array<Int>>->Int = FlxG.random.int;

	public var rotating_90:Bool = false;

	private var speed:Int = 400;

	public var hit_chars:Bool = true;
	public var hit_walls:Bool = true;
	public var hit_point:Bool = false;

	public var over_chars:Bool = false;

	public var auto_aim:Bool = false;

	public var life_timer:Float = -1;
	public var made_by:BaseCharacter = null;
	public var dest_point:FlxPoint = null;

	private var chars_group:Array<BaseCharacter>;

	// private var straight:Bool = true;
	public var emitter:FlxEmitter;

	private var walls_tilemap:FlxTilemap;

	public function new(?X:Float = 0, ?Y:Float = 0, _dest_point:FlxPoint = null, _made_by:BaseCharacter, _chars_group:Array<BaseCharacter>,
			_asset:FlxGraphicAsset)
	{
		super(X, Y);
		if (_asset != null)
		{
			loadGraphic(_asset);
			setSize(2, 2);
		}
		else
			makeGraphic(2, 2);
		centerOffsets(true);

		dest_point = _dest_point;
		made_by = _made_by;

		chars_group = _chars_group;

		if (dest_point != null)
		{
			FlxVelocity.moveTowardsPoint(this, dest_point, speed);

			var v:FlxVector = new FlxVector();
			v.set(dest_point.x - x, dest_point.y - y);
			v.normalize();
			x += v.x * 8;
			y += v.y * 8;
		}

		walls_tilemap = MyGameObjectLayer.state.shooting_walls;
		if (walls_tilemap == null)
			walls_tilemap = MyGameObjectLayer.state.walls;

		// if (emitter != null) MyGameObjectLayer.state.effects.add(emitter);

		MyGameObjectLayer.state.over_sprites.add(this);

		if (dest_point != null)
		{
			var _angle:Float = _made_by.midpoint.angleBetween(_dest_point) - 90;
			this.angle = _angle;
		}

		mass = 0.01;
	}

	public function actions(e:Float):Void
	{
		if (auto_aim)
		{
			var v:FlxVector = new FlxVector();
			v.set(dest_point.x - x, dest_point.y - y);
			v.normalize();
			velocity.add(v.x * 50, v.y * 50);
		}

		if (emitter != null)
		{
			emitter.x = this.x;
			emitter.y = this.y;
		}

		if (hit_walls)
		{
			if (FlxG.collide(this, walls_tilemap, hit))
			{
				// return;
			}
		}

		if (hit_chars)
		{
			var _n:Int = chars_group.length;
			while (--_n >= 0)
				if (FlxG.collide(this, chars_group[_n], hit))
				{
					return;
				}
		}

		if (over_chars)
		{
			var _n:Int = chars_group.length;
			while (--_n >= 0)
				if (this.overlaps(chars_group[_n]))
				{
					on_overlaps(chars_group[_n]);
				}
		}

		if (hit_point)
		{
			if (this.getHitbox().containsPoint(dest_point))
			{
				// trace();
				hit();
				return;
			}
		}

		if (life_timer > -1)
		{
			life_timer -= e;
			// trace('Life timer ', life_timer);
			if (life_timer < 0)
			{
				hit();
				this.remove_from_map();
				return;
			}
		}
		check_bounds();
	}

	private function check_bounds():Void
	{
		if (x > walls_tilemap.width || x < 0 || y > walls_tilemap.height || y < 0)
		{
			remove_from_map();
		}
	}

	public function on_overlaps(_c:BaseCharacter):Void {}

	override public function update(elapsed:Float):Void
	{
		if (!MyGameObjectLayer.state.pause)
			actions(elapsed);

		if (rotating_90)
		{
			this.angle += 90;
		}
		// actions();
		var last_p_dx:Int = 0;
		var last_p_dy:Int = 0;

		if (hit_point)
		{
			last_p_dx = FlxMath.numericComparison(this.x, dest_point.x);
			last_p_dy = FlxMath.numericComparison(this.y, dest_point.y);
		}

		super.update(elapsed);

		if (hit_point)
		{
			if (last_p_dx != FlxMath.numericComparison(this.x, dest_point.x))
			{
				this.x = dest_point.x;
				this.y = dest_point.y;
				hit();
			}
			else if (last_p_dy != FlxMath.numericComparison(this.y, dest_point.y))
			{
				this.x = dest_point.x;
				this.y = dest_point.y;

				hit();
			}
			else
			{
				trace('fireball fly');
			}
		}
	}

	override public function remove_from_map():Void
	{
		MyGameObjectLayer.state.over_sprites.remove(this, true);
		if (emitter != null)
		{
			MyGameObjectLayer.state.effects.remove(emitter, true);
		}
	}

	public function current_hit_effect(obj:Dynamic = null):Void {}

	public function hit(THIS:BulletBase = null, obj:FlxBasic = null):Void
	{
		if (obj == made_by)
			return;

		if (Std.isOfType(obj, BaseCharacter))
			made_by.hit_melle(cast(obj, BaseCharacter));

		remove_from_map();
	}
}
