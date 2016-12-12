import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

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
	var positions:Array<FlxPoint>;
	var flipField:Array<String>;

	override public function new(x: Float, y: Float, name: String) {
		super(x, y, 'assets/images/activities.png');
		this.name = name;

		guests = new Array<Guest>();
		positions = new Array<FlxPoint>();

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
			positions.push(new FlxPoint(x + 5, y + 20));
			positions.push(new FlxPoint(x + 5, y + 43));
			positions.push(new FlxPoint(x + 30, y + 5));
			positions.push(new FlxPoint(x + 30, y + 28));
			positions.push(new FlxPoint(x + 55, y + 15));
			positions.push(new FlxPoint(x + 55, y + 38));
			flipField = ["normal", "normal", "normal", "flipped", "flipped", "flipped"];

		} else if(name == "tennis") {
			type = 'exercise';
			energyPerSecond = 2;
			happinessAdded = 2;
			happinessAddedTime = 2;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			positions.push(new FlxPoint(x + 10, y + 20));
			positions.push(new FlxPoint(x + 60, y + 20));
			flipField = ["normal", "flipped"];
			capacity = 2;
		} else if(name == "spa") {
			type = 'relaxation';
			energyPerSecond = 2;
			happinessAdded = 2;
			happinessAddedTime = 2;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			positions.push(new FlxPoint(x, y + 25));
			positions.push(new FlxPoint(x + 70, y + 12));
			flipField = ["normal", "flipped"];
			capacity = 2;
		} else if(name == "room") {
			type = 'sleep';
			energyPerSecond = 2;
			happinessAdded = 2;
			happinessAddedTime = 2;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			positions.push(new FlxPoint(x + 5, y + 25));
			flipField = ["normal"];
			capacity = 1;
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
		if(positions.length != 0) {
			for(i in 0...positions.length) {
				var p = positions[i];
				var emptySpot = true;
				for(g in guests) {
					FlxG.log.add(g.getPosition().x + " " + g.getPosition().y + " " + p.x + " " + p.y);
					if(g.getPosition().x == p.x && g.getPosition().y == p.y) {
						emptySpot = false;
					}
				}
				if(emptySpot) {
					guest.setPosition(p.x, p.y);
					guest.flipped = flipField[i];
					break;
				}
			}
		}
		guests.push(guest);
		if(name == "tennis") {
			if(guests.length == 1) {
				guest.setMood("sad");
			} else {
				for(g in guests) {
					g.setMood("happy");
				}
			}
		}
		return true;
	}
}