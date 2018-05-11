package;

import cse481d.logging.CapstoneLogger;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	// A bit of an ugly hack, basically using a global variable so it can be
	// fetched in any arbitrary class.
	public static var LOGGER:CapstoneLogger;
	
	public function new()
	{
		super();
		
		var gameId:Int = 1801;
		var gameKey:String = "64ec54af9a931c49fa3e60232910fa65";
		var gameName:String = "costume";
		// when you release it to family/friends set it to 2, when you release it to a public website set it to 3
		var categoryId:Int = -1;
		var useDev:Bool = true;
		Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId, useDev);
		
		// Retrieve the user (saved in local storage for later)
		var userId:String = Main.LOGGER.getSavedUserId();
		if (userId == null)
		{
			userId = Main.LOGGER.generateUuid();
			Main.LOGGER.setSavedUserId(userId);
		}
		Main.LOGGER.startNewSession(userId, this.onSessionReady);
	}
	
	private function onSessionReady(sessionRecieved:Bool):Void
	{
		addChild(new FlxGame(700, 500, MenuState, 1, 60, 60, true));
		// These three are now being saved, so calling new functions
		// Data.resetBestTimes();
		// Data.resetCanPlayLevel();
		// Data.resetLevelCompletionStatus();
		// Data.resetAmountPlayed();
		
		// Initializes gameSave var and sets name
		Data.setUpGameSave();
		
		// These check if there is saved data, if there is, loads it in, otherwise creates saved data
		Data.loadBestTimes();
		Data.loadCanPlayLevel();
		Data.loadLevelCompletionStatus();
		Data.loadAmountPlayed();
		
		
	}

}