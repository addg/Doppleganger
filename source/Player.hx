package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;


class Player extends FlxSprite 
{
	public var speed:Float = 200;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		maxVelocity.x = 100;
		maxVelocity.y = 200;
		acceleration.y = 400;
		drag.x = drag.y = 1000;
		setSize(8, 14);
		offset.set(4, 2);
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
			acceleration.x = -maxVelocity.x*4;
		}
		if (FlxG.keys.anyPressed([RIGHT,D])) {
			acceleration.x = maxVelocity.x*4;
		}
		if ((FlxG.keys.anyPressed([UP, "SPACE", W])) && isTouching(FlxObject.FLOOR)) {
			velocity.y = -400;
		}
	}
}