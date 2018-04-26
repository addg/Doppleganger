package;

class Data 
{	
	public static var attempts:Int = 0;
	public static var currLevel:Int = 1;
	public static var amtLevels:Int = 7;
	public static var bestTimes:Array<Float> = new Array();
	
	public static function resetBestTimes() {
		// Index 1 = level 1
		for (i in 0...(amtLevels + 1)) {
			bestTimes[i] = 60.00;
		}
	}
}