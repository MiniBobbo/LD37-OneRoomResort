package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Dave
 */
class Emot extends FlxSprite
{

	var timer:Float;
	
	public function new() 
	{
		super();
		loadGraphic('assets/images/emot.png', true);
		animation.add('sad', [0]);
		animation.add('happy', [1]);
		animation.add('energy', [2]);
		
	}
	
	/**
	 * Spawns an emot for this guest.
	 * @param	guest
	 */
	public function spawn(guest:Guest, emot:String = '') {
		reset(guest.x + (guest.width / 2), guest.y + (guest.height / 2));
		if (emot != '')
		animation.play(emot);
		else
		animation.play(guest.getMood()+ '' );
		acceleration.y -= 10 + FlxG.random.float(0, 30);
		velocity.set();
		velocity.x = FlxG.random.float( -10, 10);
		timer = .3;
		alpha = 1;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (timer > 0) {
			timer -= elapsed;
		} else
			alpha -= elapsed;
			
		if (alpha <= 0)
		kill();
		
	}
	
}