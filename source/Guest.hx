package;

import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxState;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.ui.FlxBar;

class Guest extends FlxSprite {
	var beingDragged:Bool = false;
	var dragOffset:FlxPoint;

	var lastPoint: FlxPoint;

	var totalTime: Float;

	var curMood: String;
	var disabled: Bool;

	var gender: String;

	var energyBar:FlxBar;
	var happinessBar:FlxBar;

	var animCounter: Float;
	var timeToNextAnim: Float;
	var timeInCurActivity: Float;
	public var flipped: String;

	public var happiness: Float;
	public var energy: Float;
	var curActivity: Activity;
	var prevActivity: Activity;

	override public function new(x: Float, y: Float, path: String, gender: String) {
		super(x, y, path);

		energyBar = new FlxBar(x - 5, y - 10, 42, 2, this, "energy", 0, 100);
		happinessBar = new FlxBar(x - 5, y - 5, 42, 2, this, "happiness", 0, 100);
		this.gender = gender;
		if(gender == "male") {
			this.loadGraphic('assets/images/guest.png', true, 32, 32);
		} else {
			this.loadGraphic('assets/images/guestfemale.png', true, 32, 32);
		}

		curMood = "happy";
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
		animation.add('happyspanormal', [19, 18], frameTime, false);
		animation.add('neutralspanormal', [21, 20], frameTime, false);
		animation.add('sadspanormal', [23, 22], frameTime, false);

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
					prevActivity = curActivity;
					curActivity.removeGuest(this);
					curActivity = a;
					lastPoint.x = x;
					lastPoint.y = y;
					if(curActivity.getName() != "tennis") {
						if(curActivity.getName() != prevActivity.getName()) {
							setMood("happy");
							timeInCurActivity = 0;	
						}
					}
					playAnimation();
				}
				break;
			}
		}
	}

	override public function update(elapsed: Float) {
		super.update(elapsed);

		var timeInSecs:Int = Math.floor(timeInCurActivity);
		timeInCurActivity += elapsed;
		if(Math.floor(timeInCurActivity) > timeInSecs) {
			curActivity.updateGuest(this, timeInSecs);
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
	}

	override function setPosition(X: Float = 0, Y: Float = 0) {
		super.setPosition(X, Y);
		updateBarPositions();
	}

	public function getGender(): String {
		return gender;
	}

	private function updateBarPositions() {
		energyBar.setPosition(x - 5, y - 10);
		happinessBar.setPosition(x - 5, y - 5);
	}

	private function playAnimation() {
		animation.play(curMood + curActivity.getName() + flipped);
	}

	public function setMood(newMood: String) {
		curMood = newMood;
		playAnimation();
	}

	public function getMood(): String {
		return curMood;
	} 
}