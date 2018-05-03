package;

import flixel.addons.ui.FlxUIPopup;
import flixel.FlxG;

class Popup_WonGame extends FlxUIPopup
{
	public override function create():Void
	{
		
		_xml_id = "Popup_WinGame";
		
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
		
		//FlxG.mouse.enabled = true;
		FlxG.mouse.visible = true;
		
		// These do unneccessary things
		//_xml_id = "default_popup";
		super.create();
		//_ui.setMode("IDKWhatThisDoes");
		
		// Records the they won
		Main.LOGGER.logLevelEnd({win: true, level: Data.currLevel, endTime: Date.now().toString()});
		
		// If this gives way too much data, comment out and use the one in loadNextLevel();
		Data.logData();
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
					case 0: loadMainMenu();
				}
			}
		}
	}
	
	override public function update(elapsed:Float):Void {
		
		if (FlxG.keys.justPressed.M) {
			loadMainMenu();
		}
		
		super.update(elapsed);
	}
	
	private function loadMainMenu():Void {
		Data.attempts = 1;
		FlxG.switchState(new MenuState());
	}
}