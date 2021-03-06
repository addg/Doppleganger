package;

import flixel.addons.ui.FlxUIPopup;
import flixel.FlxG;

class Popup_WonGame extends FlxUIPopup
{
	public override function create():Void
	{
		
		//_xml_id = "Popup_WinGame";
		
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
		if (params != null)
		{
			if (id == "click_button"){
				var i:Int = cast params[0];
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