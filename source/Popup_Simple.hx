import flixel.addons.ui.FlxUIPopup;
import flixel.FlxG;

class Popup_Simple extends FlxUIPopup
{
	public override function create():Void
	{
		
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
		
		super.update(elapsed);
	}
	
	private function loadMainMenu():Void {
		Data.attempts = 1;
		FlxG.switchState(new MenuState());
	}
	
	private function loadCurrentLevel():Void {
		Main.LOGGER.logLevelAction(LoggingActions.RESTART, {time: Date.now().toString(), reason: "Retrying won level"});
		FlxG.switchState(new PlayState());
	}
	
	private function loadNextLevel():Void {
		//Data.logData();
		
		Data.currLevel += 1;
		Main.LOGGER.logLevelStart(Data.currLevel, {Start: Date.now().toString()});
		if (Data.currLevel > Data.amtLevels) {
			Data.currLevel = Data.amtLevels;
		}
		
		Data.attempts = 1;
		FlxG.switchState(new PlayState());
	}
}