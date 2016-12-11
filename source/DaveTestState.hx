package;

import defs.LevelEndDef;
import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

/**
 * ...
 * @author Dave
 */
class DaveTestState extends FlxState
{

	override public function create():Void 
	{
		super.create();
		
		var b = new FlxButton(100, 100, "Start", start);
		add(b);
	}
	
	private function start() {
		var endDef:LevelEndDef = {
			level:1,
			levelName:'Test Level',
			guestHappiness:[100, 80, 34,50,65,34,92,66,44,77,88],
			guestType:['norm','norm','norm']
			
		};
		
		FlxG.switchState(new LevelEndState(endDef));
	}
}