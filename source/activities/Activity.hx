package activities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
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
		
		this.loadGraphic('assets/image/activities.png', true, 96, 76);
		animation.add('pool', [0]);
		animation.add('tennis', [1]);
		
		var a:Array<Int> = [];
		a.
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}