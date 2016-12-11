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
		
	}
	
	private function clickStart(_) {
	
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
