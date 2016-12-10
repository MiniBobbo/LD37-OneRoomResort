package activities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Dave
 */
class Activity extends FlxSprite
{

	public var name:String;
	public var type:String;
	
	public var energy:Float;
	public var happyAdd:Float;
	public var happyAddTime:Float;
	
	public var sadAdd:Float;
	public var sadAddTime:Float;
	
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
	}
	
}