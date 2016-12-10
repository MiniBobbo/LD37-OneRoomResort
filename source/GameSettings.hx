package;

/**
 * @author Dave
 */
typedef GameSettings =
{
	var roundLength:Float;
	
	var activities:Array<{name:String, type:String, energy:Float, happyAdd:Float, happyAddTime:Float, sadAdd:Float, sadAddTime:Float}>;
}