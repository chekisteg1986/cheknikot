package cheknikot.ai;

import cheknikot.game_objects.BaseCharacter;

/**
 * ...
 * @author ...
 */
class SidescrollAI extends BasicAI 
{

	public function new(c:BaseCharacter) 
	{
		super(c);
		cur_step = step_wasd;
	}
	
}