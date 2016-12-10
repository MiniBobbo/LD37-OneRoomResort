package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
/**
 * ...
 * @author Dave
 */
class TestState extends FlxState
{

	// We'll use these variables for the dragging
	private var dragOffset:FlxPoint;
	private var dragging:Bool = false;
	private var dragTarget:FlxSprite;

	var bg:FlxSprite;
	var guests:Array<Guest>;
	
	override public function create():Void 
	{
		super.create();

		FlxG.plugins.add(new FlxMouseEventManager());

		guests = new Array<Guest>();
		
		bg = new FlxSprite(0, 0, 'assets/images/bg.png');
		add(bg);

		var guest:Guest = new Guest(10, 10, 'assets/images/guest.png');
		guests.push(guest);
		add(guest);
	}

	override public function update(elapsed: Float):Void {
		super.update(elapsed);
		
		if(FlxG.mouse.justReleased) {
			dragTarget = null;
			dragging = false;
		}

		if(dragging) {
			dragTarget.setPosition(FlxG.mouse.x + dragOffset.x, FlxG.mouse.y + dragOffset.y);
		}
		
	}
	
}