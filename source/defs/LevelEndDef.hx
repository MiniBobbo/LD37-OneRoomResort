package defs;

/**
 * End of the game definition.
 * @author Dave
 */
typedef LevelEndDef =
{
	//The level number.
	var level:Int;
	
	//The name of the level
	var levelName:String;
	
	//The happiness values of the guests
	var guestHappiness:Array<Float>;
	
	//The type of the guests.
	var guestType:Array<String>;
	
	
}