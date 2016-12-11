package;

/**
 * @author Dave
 */
typedef LevelDef =
{
	//Level name
	var name:String;
	//Which activities should be in the level.
	var activities:Array<String>;
	//How many guests should be in the level?
	var guests:Int;
	
	//Game time in seconds
	var gameLength:Float;
	
	//Starting email settings
	var startTo:String;
	var startFron:String;
	var startSubject:String;
	var startEmail:String;
	
	//Finish email settings
	var endTo:String;
	var endFron:String;
	var endSubject:String;
	var endEmail:String;
	
}