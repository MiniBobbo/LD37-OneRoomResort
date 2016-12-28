package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class HelpState extends FlxSubState
{

	public function new(BGColor:FlxColor=0) 
	{
		super(BGColor);
	}
	
	override public function create():Void 
	{
		super.create();
		var bg = new FlxSprite( -0, 0, 'assets/images/help.png');
		add(bg);
		

	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed) {
			_parentState.closeSubState();
		}
	}
	
	
}