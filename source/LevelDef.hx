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
	@:optional var startTo:String;
	@:optional var startFrom:String;
	@:optional var startSubject:String;
	@:optional var startEmail:String;
	
	//Finish email settings
	@:optional var endTo:String;
	@:optional var endFrom:String;
	@:optional var endSubject:String;
	@:optional var endEmail:String;
	
}