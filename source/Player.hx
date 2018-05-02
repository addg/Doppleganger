package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;


class Player extends FlxSprite 
{
	//public var speed:Float = 200;
	private var reverse:Int;
	private var jumpSpeed:Int;
	public var thisColor:Int;
	public var movementAllowed:Bool;
	var _soundJump:FlxSound;
	
	
	public function new(?X:Float=0, ?Y:Float=0, ?R:Int=1, ?Color:Int=0, ?CanMove:Int = 1) 
	{
		
		super(X, Y);
		
		// sound initialization
		_soundJump = FlxG.sound.load("assets/sounds/jump.ogg", 0.20);
		movementAllowed = CanMove == 1 ? true : false;
		
		thisColor = Color;
		jumpSpeed = 1000;
		// Checks to see if block should have reverse movement or not
		reverse = R % 2 == 1 ? -1 : 1;
		loadGraphic(AssetPaths.blocks__png, true, 25, 25);
		maxVelocity.x = 250;
		maxVelocity.y = 600;
		acceleration.y = 2500;
		drag.x = drag.y = 2000;
		animation.add("type", [R], 6, false);
		animation.play("type");
		//setSize(23, 25);
		//offset.set(0, 0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (movementAllowed) {
			movement();
		}
		super.update(elapsed);
	}
	
	private function movement():Void
	{
		acceleration.x = 0;
		if (FlxG.keys.anyPressed([LEFT, A]) && !FlxG.keys.anyPressed([RIGHT, D])) {
			Main.LOGGER.logLevelAction(LoggingActions.PLAYER_MOVE, {direction: "left"});
			if (isTouching(FlxObject.LEFT) && !isTouching(FlxObject.FLOOR)) {
				acceleration.x = 1000;
			} else {
				acceleration.x = -maxVelocity.x * reverse * 10;
			}
		}
		if (FlxG.keys.anyPressed([RIGHT, D]) && !FlxG.keys.anyPressed([LEFT, A])) {
			Main.LOGGER.logLevelAction(LoggingActions.PLAYER_MOVE, {direction: "right"});
			acceleration.x = maxVelocity.x * reverse * 10;
		}
		if ((FlxG.keys.anyJustPressed([UP, "SPACE", W])) && isTouching(FlxObject.DOWN)) {
			Main.LOGGER.logLevelAction(LoggingActions.PLAYER_MOVE, {direction: "jump"});
			velocity.y = -jumpSpeed;
			_soundJump.play(true);
		}
	}
	
}