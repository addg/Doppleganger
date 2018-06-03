package;

import flixel.addons.ui.FlxUIPopup;
import flixel.FlxG;

class Popup_Simple extends FlxUIPopup
{
	public override function create():Void
	{
		_xml_id = "Popup_Simple";
		
		
		// When we beat the level we come in here, so we update the save data
		Data._gameSave.data.bestTimes[Data.currLevel] = Data.bestTimes[Data.currLevel];
		// For this, I could have just set to true, but I always want the two values equal here so I did this to be extra safe
		Data._gameSave.data.completedLevel[Data.currLevel] = Data.completedLevel[Data.currLevel];
		
		Data._gameSave.data.amountPlayed[Data.currLevel] += Data.attempts;
		
		if (Data.currLevel + 1 <= Data.amtLevels) {
			Data._gameSave.data.canPlayLevel[Data.currLevel + 1] = Data.canPlayLevel[Data.currLevel + 1];
		}
		
		// Write to disk
		Data._gameSave.flush();
		FlxG.mouse.visible = true;
		super.create();
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
	
	override public function update(elapsed:Float):Void {
		
		if (FlxG.keys.justPressed.R) {
			loadCurrentLevel();
		}
		
		if (FlxG.keys.justPressed.M) {
			loadMainMenu();
		}
		
		if (FlxG.keys.anyJustPressed([ENTER, SPACE])) {
			loadNextLevel();
		}
		
		super.update(elapsed);
	}
	
	private function loadMainMenu():Void {
		Data.attempts = 1;
		FlxG.switchState(new MenuState());
	}
	
	private function loadCurrentLevel():Void {
		FlxG.switchState(new PlayState());
	}
	
	private function loadNextLevel():Void {
		Data.currLevel += 1;
		if (Data.currLevel > Data.amtLevels) {
			Data.currLevel = Data.amtLevels;
		}
		
		Data.attempts = 1;
		FlxG.switchState(new PlayState());
	}
}