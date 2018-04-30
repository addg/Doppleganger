package;

import flixel.FlxSprite;

class Lock extends FlxSprite 
{
	
	// Color: SET THIS IN OGMO
	// 0 = Yellow
	// 1 = Green
	// 2 = Red
	// 3 = Blue
	
	public var thisColor:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, color:Int) 
	{
		
		super(X, Y);
		
		thisColor = color;
		immovable = true;
		this.elasticity = 999999999;
		loadGraphic(AssetPaths.Locks__png, true, 25, 25);
		animation.add("type", [color], 6, false);
		animation.play("type");
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	
}