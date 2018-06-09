import flixel.addons.ui.FlxUIPopup;
import flixel.FlxG;


// Popup for a pause menu. Currently the body is empty, if we want to write anything there we can.
// To write to the body you have to edit PlayState.hx near where this class is instantiated in the quicksetup method.

class Popup_Highscore extends FlxUIPopup
{
	public override function create():Void
	{
		FlxG.mouse.visible = true;
		// These do unneccessary things
		//_xml_id = "Popup_Simple";
		super.create();
	}
	
	public override function getEvent(id:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void 
	{
		if (params != null)
		{
			if (id == "click_button"){
				var i:Int = cast params[0];
				switch (i)
				{
					case 0: close();
				}
			}
		}
	}
	
	override public function update(elapsed:Float):Void {
		if (FlxG.keys.justPressed.ESCAPE) {
			close();
		}
		super.update(elapsed);
	}
}