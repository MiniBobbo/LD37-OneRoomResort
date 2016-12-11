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

	var happiness: Int;
	var energy: Int;
	var curActivity: Activity;
	var prevActivity: Activity;

	override public function new(x: Float, y: Float, path: String) {
		super(x, y, path);

		this.loadGraphic('assets/images/guest.png', true, 32, 32);

		curMood = "happy";

		animation.add('happynothing', [0], false);
		animation.add('neutralnothing', [1], false);
		animation.add('sadnothing', [2], false);
		animation.add('happypool', [3], false);
		animation.add('neutralpool', [4], false);
		animation.add('sadpool', [5], false);
		animation.add('happytennis', [6], false);
		animation.add('neutraltennis', [7], false);
		animation.add('happyroom', [8], false);
		animation.add('happyspa', [9], false);
		animation.add('neutralspa', [10], false);
		animation.add('sadspa', [11], false);


		lastPoint = new FlxPoint(x, y);

		curActivity = LevelState.activityGroup.members[LevelState.activityGroup.length - 1];
		prevActivity = null;

		animation.play(curMood + curActivity.getName());

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
					animation.play(curMood + curActivity.getName());
				}
				break;
			}
		}
	}

	override public function update(elapsed: Float) {
		if(beingDragged) {
			var x = FlxG.mouse.x + dragOffset.x;
			var y = FlxG.mouse.y + dragOffset.y;
			setPosition(x, y);
		}
	}
}