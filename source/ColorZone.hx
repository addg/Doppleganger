package;

import flixel.FlxSprite;

class ColorZone extends FlxSprite 
{
	public var thisColor:Int;
	
	// Only blocks that have the same color can go through the color zones
	
	// How to use:
	// For graphics, its in the tileset. Just place those where you want them.
	// There is an invisible entity (which is actually what this class is).
	// Place the invisible entity over each block of color zone you added.
	// Set the entity color to the color you chose (Orange = 0, Blue = 1).
	
	// NOTE: currently enemy blocks don't interact with the color zones at all.
	// This was done by choice, if we want them to, I can edit it so that enemies collide
	// with the color zones
	
	public function new(?X:Float=0, ?Y:Float=0, color:Int) 
	{
		super(X, Y);
		
		// ORANGE = 0
		// BLUE   = 1
		
		thisColor = color;
		
		solid = true;
		immovable = true;
		// this is just an empty image as a placeholder
		// set both the entity(invisible) dye and walls dye in ogmo to visualize
		loadGraphic(AssetPaths.transparent__png, false, 25, 25);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
}