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
	var buttons:Array<FlxButton>;
	
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
		start.x += 100;
		add(start);
		var help:FlxButton = new FlxButton(0, 0, "How to Play", clickHelp);
		help.screenCenter();
		help.y += 20;
		help.x += 100;
		add(help);
		
		//Create a button for every level in the game for testing purposes.
		buttons = [];
		for (i in 0...H.levels.length) {
			var b:FlxButton = new FlxButton(0, 50 + (22 * i), 'L ' + (i+1) +': ' + H.levels[i].name, function() {
				var level:LevelState = new LevelState(H.levels[i]);
				FlxG.switchState(level);
			});
			b.makeGraphic(250, 20, FlxColor.GRAY);
			b.label.setFormat(null, 12, FlxColor.BLACK, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
				b.ID = i;
				buttons.push(b);
				add(b);
		}
		
		
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
	
	public function startLevel() {
		//Loop through the buttons and find which one the mouse is on
		var clicked:Int = 0;
		for (i in 0...buttons.length) {
			if (buttons[i].overlapsPoint(FlxG.mouse.getPosition(), true))
				clicked = i;
				break;
		}
		
		var level:LevelState = new LevelState(H.levels[clicked]);
		FlxG.switchState(level);
	}
}
