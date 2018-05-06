package;
import flixel.util.FlxSave;

class Data 
{
	/* Please increment amtLevels when you create a new level! */
	public static var amtLevels:Int = 32;
	// This is used so our saved data doesn't produce NaNs when we add levels.
	// If amtLevels > maxLevels, update maxLevels to a higher number.
	public static var maxLevels:Int = 100;
	
	public static var attempts:Int = 1;
	public static var currLevel:Int = 1;
	public static var bestTimes:Array<Float> = new Array();
	
	public static var completedLevel:Array<Bool> = new Array();
	public static var canPlayLevel:Array<Bool> = new Array();
	
	// Records total attempts on each level
	public static var amountPlayed:Array<Int> = new Array();
	
	public static var paused:Bool = false;
	
	// Object for local saving
	// Currently has arrays:
	// bestTimes
	// canPlayLevel
	// completedLevel
	// amountPlayed
	public static var _gameSave:FlxSave;
	
	public static function setUpGameSave() {
		_gameSave = new FlxSave();
		_gameSave.bind("gameSave");
	}
	
	public static function clearSavedData() {
		_gameSave.data.bestTimes = null;
		_gameSave.data.canPlayLevel = null;
		_gameSave.data.completedLevel = null;
		_gameSave.data.amountPlayed = null;
		loadBestTimes();
		loadCanPlayLevel();
		loadLevelCompletionStatus();
		loadAmountPlayed();
		_gameSave.flush();
	}
	
	// Currently called in Main.hx
	public static function resetBestTimes() {
		// Index 1 = level 1
		for (i in 0...(maxLevels)) {
			bestTimes[i] = 300.00;
		}
		// since 0 isn't a level, we set to 0 so when adding time it just adds 0
		bestTimes[0] = 0;
	}
	
	public static function loadBestTimes() {
		if (_gameSave.data.bestTimes != null) {
			// This means we have saved data on disk
			for (i in 0...(maxLevels)) {
				bestTimes[i] = _gameSave.data.bestTimes[i];
			}
		} else {
			// Theres no save data, so the first time they have logged in
			resetBestTimes();
			// Now we set save data so it at least exists
			_gameSave.data.bestTimes = new Array<Float>();
			// Fill the array with default values
			for (i in 0...(maxLevels)) {
				_gameSave.data.bestTimes[i] = 300;
			}
			// This writes to disk
			_gameSave.flush();
		}
	}
	
	// Currently called in Main.hx
	public static function resetLevelCompletionStatus() {
		// Index 1 = level 1
		for (i in 0...(maxLevels)) {
			completedLevel[i] = false;
		}
	}
	
	public static function loadLevelCompletionStatus() {
		if (_gameSave.data.completedLevel != null) {
			for (i in 0...(maxLevels)) {
				completedLevel[i] = _gameSave.data.completedLevel[i];
			}
		} else {
			resetLevelCompletionStatus();
			_gameSave.data.completedLevel = new Array<Bool>();
			for (i in 0...(amtLevels + 1)) {
				_gameSave.data.completedLevel[i] = false;
			}
			_gameSave.flush();
		}
	}
	
	public static function resetCanPlayLevel() {
		// Index 1 = level 1
		for (i in 0...(maxLevels)) {
			canPlayLevel[i] = false;
		}
		canPlayLevel[1] = true;
	}
	
	public static function loadCanPlayLevel() {
		if (_gameSave.data.canPlayLevel != null) {
			for (i in 0...(maxLevels)) {
				canPlayLevel[i] = _gameSave.data.canPlayLevel[i];
			}
		} else {
			resetCanPlayLevel();
			_gameSave.data.canPlayLevel = new Array<Bool>();
			for (i in 0...(maxLevels)) {
				_gameSave.data.canPlayLevel[i] = false;
			}
			_gameSave.data.canPlayLevel[1] = true;
			
			_gameSave.flush();
		}
	}
	
	public static function resetAmountPlayed() {
		for (i in 0...(maxLevels)) {
			amountPlayed[i] = 0;
		}
	}
	
	public static function loadAmountPlayed() {
		if (_gameSave.data.amountPlayed != null) {
			for (i in 0...(maxLevels)) {
				amountPlayed[i] = _gameSave.data.amountPlayed[i];
			}
		} else {
			resetAmountPlayed();
			_gameSave.data.amountPlayed = new Array<Int>();
			for (i in 0...(maxLevels)) {
				_gameSave.data.amountPlayed[i] = 0;
			}
			
			_gameSave.flush();
		}
	}
	
	public static function incAttempt() {
		amountPlayed[currLevel]++;
	}
	
	public static function logData() {
		Main.LOGGER.logActionWithNoLevel(LoggingActions.BEST_TIMES, bestTimes.toString());
		Main.LOGGER.logActionWithNoLevel(LoggingActions.ATTEMPTS, amountPlayed.toString());
	}
}