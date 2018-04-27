package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;


class Player extends FlxSprite 
{
	//public var speed:Float = 200;
	private var reverse:Int;
	private var jumpSpeed:Int;
	public var thisColor:Int;
	public var movementAllowed:Bool;
	
	
	public function new(?X:Float=0, ?Y:Float=0, ?R:Int=1, ?Color:Int=0, ?CanMove:Int = 1) 
	{
		movementAllowed = CanMove == 1 ? true : false;
		thisColor = Color;
		jumpSpeed = 1000;
		// Checks to see if block should have reverse movement or not
		reverse = R % 2 == 1 ? -1 : 1;
		super(X, Y);
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
		if (FlxG.keys.anyPressed([LEFT, A]) && !FlxG.keys.anyPressed([RIGHT,D])) {
			acceleration.x = -maxVelocity.x * reverse * 10;
		}
		if (FlxG.keys.anyPressed([RIGHT,D]) && !FlxG.keys.anyPressed([LEFT, A])) {
			acceleration.x = maxVelocity.x * reverse * 10;
		}
		if ((FlxG.keys.anyPressed([UP, "SPACE", W])) && isTouching(FlxObject.DOWN)) {
			velocity.y = -jumpSpeed;
		}
	}
}