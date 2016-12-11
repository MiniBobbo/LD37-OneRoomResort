import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxG;
import flixel.util.FlxColor;

class Activity extends FlxSprite {
	var name: String;
	var type: String;

	var energyPerSecond: Float;

	var happinessAdded: Float;
	var happinessAddedTime: Float;

	var sadnessAdded: Float;
	var sadnessAddedTime: Float;

	var capacity: Int;

	var guests:Array<Guest>;

	override public function new(x: Float, y: Float, name: String) {
		super(x, y, 'assets/images/activities.png');
		this.name = name;

		guests = new Array<Guest>();

		if(name != "nothing") {
			this.loadGraphic('assets/images/activities.png', true, 96, 76);

			animation.add('pool', [0], false);
			animation.add('tennis', [1], false);
			animation.add('spa', [2], false);
			animation.add('room', [3], false);
		} else {
			this.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);

			animation.add('nothing', [0], false);
		}

		if(name == "nothing") {
			type = 'nothing';
			energyPerSecond = 2;
			happinessAdded = 2;
			happinessAddedTime = 2;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			capacity = 100;
		} else if(name == "pool") {
			type = 'relaxation';
			energyPerSecond = 2;
			happinessAdded = 2;
			happinessAddedTime = 2;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			capacity = 6;
		} else if(name == "tennis") {
			type = 'exercise';
			energyPerSecond = 2;
			happinessAdded = 2;
			happinessAddedTime = 2;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			capacity = 2;
		} else if(name == "spa") {
			type = 'relaxation';
			energyPerSecond = 2;
			happinessAdded = 2;
			happinessAddedTime = 2;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			capacity = 1;
		} else if(name == "room") {
			type = 'sleep';
			energyPerSecond = 2;
			happinessAdded = 2;
			happinessAddedTime = 2;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			capacity = 2;
		}

		animation.play(name);
	}

	public function getName() {
		return name;
	}

	public function removeGuest(guest: Guest) {
		FlxG.log.add("Remove Guest");
		guests.remove(guest);
	}

	public function addGuest(guest: Guest): Bool {
		FlxG.log.add("Added guest to " + name);
		if(guests.length >= capacity) {
			FlxG.log.add("Can't add Guest");
			return false;
		}

		guests.push(guest);
		return true;
	}
}