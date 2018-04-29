import flixel.addons.ui.FlxUIPopup;
import flixel.FlxG;

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
		FlxG.log.add("We went into getEvent");
		if (params != null)
		{
			FlxG.log.add("id: " + id);
			if (id == "click_button"){
				var i:Int = cast params[0];
				FlxG.log.add("i = " + i);
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