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
		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.GREEN);
		add(bg);
		
		
		this.openSubState(new EmailSubstate('Boss', 'Worker', 'Thanks for the job', 'I just wanted to pass along a note saything thanks for the job opportunity.'));
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
