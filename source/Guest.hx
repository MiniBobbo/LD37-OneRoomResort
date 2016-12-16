package;

import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxState;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import types.ActivityTypes;
import types.MoodType;

class Guest extends FlxSprite {
	var beingDragged:Bool = false;
	var dragOffset:FlxPoint;

	public var lastPoint: FlxPoint;

	var totalTime: Float;

	var curMood: MoodType;
	var lastMood: MoodType;
	var disabled: Bool;

	var energyBar:FlxBar;
	var happinessBar:FlxBar;
	
	public var want:ActivityTypes;
	var wantBubble:FlxSprite;
	var wantBubbuelOffset:FlxPoint;
	var wantTimer:Float;
	
	var wantEnergyAdd:Float = 10;
	var wantHappinessAdd:Float = 10;

	var animCounter: Float;
	var timeToNextAnim: Float;
	public var timeInCurActivity: Float;
	
	//Stores the idle time and the idle state.
	var idle:Bool;
	var idleTime:Float;
	
	public var flipped: String;

	public var happiness: Float;
	public var energy: Float;
	public var type:String;
	
	public var curActivity: Activity;
	public var prevActivity: Activity;

	override public function new(x: Float, y: Float, gender: String) {
		super(x, y);

		type = gender;
		
		energyBar = new FlxBar(x - 5, y - 10, 42, 2, this, "energy", 0, 100);
		energyBar.createColoredFilledBar(FlxColor.CYAN);
		energyBar.createColoredEmptyBar(FlxColor.BLACK);
		happinessBar = new FlxBar(x - 5, y - 5, 42, 2, this, "happiness", 0, 100);
		happinessBar.createColoredFilledBar(FlxColor.RED);
		happinessBar.createColoredEmptyBar(FlxColor.BLACK);

		
		want = ActivityTypes.nothing;
		wantBubble = new FlxSprite(0, 0);
		wantBubble.loadGraphic('assets/images/wants.png', true, 32, 32);
		wantBubble.animation.add('sleep', [0]);
		wantBubble.animation.add('exercise', [1]);
		wantBubble.animation.add('relaxation', [2]);
		wantBubble.animation.add('potty', [3]);
		
		wantBubble.visible = false;
		wantBubbuelOffset = new FlxPoint(23,0);
		
		this.loadGraphic('assets/images/'+ type+ '.png', true, 32, 32);

		curMood = MoodType.happy;
		lastMood = MoodType.happy;
		flipped = "normal";
		disabled = false;

		var frameTime = 5;

		animation.add('happynothingnormal', [1, 0], frameTime, false);
		animation.add('neutralnothingnormal', [3, 2], frameTime, false);
		animation.add('sadnothingnormal', [5, 4], frameTime, false);
		animation.add('happypoolnormal', [7, 6], frameTime, false);
		animation.add('neutralpoolnormal', [9, 8], frameTime, false);
		animation.add('sadpoolnormal', [11, 10], frameTime, false);
		animation.add('happytennisnormal', [13, 12], frameTime, false);
		animation.add('neutraltennisnormal', [15, 14], frameTime, false);
		animation.add('sadtennisnormal', [14], frameTime, false);
		animation.add('happyroomnormal', [17, 16], frameTime, false);
		animation.add('neutralroomnormal', [17, 16], frameTime, false);
		animation.add('sadroomnormal', [17, 16], frameTime, false);
		animation.add('happyspanormal', [19, 18], frameTime, false);
		animation.add('neutralspanormal', [21, 20], frameTime, false);
		animation.add('sadspanormal', [23, 22], frameTime, false);
		animation.add('happycoffeenormal', [25, 24], frameTime, false);
		animation.add('neutralcoffeenormal', [25, 24], frameTime, false);
		animation.add('sadcoffeenormal', [25, 24], frameTime, false);
		animation.add('happypottynormal', [26], frameTime, false);
		animation.add('neutralpottynormal', [26], frameTime, false);
		animation.add('sadpottynormal', [26], frameTime, false);

		animation.add('happynothingflipped', [1, 0], frameTime, false, true);
		animation.add('neutralnothingflipped', [3, 2], frameTime, false, true);
		animation.add('sadnothingflipped', [5, 4], frameTime, false, true);
		animation.add('happypoolflipped', [7, 6], frameTime, false, true);
		animation.add('neutralpoolflipped', [9, 8], frameTime, false, true);
		animation.add('sadpoolflipped', [11, 10], frameTime, false, true);
		animation.add('happytennisflipped', [13, 12], frameTime, false, true);
		animation.add('neutraltennisflipped', [15, 14], frameTime, false, true);
		animation.add('sadtennisflipped', [14], frameTime, false, true);
		animation.add('happyroomflipped', [17, 16], frameTime, false, true);
		animation.add('happyspaflipped', [19, 18], frameTime, false, true);
		animation.add('neutralspaflipped', [21, 20], frameTime, false, true);
		animation.add('sadspaflipped', [23, 22], frameTime, false, true);
		animation.add('happycoffeeflipped', [25, 24], frameTime, false, true);
		animation.add('neutralcoffeeflipped', [25, 24], frameTime, false, true);
		animation.add('happypottyflipped', [26], frameTime, false, true);
		animation.add('neutralpottyflipped', [26], frameTime, false, true);
		animation.add('sadpottyflipped', [26], frameTime, false, true);


		lastPoint = new FlxPoint(x, y);

		curActivity = LevelState.activityGroup.members[LevelState.activityGroup.length - 1];
		prevActivity = null;

		animCounter = 0;
		timeInCurActivity = 0;
		timeToNextAnim = 1.5 + FlxG.random.float(0, 2);

		happiness = 75;
		energy = 100;

		FlxMouseEventManager.add(this, onPress, onRelease, null, null);
	}

	public function getEnergyBar():FlxBar {
		return energyBar;
	}

	public function getHappinessBar(): FlxBar {
		return happinessBar;
	}


	private function onPress(Sprite:FlxSprite) {
		if (!curActivity.canGuestLeave())
		return;
		
		dragOffset = FlxPoint.get(x - FlxG.mouse.x, y - FlxG.mouse.y);
		beingDragged = true;
		if(curActivity != null) {
			prevActivity = curActivity;
		}
		LevelState.heldGuest = this;
	}

	private function onRelease(Sprite:FlxSprite) {
		beingDragged = false;
		LevelState.heldGuest = null;

		var newActivity:Bool = false;

			
	
		for(a in LevelState.activityGroup) {
			if(a.overlapsPoint(FlxG.mouse.getPosition())) {
				if(!a.addGuest(this)) {
					setPosition(lastPoint.x, lastPoint.y);
				} else {
					//If this activity meets the want, clear the want from the guest.
					if (want != ActivityTypes.nothing && want == a.getType()) {
						clearWant();
					}
					
					prevActivity = curActivity;
					curActivity.removeGuest(this);
					curActivity = a;
					lastPoint.x = x;
					lastPoint.y = y;
					if(curActivity.getName() != prevActivity.getName()) {
						timeInCurActivity = 0;
					}
					playAnimation();
				}
				break;
			}
		}
		
	}

	override public function update(elapsed: Float) {
		super.update(elapsed);

		//Replaced this so the guest manages its own happiness so later wants can be implemented more easily.
		//var timeInSecs:Int = Math.floor(timeInCurActivity);
		//timeInCurActivity += elapsed;
		//if(	Math.floor(timeInCurActivity) > timeInSecs) {
			//curActivity.updateGuest(this, timeInSecs);
		//}
		
		//When a guest is in an activity they are either idle or active.  
		//Idle means that the idle time counter goes up.  Remaining idle for too long makes guests unhappy.
		//Active means that the guest gains/loses energy/happiness based on the activity.
		
		//Check if this activity is valid.
		var newidle:Bool = curActivity.activityActive();
		//If the idle state changed, do something.
		if (newidle != idle) {
			idle = newidle;
			//If we just became idle, reset the idle counter.
			if (idle) {
				idleTime = 0;
			} 
		}
		
		if (want != ActivityTypes.nothing)
			wantTimer -= elapsed;
		
		//If a guest has a want that isn't met over the want limit, make their mood automatically sad.
		if (want != ActivityTypes.nothing && wantTimer <= 0)
			setMood(MoodType.sad);
		else if (idle) {
			idleTime += elapsed;
			//Get the idle time based on the activity (which is actually all the same).
			var m:MoodType = curActivity.getIdleMood(idleTime);
			//If the moods are different, set the mood to be the new current one.
			setMood(m);
		} else {
			timeInCurActivity += elapsed;
			var m:MoodType = curActivity.getMood(timeInCurActivity);
			//If the moods are different, set the mood to be the new current one.
			setMood(m);
			
		}

		//Do we need to be kicked from the current activity?
		curActivity.kickMe(this);
		
		//We should now have the idle and mood set correctly.  Now do the math and change happiness and energy.
		if (idle) {
			happiness += curActivity.getIdleHappiness(curMood) * elapsed;
			energy -= curActivity.getEnergy() * elapsed;
		} else {		
			happiness += curActivity.getHappiness(curMood) * elapsed;
			energy -= curActivity.getEnergy()* elapsed;
		}
		
		animCounter += elapsed;
		if(animCounter > timeToNextAnim) {
			playAnimation();
			animCounter = 0;
			timeToNextAnim = 1.0 + FlxG.random.float(0, 2);
		}
		if(beingDragged) {
			var x = FlxG.mouse.x + dragOffset.x;
			var y = FlxG.mouse.y + dragOffset.y;
			setPosition(x, y);
		}
		
		//If the guests's energy is 0, subtract 10 happiness a second.  
		if (energy <= 0 && curActivity.getName() != 'spa') {
			happiness -= 10 * elapsed;
		}
		
		//Clamp happiness and energy at 0 and 100.
		if (happiness <= 0 )
			happiness = 0;
		if (happiness > 100)
			happiness = 100;
		if (energy < 0)
			energy = 0;
		if (energy > 100)
			energy = 100;
		
	}

	override function setPosition(X: Float = 0, Y: Float = 0) {
		super.setPosition(X, Y);
		updateBarPositions();
		wantBubble.setPosition(X + wantBubbuelOffset.x, Y + wantBubbuelOffset.y);
	}

	private function updateBarPositions() {
		energyBar.setPosition(x - 5, y - 10);
		happinessBar.setPosition(x - 5, y - 5);
	}

	public function playAnimation() {
		H.spawnEmotion(this);
		animation.play(curMood + curActivity.getName() + flipped);
	}

	public function setMood(newMood: MoodType) {
		if(curMood != newMood) {
			lastMood = curMood;
			curMood = newMood;
			playAnimation();
		}
	}

	public function getMood(): MoodType {
		return curMood;
	} 
	
	public function createWant(want:ActivityTypes, wantTime:Float) {
		FlxG.log.add('Created want: ' + want);
		this.want = want;
		wantTimer = wantTime;
		wantBubble.animation.play(want+'');
		wantBubble.visible = true;
	}
	
	public function clearWant() {
		want = ActivityTypes.nothing;
		wantTimer = 0;
		wantBubble.visible = false;
		
		//Add the want energy and happiness.
		energy += wantEnergyAdd;
		happiness += wantHappinessAdd;
		//Spawn some emots for meeting the want.
		for (i in 0...3) {
			H.spawnEmotion(this, 'energy');
			H.spawnEmotion(this);
		}
	}
	
	public function getWantBubble():FlxSprite {
		return wantBubble;
	}
}