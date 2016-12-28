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
		
		var bg = new FlxSprite(0, 0, 'assets/images/bg.png');
		add(bg);
		
		var title:FlxText = new FlxText(0, 0, FlxG.width, 'One Room Resort');
		title.setFormat(null, 35, FlxColor.BLACK, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
		title.screenCenter();
		title.y -= 100;
		add(title);
		var start:FlxButton = new FlxButton(0, 0, "Start Game", clickStart);
		start.screenCenter();
		add(start);
		var help:FlxButton = new FlxButton(0, 0, "How to Play", clickHelp);
		help.screenCenter();
		help.y += 20;
		add(help);
		
	}
	
	private function clickStart() {

		var level:LevelState = new LevelState(H.levels[0]);
		FlxG.switchState(level);
	}
	
	private function clickHelp() {
		openSubState(new HelpState());
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
