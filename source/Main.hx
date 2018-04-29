package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(700, 500, MenuState));
		Data.resetBestTimes();
		Data.resetLevelCompletionStatus();
		Data.resetCanPlayLevel();
	}
}