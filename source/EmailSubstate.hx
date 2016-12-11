package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author Dave
 */
class EmailSubstate extends FlxSubState
{

	var email:FlxSpriteGroup;
	var bg:FlxSprite;
	
	var movedIn:Bool = false;
	
	public function new(emailTo:String, emailFrom:String, emailSubject:String, emailText:String) 
	{
		super(FlxColor.TRANSPARENT);
		
		email = new FlxSpriteGroup();
		
		var emailFrame:FlxSprite = new FlxSprite(0, 0, 'assets/images/bg2.png');
		var from:FlxText = new FlxText(14, 12, 400, 'To: ' + emailTo + '\nFrom: ' + emailFrom + '\nSubject: ' + emailSubject, 12 );
		from.setFormat(null, 12, FlxColor.BLACK);
		
		var body:FlxText = new FlxText(14, 64, 446, emailText, 10);
		body.setFormat(null, 10, FlxColor.BLACK);
		
		email.add(emailFrame);
		email.add(from);
		email.add(body);
		
		email.y = FlxG.height;
		
		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		
		add(bg);
		add(email);
		
		FlxTween.tween(bg, { alpha:.5 }, .5, { onComplete:function(_) {
			FlxTween.tween(email, {y:0}, .5, {
				ease:FlxEase.quadInOut, 
				onComplete: function(_) {
					movedIn = true;
				}
				
			}); 
			
			
		}} );
		
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.mouse.justPressed && movedIn) {
			FlxTween.tween(email, { y:FlxG.height }, .5, {
				ease:FlxEase.quadInOut, 
				onComplete: function(_) {
					this._parentState.closeSubState();
				}
				
			} );
			
			FlxTween.tween(bg, {alpha:0}, .5);
			
		}
		
	}
	
}