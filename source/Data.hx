package;

class Data 
{
	/* Please increment amtLevels when you create a new level! */
	public static var amtLevels:Int = 25;
	
	public static var attempts:Int = 1;
	public static var currLevel:Int = 1;
	public static var bestTimes:Array<Float> = new Array();
	
	public static var completedLevel:Array<Bool> = new Array();
	public static var canPlayLevel:Array<Bool> = new Array();
	
	// Records total attempts on each level
	public static var amountPlayed:Array<Int> = new Array();
	
	public static var paused:Bool = false;
	
	// Currently called in Main.hx
	public static function resetBestTimes() {
		// Index 1 = level 1
		for (i in 0...(amtLevels + 1)) {
			bestTimes[i] = 60.00;
		}
	}
	
	// Currently called in Main.hx
	public static function resetLevelCompletionStatus() {
		// Index 1 = level 1
		for (i in 0...(amtLevels + 1)) {
			completedLevel[i] = false;
		}
	}
	
	public static function resetCanPlayLevel() {
		// Index 1 = level 1
		for (i in 0...(amtLevels + 1)) {
			canPlayLevel[i] = false;
		}
		canPlayLevel[1] = true;
	}
	
	public static function resetAmountPlayed() {
		for (i in 0...(amtLevels + 1)) {
			amountPlayed[i] = 0;
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