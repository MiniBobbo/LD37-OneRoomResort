package;

import defs.LevelEndDef;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

/**
 * ...
 * @author Dave
 */
class LevelEndState extends FlxState
{

	var info:LevelEndDef;
	
	var sg:FlxSpriteGroup;
	
	var titleOffset:FlxPoint;
	
	var guestsOffset:FlxPoint;
	var totalOffset:FlxPoint;
	
	var buttonNext:FlxPoint;
	var buttonBack:FlxPoint;
	
	
	/**
	 * Create a new level end state
	 * @param	levelEndInfo	The level end info to display.
	 */
	public function new(levelEndInfo:LevelEndDef) 
	{
		super();
		titleOffset = new FlxPoint(0, 10);
		guestsOffset = new FlxPoint(10, 60);
		totalOffset = new FlxPoint(300, 100);
		buttonNext = new FlxPoint(200, 250);
		buttonBack = new FlxPoint(30, 250);
		
		
		info = levelEndInfo;
		sg = new FlxSpriteGroup();
		
		var titleText:FlxText = new FlxText(titleOffset.x, titleOffset.y, FlxG.width, info.levelName + " Completed!", 35);
		
		add(titleText);
		
		//Loop through the list of guests and create a sprite and 
	}
	
	override public function create():Void 
	{
		super.create();
		

		
	}
	
}