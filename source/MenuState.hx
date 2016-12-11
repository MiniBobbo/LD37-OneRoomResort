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
		var level1Def:LevelDef = {
			name:"Level 1",
			activities:["room", "pool", "tennis", "spa", "tennis", "spa"],
			guests: 5,
			gameLength:240
		};


		var level:LevelState = new LevelState(level1Def);
		FlxG.switchState(level);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
