import flixel.addons.ui.FlxUIPopup;
import flixel.FlxG;

class Popup_Simple extends FlxUIPopup
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
					case 2: loadNextLevel();
				}
			}
		}
	}
	
	private function loadMainMenu():Void {
		Data.attempts = 0;
		FlxG.switchState(new MenuState());
	}
	
	private function loadCurrentLevel():Void {
		Data.attempts = 0;
		FlxG.switchState(new PlayState());
	}
	
	private function loadNextLevel():Void {
		Data.currLevel += 1;
		
		if (Data.currLevel > Data.amtLevels) {
			Data.currLevel = Data.amtLevels;
		}
		
		Data.attempts = 0;
		FlxG.switchState(new PlayState());
	}
}