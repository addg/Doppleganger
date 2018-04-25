package;

class Data 
{	
	public static var attempts:Int = 0;
	public static var minTime:Float = 60.00;
	
	public function new(?AttemptCount:Int=0, ?Level:Int=1, ?Time:Float=1) 
	{
		attempts = AttemptCount;
		minTime = Time;
	}
	
}