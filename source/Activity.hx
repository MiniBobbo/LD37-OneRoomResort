import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import types.ActivityTypes;
import types.MoodType;

class Activity extends FlxSprite {
	var name: String;
	var type: ActivityTypes;

	var energyPerSecond: Float;

	var happinessAdded: Float;
	var happinessAddedTime: Float;

	var sadnessAdded: Float;
	var sadnessAddedTime: Float;

	var unhappinessThreshhold: Float;

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

			animation.add('pool', [0], 30, false);
			animation.add('tennis', [1],30, false);
			animation.add('spa', [2], 30,false);
			animation.add('room', [3], 30, false);
		} else {
			this.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);

			animation.add('nothing', [0], 30, false);
		}

		if(name == "nothing") {
			type = ActivityTypes.nothing;
			energyPerSecond = 1;
			happinessAdded = 0;
			happinessAddedTime = 5;
			sadnessAdded = 2;
			sadnessAddedTime = 10;
			unhappinessThreshhold = 5;
			capacity = 100;
		} else if(name == "pool") {
			type = ActivityTypes.relaxation;
			energyPerSecond = 2;
			happinessAdded = 2;
			happinessAddedTime = 10;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			capacity = 6;
			unhappinessThreshhold = 10;
			positions.push(new FlxPoint(x + 5, y + 20));
			positions.push(new FlxPoint(x + 5, y + 43));
			positions.push(new FlxPoint(x + 30, y + 5));
			positions.push(new FlxPoint(x + 30, y + 28));
			positions.push(new FlxPoint(x + 55, y + 15));
			positions.push(new FlxPoint(x + 55, y + 38));
			flipField = ["normal", "normal", "normal", "flipped", "flipped", "flipped"];
		} else if(name == "tennis") {
			type = ActivityTypes.exercise;
			energyPerSecond = 3;
			happinessAdded = 3;
			happinessAddedTime = 2;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			unhappinessThreshhold = 15;
			positions.push(new FlxPoint(x + 10, y + 20));
			positions.push(new FlxPoint(x + 60, y + 20));
			flipField = ["normal", "flipped"];
			capacity = 2;
		} else if(name == "spa") {
			type = ActivityTypes.relaxation;
			energyPerSecond = 1;
			happinessAdded = 2;
			happinessAddedTime = 2;
			sadnessAdded = 2;
			sadnessAddedTime = 2;
			unhappinessThreshhold = 10;
			positions.push(new FlxPoint(x, y + 25));
			positions.push(new FlxPoint(x + 70, y + 12));
			flipField = ["normal", "flipped"];
			capacity = 2;
		} else if(name == "room") {
			type = ActivityTypes.sleep;
			energyPerSecond = -5;
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
				guest.setMood(MoodType.sad);
			} else {
				for(g in guests) {
					g.setMood(MoodType.happy);
				}
			}
		}
		return true;
	}

	public function updateGuest(guest:Guest, time: Int) {
		if(name != "tennis" || guests.length == 2) {
			guest.energy -= energyPerSecond;
		} else {
			guest.energy -= 1;
		}

		if(guest.energy <= 0) {
			//guest.disable();
		}
		if(name != "room" && (time % unhappinessThreshhold == 0) && time != 0) {
			if(guest.getMood() == MoodType.happy){
				guest.setMood(MoodType.neutral);
			} else if(name != "tennis") {
				guest.setMood(MoodType.sad);
			}
		}
		if(name != "tennis" || guests.length == 2) {
			if(time % happinessAddedTime == 0 && guest.getMood() == MoodType.happy) {
				guest.happiness += happinessAdded;
			} else if(time % sadnessAddedTime == 0 && guest.getMood() == MoodType.sad) {
				guest.happiness -= sadnessAdded;
			}
		} else {
			if(time % 3 == 0 && guest.getMood() == MoodType.happy) {
				guest.happiness += 1;
			} else if(time % 3 == 0 && guest.getMood() == MoodType.sad) {
				guest.happiness -= 2;
			}
		}
	}
	
	/**
	 * Is this activity currently valid?  For instance, are there two people playing tennis?
	 * @return	True if yes.  Otherwise false
	 */
	public function activityActive():Bool {
		switch (name) 
		{
			case 'tennis':
				if (guests.length == 2)
				return true;
				return false;
			default:
				return true;
		}
	}
	
	/**
	 * Gets what the guest's current mood should be based on how long they have done this activity.  
	 * @param	activityTime	How long has this guest done this activity
	 * @return	The mood of the guest.  'happy', 'neutral', 'sad'
	 */
	public function getMood(activityTime:Float):MoodType {
		//If the guest has spent longer than the total happy and sad times, they are sad.
		if (activityTime >= happinessAddedTime + sadnessAddedTime)
			return MoodType.sad;
		else if (activityTime >= happinessAddedTime)
			return MoodType.neutral;
		else
			return MoodType.happy;
	}
}