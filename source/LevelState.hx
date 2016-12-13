package;

import defs.LevelEndDef;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import types.MoodType;
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
	var emoteGroup:FlxTypedGroup<Emot>;
	
	public static var activityGroup:FlxTypedGroup<Activity>;
	var levelInfo:LevelDef;

	override public function new(levelInfo: LevelDef):Void {
		super();
		this.levelInfo = levelInfo;
		H.subStateClosed = false;
	}
	
	override public function create():Void 
	{
		super.create();

		FlxG.watch.add(H, 'subStateClosed');
		
		//Initialize the emot group
		emoteGroup = new FlxTypedGroup<Emot>();
		
		//Create a bunch of emots.
		for (i in 0...50) {
			var s = new Emot();
			s.kill();
			emoteGroup.add(s);
		}
		
		FlxG.plugins.add(new FlxMouseEventManager());
		
		if (levelInfo.startEmail != null) {
			var ss:EmailSubstate = new EmailSubstate(levelInfo.startTo, levelInfo.startFrom, levelInfo.startSubject, levelInfo.startEmail);
			this.openSubState(ss);
		}
		

		guestGroup = new FlxTypedGroup<Guest>();
		activityGroup = new FlxTypedGroup<Activity>();
		heldGuest = null;
		
		bg = new FlxSprite(0, 0, 'assets/images/bg1.png');
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
			var genders = ["guest", "guestfemale"];
			var gender = genders[rand.int(0, 1)];
			var guest: Guest;
			guest = new Guest(x, y, gender);
			add(guest.getEnergyBar());
			add(guest.getHappinessBar());

			guestGroup.add(guest);
		}

		for (g in guestGroup) {
			add(g);
		}

		timeRemaining = levelInfo.gameLength;
		timerText = new FlxText(FlxG.width - 50, FlxG.height - 20, 0,getTimeText(timeRemaining), 16);
		add(timerText);
		add(emoteGroup);
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

	//Quick, hacky way of dealing with the closing substate issue.
	var substateClosed:Bool = false;
	
	override public function update(elapsed: Float):Void {
		
		
		super.update(elapsed);

		//Check the emotion spawn queue and spawn any important emotions.
		for (i in 0...H.emotions.length) {
			var g = H.emotions.pop();
			if (g.getMood() == MoodType.happy && g.curActivity.getName() != 'nothing') {
				//TODO  Add an icon spawn here.
				emoteGroup.getFirstAvailable().spawn(g);
				FlxG.sound.play('assets/sounds/hearts.wav', .1);
			} else if (g.getMood() == MoodType.sad) {
				emoteGroup.getFirstAvailable().spawn(g);
				FlxG.sound.play('assets/sounds/sad.wav', .1);
			}
			
		}
		
		
		timeRemaining -= elapsed;
		
		//TODO: Level End state
		if (timeRemaining <= 0) {
			//Create the end of level email and display it.
			if (levelInfo.endEmail != null) {
				var ss:EmailSubstate = new EmailSubstate(levelInfo.endFrom, levelInfo.endTo, levelInfo.endSubject, levelInfo.endEmail, true);
				FlxG.log.add('Should be transitioning to substate');
				openSubState(ss);
			} else
			endLevel();
		
			
			
		}
		

		timerText.text = getTimeText(timeRemaining);
		
		if(FlxG.mouse.justReleased) {
			dragTarget = null;
			dragging = false;
		}

		if(dragging) {
			dragTarget.setPosition(FlxG.mouse.x + dragOffset.x, FlxG.mouse.y + dragOffset.y);
		}
		
	}
	
	public function endLevel() {
			//Create and transition to the LevelEndState
			var allGuests:Array<String> = [];
			var allHappiness:Array<Float> = [];
			
			for (g in guestGroup) {
				allGuests.push(g.type);
				allHappiness.push(g.happiness);
			}
			
			var lEnd:LevelEndDef = { 
				level:levelInfo.levelNum,
				levelName:levelInfo.name,
				guestHappiness:allHappiness,
				guestType:allGuests
			};
			var endState:LevelEndState = new LevelEndState(lEnd);
			//If there is no substate open, go to the end state.
			if (H.subStateClosed)
				FlxG.switchState(endState);
	}
}