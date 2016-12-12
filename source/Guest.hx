package;

import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxG;
import flixel.math.FlxPoint;

class Guest extends FlxSprite {
	var beingDragged:Bool = false;
	var dragOffset:FlxPoint;

	var lastPoint: FlxPoint;

	var totalTime: Float;

	var curMood: String;

	var animCounter: Float;
	var timeToNextAnim: Float;
	public var flipped: String;

	var happiness: Int;
	var energy: Int;
	var curActivity: Activity;
	var prevActivity: Activity;

	override public function new(x: Float, y: Float, path: String) {
		super(x, y, path);

		this.loadGraphic('assets/images/guest.png', true, 32, 32);

		curMood = "happy";
		flipped = "normal";

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
		timeToNextAnim = 1.5 + FlxG.random.float(0, 2);

		happiness = 75;
		energy = 100;

		FlxMouseEventManager.add(this, onPress, onRelease, null, null);
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
					playAnimation();
				}
				break;
			}
		}
	}

	override public function update(elapsed: Float) {
		super.update(elapsed);

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

	private function playAnimation() {
		animation.play(curMood + curActivity.getName() + flipped);
	}

	public function setMood(newMood: String) {
		curMood = newMood;
		playAnimation();
	}
}