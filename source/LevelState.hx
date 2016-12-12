package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
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
	private var timeRemaining:Float;
	private var timerText:FlxText;

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
		var rand = new FlxRandom();
		for(i in 0...levelInfo.guests) {
			var x = rand.int(0, 60);
			var y = rand.int(0, FlxG.height - 40);
			guestGroup.add(new Guest(x, y, 'assets/images/guest.png'));
		}

		for (g in guestGroup) {
			add(g);
		}

		timeRemaining = levelInfo.gameLength;
		timerText = new FlxText(FlxG.width - 50, FlxG.height - 20, getTimeText(timeRemaining), 16);
		add(timerText);
		//openSubState(new EmailSubstate('Dave', 'Izzybelle', 'I want food!', 'Feed me human!'));
	}

	public function getTimeText(timeRemaining: Float): String {
		var timeRemainingInt:Int = Math.floor(timeRemaining);

		var min:Int = Math.floor(timeRemainingInt / 60);
		timeRemainingInt -= min * 60;

		if(timeRemainingInt < 10) {
			return min + ":0" + timeRemainingInt;
		} else {
			return min + ":" + timeRemainingInt;
		}
	}

	override public function update(elapsed: Float):Void {
		super.update(elapsed);

		timeRemaining -= elapsed;

		timerText.text = getTimeText(timeRemaining);
		
		if(FlxG.mouse.justReleased) {
			dragTarget = null;
			dragging = false;
		}

		if(dragging) {
			dragTarget.setPosition(FlxG.mouse.x + dragOffset.x, FlxG.mouse.y + dragOffset.y);
		}
		
	}
	
}