package defs;

import types.ActivityTypes;
/**
 * @author Dave
 */
typedef LevelDef =
{
	//This will be calculated automatically.
	@:optional var levelNum:Int;
	//Level name
	var name:String;
	//Which activities should be in the level.
	var activities:Array<String>;
	//How many guests should be in the level?
	var guests:Int;
	
	//Game time in seconds
	var gameLength:Float;
	
	//Wants
	@:optional var wantBaseTime:Float;
	@:optional var wantVariableTime:Float;
	@:optional var wantList:Array<ActivityTypes>;
	@:optional var wantGuestTimeLimit:Float;
	
	
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