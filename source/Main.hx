package;

import cse481d.logging.CapstoneLogger;
import flixel.FlxGame;
import flixel.math.FlxRandom;
import openfl.display.Sprite;

class Main extends Sprite
{
	// A bit of an ugly hack, basically using a global variable so it can be
	// fetched in any arbitrary class.
	public static var LOGGER:CapstoneLogger;
	public static var categoryId:Int = 2;
	
	private static var random:FlxRandom;
	
	public static var haveHints:Bool;
	
	public function new()
	{
		super();
		
		addChild(new FlxGame(700, 500, MenuState, 1, 60, 60, true));

		Data.setUpGameSave();
		Data.loadBestTimes();
		Data.loadCanPlayLevel();
		Data.loadLevelCompletionStatus();
		Data.loadAmountPlayed();
	}
}