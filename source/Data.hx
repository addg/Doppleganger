package;

class Data 
{
	/* Please increment amtLevels when you create a new level! */
	public static var amtLevels:Int = 18;
	
	public static var attempts:Int = 0;
	public static var currLevel:Int = 1;
	public static var bestTimes:Array<Float> = new Array();
	
	public static var completedLevel:Array<Bool> = new Array();
	
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
}