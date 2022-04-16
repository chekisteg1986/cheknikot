package cheknikot.dungeoncrawler;

import cheknikot.AF;
import cheknikot.dungeoncrawler.DC_GameObject;
import cheknikot.effects.EmitterEffect;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class DC_Bullet extends DC_GameObject
{
	override public function new()
	{
		super();
		speed = 4;
		name = ['bullet'];
		can_collide = false;
		attitude_dy = 150;
		object_radius = 0.02;
		// create_radius_sprites();
		/*
			visual_spr.loadGraphic(AssetPaths.bullet_1__png, true, 40, 40);
			visual_spr.animation.add('1', [0, 1, 2]);
			visual_spr.animation.play('1');
		 */
	}

	public var collide_array:Array<Dynamic>;

	override function update(_elapsed:Float)
	{
		super.update(_elapsed);

		var _hit_wall:Bool = !step_forward(-1, _elapsed * speed);

		if (collide_array == null)
		{
			collide_array = DC_GameObject.objects;
		}
		var _go:DC_GameObject = collide_with(collide_array);

		if (_go != null)
			if (ignore_go != _go)
			{
				collided_with(_go);
				trace('Bullet Collided', _go.name);
			}
		if (_hit_wall)
		{
			// trace('hit wall', tile_x, tile_dx, tile_y, tile_dy);
			remove_from_map();
		}
	}

	public function collided_with(_go:DC_GameObject):Void
	{
		remove_from_map();
	}

	public var ignore_go:DC_GameObject = null;

	/*
		public function ricochet_mirror(_m:Mirrors):Void
		{
			trace('ricochet mirror', nesw_facing, _m.rotated);
			ignore_go = _m;

			if (_m.rotated)
			{
				// ld-ur
				if (nesw_facing == 0)
					nesw_facing++
				else if (nesw_facing == 1)
					nesw_facing--
				else if (nesw_facing == 2)
					nesw_facing++
				else if (nesw_facing == 3)
					nesw_facing--;
			}
			else
			{
				// lu-dr
				if (nesw_facing == 0)
					nesw_facing--
				else if (nesw_facing == 1)
					nesw_facing++
				else if (nesw_facing == 2)
					nesw_facing--
				else if (nesw_facing == 3)
					nesw_facing++;
			}
			nesw_facing = AF.NESW_border(nesw_facing);
			trace('new face', nesw_facing);
	}*/
	public function ricochet(_c:DC_GameObject):Void
	{
		ignore_go = _c;
		var _p:FlxPoint = _c.position;

		trace('RICOSHET');

		if (nesw_facing == 0)
		{
			if (position.x < _p.x)
				nesw_facing--;
			else
				nesw_facing++;
		}
		else if (nesw_facing == 1)
		{
			if (position.y < _p.y)
				nesw_facing--;
			else
				nesw_facing++;
			// tile_dx = _c.tile_dx - 0.1;
		}
		else if (nesw_facing == 2)
		{
			if (position.x > _p.x)
				nesw_facing--;
			else
				nesw_facing++;
		}
		else if (nesw_facing == 3)
		{
			if (position.y > _p.y)
				nesw_facing--;
			else
				nesw_facing++;
		}
		nesw_facing = AF.NESW_border(nesw_facing);
	}
}
