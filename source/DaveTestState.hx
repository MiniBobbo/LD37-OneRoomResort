package;

import defs.LevelEndDef;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;

/**
 * ...
 * @author Dave
 */
class DaveTestState extends FlxState
{

	override public function create():Void 
	{
		super.create();
		
		var g = new FlxSprite(10, 10);
		g.loadGraphic('assets/images/guestfemale.png', true, 32, 32);

		g.animation.add('happynothing', [0,1,0], 5, true);
		g.animation.add('neutralnothing', [2,3,2],  5, false);
		g.animation.add('sadnothing', [4,5,4], 5, false);
		g.animation.add('happypool', [6,7,6], 5,false);
		g.animation.add('neutralpool', [8,9,8],5, false);
		g.animation.add('sadpool', [10,11,10], 5, false);
		g.animation.add('happytennis', [12,13,12], 5, false);
		g.animation.add('neutraltennis', [14,15,14], 5, false);
		g.animation.add('happyroom', [16,17,16], 5, false);
		g.animation.add('happyspa', [18,19,18], 5, false);
		g.animation.add('neutralspa', [20,21,20], 5, false);
		g.animation.add('sadspa', [22,23,22], 5, false);
		
		g.animation.play('happynothing');
		add(g);
		
		var b = new FlxButton(100, 100, "Start", startLevel);
		add(b);
	}
	
	private function startLevel() {
		var s = new LevelState( {
			name:'Starting out',
			activities:['room', 'pool', 'tennis', 'spa'],
			guests:5,
			gameLength:240
		});
		
		FlxG.switchState(s);
	}
	
	private function startLevelEnd() {
		var endDef:LevelEndDef = {
			level:1,
			levelName:'Test Level',
			guestHappiness:[100, 80, 34,50,65,34,92,66,44,77,88],
			guestType:['norm','norm','norm']
			
		};
		
		FlxG.switchState(new LevelEndState(endDef));
	}
}