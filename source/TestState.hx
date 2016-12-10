package;

import flixel.FlxSprite;
import flixel.FlxState;

/**
 * ...
 * @author Dave
 */
class TestState extends FlxState
{

	var bg:FlxSprite;
	var guest:FlxSprite;
	
	override public function create():Void 
	{
		super.create();
		
		bg = new FlxSprite(0, 0, 'assets/images/bg.png');
		add(bg);
	}
	
}