package;

import defs.EmotDef;
import defs.LevelDef;
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
import types.ActivityTypes;
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

	//A helper pointer to the nothing activity.
	private var nothingActivity:Activity;
	
	public static var heldGuest: Guest;
	var bg:FlxSprite;

	var guestGroup:FlxTypedGroup<Guest>;
	var emoteGroup:FlxTypedGroup<Emot>;
	
	public static var activityGroup:FlxTypedGroup<Activity>;
	var levelInfo:defs.LevelDef;

	//Want variables
	var wantTimer:Float;
	var wants:Bool = false;
	
	override public function new(levelInfo: defs.LevelDef):Void {
		super();
		this.levelInfo = levelInfo;
		H.subStateClosed = false;
	}
	
	override public function create():Void 
	{
		super.create();

		
		//Initialize the emot group
		emoteGroup = new FlxTypedGroup<Emot>();
		
		//Create a bunch of emots.
		for (i in 0...100) {
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
		
		if (levelInfo.wantList != null && levelInfo.wantList.length > 0) {
			wants = true;
			wantTimer = levelInfo.wantBaseTime + FlxG.random.float(0,levelInfo.wantVariableTime);
		} else
		wantTimer = 0;
		
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
		nothingActivity = new Activity(0, 0, 'nothing');
		activityGroup.add(nothingActivity);

		for(a in activityGroup) {
			add(a);
		}
		var rand = new FlxRandom();
		for(i in 0...levelInfo.guests) {
			var x = rand.int(0, 60);
			var y = rand.int(0, FlxG.height - 40);
			var genders = ["guest", "guestfemale"];
			var gender = genders[rand.int(0, genders.length-1)];
			var guest: Guest;
			guest = new Guest(x, y, gender);
			guest.setPosition(x, y);
			add(guest.getEnergyBar());
			add(guest.getHappinessBar());
			add(guest.getWantBubble());

			guestGroup.add(guest);
		}

		add(guestGroup);
		//for (g in guestGroup) {
			//add(g);
		//}

		timeRemaining = levelInfo.gameLength;
		timerText = new FlxText(FlxG.width - 50, FlxG.height - 20, 0,getTimeText(timeRemaining), 16);
		add(timerText);
		add(emoteGroup);
		//openSubState(new EmailSubstate('Dave', 'Izzybelle', 'I want food!', 'Feed me human!'));
		
		//Set up watches for all the guest variables
		//for (i in 0...guestGroup.length) {
			//FlxG.watch.add(guestGroup.members[i], 'happiness', 'Guest ' + i + ' H:');
			//FlxG.watch.add(guestGroup.members[i], 'energy', 'Guest ' + i + ' E:');
			//FlxG.watch.add(guestGroup.members[i], 'idle', 'Guest ' + i + ' I:');
			//FlxG.watch.add(guestGroup.members[i], 'idleTime', 'Guest ' + i + ' IT:');
			//FlxG.watch.add(guestGroup.members[i], 'curMood', 'Guest ' + i + ' M:');
			//FlxG.watch.add(guestGroup.members[i], 'timeInCurActivity', 'Guest ' + i + ' CA:');
			//
		//}
		for (a in activityGroup) {
			FlxG.watch.add(a, 'name');
			FlxG.watch.add(a, 'guests');
			
		}
		
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
			//TODO:  Going over max emotes causes a crash.  Fix this.
			var e:EmotDef = H.emotions.pop();
			var g:Guest = e.guest;
			//If the emot isn't blank, play that emote instead of getting the guest happiness..
			var emote = emoteGroup.getFirstAvailable();
			if(e != null) {
			if (e.emot != '') {
				emote.spawn(g,e.emot);
				}
				else if (g.getMood() == MoodType.happy && g.curActivity.getName() != 'nothing') {
					//TODO  Add an icon spawn here.
					emote.spawn(g);
					FlxG.sound.play('assets/sounds/hearts.wav', .1);
				} else if (g.getMood() == MoodType.sad) {
					emote.spawn(g);
					FlxG.sound.play('assets/sounds/sad.wav', .1);
				}
			}
		}
		
		processKickedGuests();
		
		timeRemaining -= elapsed;
		
		//Calculate if a want should be generated
		if (wants) {
			wantTimer -= elapsed;
			//If the timer has expired, generate a want.  
			if (wantTimer <= 0) {
				generateWant();
			}
		}
		
		if (timeRemaining <= 0) {
			//Create the end of level email and display it.
			if (levelInfo.endEmail != null) {
				var ss:EmailSubstate = new EmailSubstate(levelInfo.endFrom, levelInfo.endTo, levelInfo.endSubject, levelInfo.endEmail, true);
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
	
	/**
	 * Generates a want from the list for one of the guests.
	 */
	private function generateWant() {
		//Try 10 times to find a guest without a want.  If not, just give up and try again next loop.  
		for (i in 0...10) {
			var g:Guest = guestGroup.getRandom();
			if (g.want == ActivityTypes.nothing) {
				g.createWant(levelInfo.wantList[FlxG.random.int(0, levelInfo.wantList.length - 1)], levelInfo.wantGuestTimeLimit);
				break;
			}
				
		}
		
		wantTimer = levelInfo.wantBaseTime + FlxG.random.float(0, levelInfo.wantVariableTime);
		
	}
	
	/**
	 * Goes through H.kickedGuests and kicks them out of their activities.
	 */
	private function processKickedGuests() {
		for (i in 0...H.kickGuests.length) {
			//Get the next guest.
			var guest = H.kickGuests.pop();
				guest.prevActivity = guest.curActivity;
				guest.curActivity.removeGuest(guest);
				guest.curActivity = nothingActivity;
				guest.setPosition(guest.prevActivity.x, guest.prevActivity.y + guest.prevActivity.height);
				guest.lastPoint.x = guest.x;
				guest.lastPoint.y = guest.y;
					guest.timeInCurActivity = 0;
				guest.playAnimation();

			//Kick the guest out of its activity.
			
		}
	}
}