package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;


class Player extends FlxSprite 
{
	public var speed:Float = 200;
	private var reverse:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, ?R:Int=1) 
	{
		reverse = R;
		super(X, Y);
		loadGraphic(AssetPaths.blocks__png, true, 25, 25);
		maxVelocity.x = 200;
		maxVelocity.y = 200;
		acceleration.y = 400;
		drag.x = drag.y = 1000;
		if (R == 1) {
			animation.add("normal", [0], 6, false);
			animation.play("normal");
		} else {
			animation.add("reversed", [1], 6, false);
			animation.play("reversed");
		}
		//setSize(24, 25);
		//offset.set(0, 0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		movement();
		super.update(elapsed);
	}
	
	private function movement():Void
	{
		acceleration.x = 0;
		if (FlxG.keys.anyPressed([LEFT,A])) {
			acceleration.x = -maxVelocity.x*4*reverse;
		}
		if (FlxG.keys.anyPressed([RIGHT,D])) {
			acceleration.x = maxVelocity.x*4*reverse;
		}
		if ((FlxG.keys.anyPressed([UP, "SPACE", W])) && isTouching(FlxObject.FLOOR)) {
			velocity.y = -400;
		}
	}
}