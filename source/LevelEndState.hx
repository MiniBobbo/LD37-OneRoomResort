package;

import defs.LevelEndDef;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dave
 */
class LevelEndState extends FlxState
{

	var info:LevelEndDef;

	var sg:FlxSpriteGroup;
	var titleText:FlxText;
	var titleOffset:FlxPoint;

	var guestsOffset:FlxPoint;
	var totalOffset:FlxPoint;

	var spaceBetweenGuests:Float;
	var happinessOffset:Float;

	var buttonNextLocation:FlxPoint;
	var buttonBackLocation:FlxPoint;
	var buttonRetryLocation:FlxPoint;
	
	var btnBack:FlxButton;
	var btnNext:FlxButton;
	var btnRetry:FlxButton;

	/**
	 * Create a new level end state
	 * @param	levelEndInfo	The level end info to display.
	 */
	public function new(levelEndInfo:LevelEndDef)
	{
		info = levelEndInfo;
		super();
		titleOffset = new FlxPoint(0, 10);
		guestsOffset = new FlxPoint(10, 60);
		totalOffset = new FlxPoint(300, 100);
		buttonNextLocation = new FlxPoint(370, 250);
		buttonRetryLocation = new FlxPoint(200, 250);
		buttonBackLocation = new FlxPoint(30, 250);
		//spaceBetweenGuests = 35;
		
		//Calculate the space between the guests.  We have a total of ~180 pixels
		spaceBetweenGuests = 180 / info.guestHappiness.length;
		
		happinessOffset = 30;
	}

	override public function create():Void
	{
		super.create();

		sg = new FlxSpriteGroup();

		var bg = new FlxSprite(0, 0, 'assets/images/bg1.png');
		bg.alpha = .5;

		titleText= new FlxText(titleOffset.x, titleOffset.y, FlxG.width, info.levelName + " Completed!", 30);
		titleText.setFormat(null, 30, FlxColor.WHITE, FlxTextAlign.CENTER);

		//Loop through the list of guests and create a sprite for each
		for (i in 0...info.guestHappiness.length)
		{
			var s = new FlxSprite(guestsOffset.x, (spaceBetweenGuests * i));
			//TODO:  For now, this is hard coded.  Change this to use the info.guestType when there are multiples.
			s.loadGraphic('assets/images/guest.png', true, 32, 32);
			s.animation.add('happy', [0]);
			s.animation.add('neutral', [1]);
			s.animation.add('sad', [2]);
			//Set the animation based on the happiness level
			if (info.guestHappiness[i] <= 80)
				s.animation.play('neutral');
			if (info.guestHappiness[i] <= 50)
				s.animation.play('sad');
			var t:FlxText = new FlxText(guestsOffset.x + happinessOffset, (spaceBetweenGuests * i), 0, 'Happiness: ' + info.guestHappiness[i], 10);
			sg.add(s);
			sg.add(t);
		}

		add(bg);
		add(titleText);
		add(sg);

		btnBack = new FlxButton(buttonBackLocation.x, buttonBackLocation.y, "BACK", mainMenu);
		btnRetry = new FlxButton(buttonRetryLocation.x, buttonRetryLocation.y, "RETRY", retryLevel);
		btnNext = new FlxButton(buttonNextLocation.x, buttonNextLocation.y, "NEXT", nextLevel);

		pushOffscreen();

		add(btnBack);
		add(btnNext);
		add(btnRetry);

		FlxG.camera.fade(FlxColor.BLACK, .5, true, function() {startTweens(); } );
	}

	/**
	 * Pushes everything offscreen so we can zoom it in.
	 */
	private function pushOffscreen()
	{
		titleText.y += 1000;
		sg.y += 1000;
		btnBack.y += 1000;
		btnRetry.y += 1000;
		btnNext.y += 1000;
	}

	/**
	 * Starts the tweens when the camera fades in.
	 */
	private function startTweens()
	{
		FlxG.watch.add(sg, 'y');
		//Tween in the title first.
		FlxTween.tween(titleText, { y:titleOffset.y }, .5, { ease:FlxEase.quadInOut } );
		//Tween in the middle after.
		new FlxTimer().start(.2, function(_) {  
			FlxTween.tween(sg, { y:guestsOffset.y }, .5, { ease:FlxEase.quadInOut } );
		});
		
		//Last, tween buttons.
		new FlxTimer().start(.4, function(_) {  
			FlxTween.tween(btnBack, { y:buttonBackLocation.y }, .5, { ease:FlxEase.quadInOut } );
			FlxTween.tween(btnRetry, { y:buttonBackLocation.y }, .5, { ease:FlxEase.quadInOut } );
			FlxTween.tween(btnNext, { y:buttonBackLocation.y }, .5, { ease:FlxEase.quadInOut } );
		});
		
	}

	private function nextLevel()
	{
	}

	private function mainMenu()
	{
	}

	private function retryLevel()
	{
	}
}