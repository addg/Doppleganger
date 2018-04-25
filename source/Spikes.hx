package;

import flixel.FlxSprite;


class Spikes extends FlxSprite 
{
	
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.spikes__png, true, 25, 8);
		//offset.set(0, -17);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	
}