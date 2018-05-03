package;

import flixel.FlxSprite;

class Dye extends FlxSprite 
{
	public var thisColor:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, color:Int) 
	{
		super(X, Y);
		
		thisColor = color;
		// this is just an empty image as a placeholder
		// set both the entity(invisible) dye and walls dye in ogmo to visualize
		loadGraphic(AssetPaths.transparent__png, false, 25, 25);
		// width offset in case the separate method overlaps the dye and block incorrectly
		set_width(21);
		set_height(3);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
}