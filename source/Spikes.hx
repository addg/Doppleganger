package;

import flixel.FlxSprite;


class Spikes extends FlxSprite 
{
	
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.spikes__png, true, 25, 8);
		set_width(21);
		set_height(5);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	
}