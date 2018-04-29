import flixel.addons.ui.FlxUIPopup;
import flixel.FlxG;


// Popup for a pause menu. Currently the body is empty, if we want to write anything there we can.
// To write to the body you have to edit PlayState.hx near where this class is instantiated in the quicksetup method.

class Popup_Pause extends FlxUIPopup
{
	public override function create():Void
	{
		// These do unneccessary things
		//_xml_id = "default_popup";
		super.create();
		//_ui.setMode("IDKWhatThisDoes");
	}
	
	public override function getEvent(id:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void 
	{
		if (params != null)
		{
			if (id == "click_button"){
				var i:Int = cast params[0];
				switch (i)
				{
					
					// 0 is far left button, 1 middle button, 2 right button. Can only have 3 buttons max
					case 0: loadMainMenu();
					case 1: loadCurrentLevel();
					case 2: closePauseMenu();
				}
			}
		}
	}
	
	override public function update(elapsed:Float):Void {
		if (FlxG.keys.justPressed.ESCAPE) {
			closePauseMenu();
		}
		super.update(elapsed);
	}
	
	private function loadMainMenu():Void {
		Data.paused = false;
		Data.attempts = 0;
		FlxG.switchState(new MenuState());
	}
	
	// Hitting retry adds 1 to attempts
	private function loadCurrentLevel():Void {
		Data.paused = false;
		Data.attempts += 1;
		FlxG.switchState(new PlayState());
	}
	
	private function closePauseMenu() {
		Data.paused = false;
		close();
	}
}