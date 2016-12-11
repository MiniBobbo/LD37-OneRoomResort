package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
/**
 * ...
 * @author Dave
 */
class LevelState extends FlxState
{

	// We'll use these variables for the dragging
	private var dragOffset:FlxPoint;
	private var dragging:Bool = false;
	private var dragTarget:FlxSprite;

	public static var heldGuest: Guest;
	var bg:FlxSprite;

	var guestGroup:FlxTypedGroup<Guest>;
	public static var activityGroup:FlxTypedGroup<Activity>;
	var levelInfo:LevelDef;

	override public function new(levelInfo: LevelDef):Void {
		super();
		this.levelInfo = levelInfo;
	}
	
	override public function create():Void 
	{
		super.create();

		FlxG.plugins.add(new FlxMouseEventManager());

		guestGroup = new FlxTypedGroup<Guest>();
		activityGroup = new FlxTypedGroup<Activity>();
		heldGuest = null;
		
		bg = new FlxSprite(0, 0, 'assets/images/bg.png');
		add(bg);
		var maxX = 368;
		var x = 80;
		var y = 15;
		for(r in levelInfo.activities) {
			activityGroup.add(new Activity(x, y, r));
			x += 96;
			if(x > maxX) {
				y = 135;
				x = 80;
			}
		}
		activityGroup.add(new Activity(0, 0, 'nothing'));

		for(a in activityGroup) {
			add(a);
		}
		
		for(i in 0...levelInfo.guests) {

			guestGroup.add(new Guest(10, 10, 'assets/images/guest.png'));
		}

		for (g in guestGroup) {
			add(g);
		}

		//openSubState(new EmailSubstate('Dave', 'Izzybelle', 'I want food!', 'Feed me human!'));
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