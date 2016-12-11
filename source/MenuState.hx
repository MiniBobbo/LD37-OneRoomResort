package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var start:FlxButton = new FlxButton(0,0,"Start Game", clickStart);
		
		add(start);
	}
	
	private function clickStart() {
		var endState:LevelEndState = new LevelEndState( {
			levelName:'Test',
			guestHappiness:[90, 84, 32],
			guestType:['norm','norm','norm']
			
		});
		
		FlxG.switchState(endState);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
