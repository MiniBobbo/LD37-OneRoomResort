import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxG;
import flixel.math.FlxPoint;

class Guest extends FlxSprite {
	var beingDragged:Bool = false;
	var dragOffset:FlxPoint;
	override public function new(x: Float, y: Float, path: String) {
		super(x, y, path);

		FlxMouseEventManager.add(this, onPress, onRelease, null, null);
	}

	private function onPress(Sprite:FlxSprite) {
		dragOffset = FlxPoint.get(x - FlxG.mouse.x, y - FlxG.mouse.y);
		beingDragged = true;
	}

	private function onRelease(Sprite:FlxSprite) {
		beingDragged = false;
	}

	override public function update(elapsed: Float) {

		if(beingDragged) {
			setPosition(FlxG.mouse.x + dragOffset.x, FlxG.mouse.y + dragOffset.y);
		}
	}
}
