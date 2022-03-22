package cheknikot.effects;

import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxSprite;

import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class EmitterEffect extends FlxEmitter 
{
	
	private static var random_int:?Int -> ?Int -> ?Null<Array<Int>> -> Int = FlxG.random.int;
	
	
	public static var magic_color:Array<FlxColor> = [FlxColor.WHITE, FlxColor.PURPLE];
	public static var shoot_color:Array<FlxColor> = [FlxColor.WHITE, FlxColor.GRAY];
	public static var rubble_color:Array<FlxColor> = [FlxColor.BLACK, FlxColor.GRAY];
	public static var fire_color:Array<FlxColor> = [FlxColor.RED, FlxColor.YELLOW];
	public static var ice_color:Array<FlxColor> = [FlxColor.BLUE, FlxColor.WHITE];
	public static var poison_color:Array<FlxColor> = [FlxColor.GREEN, FlxColor.BROWN];
	public static var holy_color:Array<FlxColor> = [FlxColor.WHITE, FlxColor.YELLOW];
	public static var green_color:Array<FlxColor> = [FlxColor.GREEN, FlxColor.YELLOW];
	public static var red_color:Array<FlxColor> = [FlxColor.RED, FlxColor.RED];
	
	public static function get_fire_emitter(_c:Array<FlxColor> = null,_s:Int = 2, _sqare_w:Int=5,_sqare_h:Int = 5,_particles:Int = 10 ):FlxEmitter
	{
		if (_c == null) _c = fire_color
		;
		var emitter:FlxEmitter = new FlxEmitter();
				emitter.launchMode = FlxEmitterMode.SQUARE;	
				emitter.setSize(_sqare_w, _sqare_h);
				emitter.lifespan.set(0.1,0.2);
				
				emitter.velocity.set( -100, -100, 100, 100);
				emitter.color.set(_c[0], _c[1]);
				
				while(--_particles>=0)
				{
							
					var p:FlxParticle = new FlxParticle();
					
					p.makeGraphic(_s, _s);
					emitter.add(p);
				}
						
				emitter.start(false, 0.02);
				
			return emitter;
	}
	
	public static function shoot(_start_point:FlxPoint, _direction:FlxVector, _particles:Int = 10):Void
	{
		trace('SHOOOT', _direction.x,_direction.y);
		_direction.normalize();
		_direction = _direction.scale(300);
		trace(_direction.x,_direction.y);
		var emitter:EmitterEffect = new EmitterEffect(_start_point.x, _start_point.y,_particles);
		
		emitter.launchMode = FlxEmitterMode.SQUARE;
		emitter.setSize(1, 1);
		emitter.lifespan.set(0.3, 0.4);
		emitter.velocity.set( _direction.x * 0.5, _direction.y * 0.5, _direction.x * 1.5, _direction.y * 1.5, 0, 0, 0, 0);
		emitter.alpha.set(1, 1, 0, 0);
		//emitter.acceleration.set(-_direction.x*3, -500);
		
		while(--_particles>=0)
		{
					
			var p:FlxParticle = new FlxParticle();
			p.makeGraphic(2, 2);
			
			emitter.add(p);
		}
				
		emitter.start(true);
		//emitter.explode();
	}
	
	public static function particle_line(p1:FlxPoint, p2:FlxPoint, color:Array<FlxColor>,_step:Int = 2,_lifetime:Float = 1):Void
	{
		
		var dx:Float = p2.x - p1.x;
		var dy:Float = p2.y - p1.y;
		var iter:Int = Math.floor(Math.max(Math.abs(dx), Math.abs(dy)) / _step);
		dx = dx / iter;
		dy = dy / iter;
		//trace('PARTICLE LINE iter',iter,dx,dy);
		while (--iter >= 0)
		{
			
			var p:LoneParticle = new LoneParticle(p1.x + dx * iter, p1.y + dy * iter,FlxG.random.getObject(color), _lifetime);
			p.velocity.set(random_int( -100, 100), random_int( -100, 100));
			
		}
		
	}
	
	public static function particle_bullet(p1:FlxPoint, p2:FlxPoint, color:Array<FlxColor>):Void
	{
		var emitter:EmitterEffect = new EmitterEffect(p1.x, p1.y);	
		emitter.launchMode = FlxEmitterMode.SQUARE;	
		emitter.setSize(10, 10);
		emitter.lifespan.set(0.3, 0.4);
		emitter.velocity.set( -100, -120, 100, -50);
		emitter.acceleration.set(0, 200);		
		emitter.alpha.set(1, 1, 0, 0);
		//emitter.acceleration.set(-_direction.x*3, -500);
		
		for ( n in 1...10)	
		{
					
			var p:FlxParticle = new FlxParticle();
			p.makeGraphic(2, 2,FlxG.random.getObject(color));
			
			emitter.add(p);
		}
				
		emitter.start(true);
		
	}
	
	public static function explosion_hit(_start_point:FlxPoint, color:Array<FlxColor>):Void
	{
		var emitter:EmitterEffect = new EmitterEffect(_start_point.x-5, _start_point.y-5);
		
		emitter.launchMode = FlxEmitterMode.SQUARE;
		emitter.setSize(10, 10);
		emitter.lifespan.set(0.3, 0.4);
		emitter.velocity.set( -100, -120, 100, -50);
		emitter.acceleration.set(0, 200);		
		emitter.alpha.set(1, 1, 0, 0);
		//emitter.acceleration.set(-_direction.x*3, -500);
		
		for ( n in 1...10)	
		{
					
			var p:FlxParticle = new FlxParticle();
			p.makeGraphic(2, 2,FlxG.random.getObject(color));
			
			emitter.add(p);
		}
				
		emitter.start(true);
		
		
	}
	
	
	public static function circle(_start_point:FlxPoint, color:Array<FlxColor>, particles:Int,speed:Int = 300, _s:Int = 1):Void
	{
		var emitter:EmitterEffect = new EmitterEffect(_start_point.x, _start_point.y);		
		emitter.launchMode = FlxEmitterMode.SQUARE;
		emitter.setSize(1, 1);
		//emitter.lifespan.set(lifespan);
		//emitter.velocity.set( -100, -100, 100, 100);
		//emitter.acceleration.set(0, 200);		
		//emitter.alpha.set(1, 1, 0, 0);
		//emitter.acceleration.set(-_direction.x*3, -500);
		var da:Float = 360 / particles;
		while(--particles>=0)
		{					
			var p:FlxParticle = new FlxParticle();
			p.makeGraphic(_s, _s, FlxG.random.getObject(color));
			p.velocity.set(speed, 0);
			p.velocity.rotate(FlxPoint.weak(), da * particles);
			emitter.add(p);
		}
				
		emitter.start(true);
		
	}
	
	public static function explosion_round(_start_point:FlxPoint, color:Array<FlxColor>,particles:Int, lifespan:Float,_s:Int = 1):Void
	{
		var emitter:EmitterEffect = new EmitterEffect(_start_point.x-5, _start_point.y-5);		
		emitter.launchMode = FlxEmitterMode.SQUARE;
		emitter.setSize(10, 10);
		emitter.lifespan.set(lifespan);
		emitter.velocity.set( -100, -100, 100, 100);
		//emitter.acceleration.set(0, 200);		
		//emitter.alpha.set(1, 1, 0, 0);
		//emitter.acceleration.set(-_direction.x*3, -500);
		
		while(--particles>=0)
		{					
			var p:FlxParticle = new FlxParticle();
			p.makeGraphic(_s, _s,FlxG.random.getObject(color));
			emitter.add(p);
		}
				
		emitter.start(true);
		
		
	}
	
	public function new(X:Float=0, Y:Float=0, Size:Int=0) 
	{
		super(X, Y, Size);
		MyGameObjectLayer.state.effects.add(this);
	}
	
	
	private var final_lifetime:Float = 1;
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (!this.emitting)
		{
			final_lifetime-= elapsed;
			//trace('SHOOOT removed');
			if (final_lifetime < 0)
			{
				MyGameObjectLayer.state.effects.remove(this, true);
				this.kill();
				this.destroy();
			}
		}
		
	}
	
}