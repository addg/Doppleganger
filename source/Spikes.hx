package;

import flixel.FlxSprite;


class Spikes extends FlxSprite 
{
	
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.spikes__png, true, 25, 8);
		// Look at where we create spikes in PlayState if we want to change set_width
		set_width(19);
		set_height(5);
		offset.add(3, 0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	
}