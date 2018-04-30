package;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class LevelState extends FlxState
{
	private var _btnLevel:FlxButton;
	private var _txtLevel:FlxText;
	private var _txtCannotPlay:FlxText;
	private var _btnMenu:FlxButton;
	
	private var offset = 50;
	private var lvl_per_row = 5; // change this when the buttons are pushed out of the screen
	
	override public function create():Void 
	{
		_txtLevel = new FlxText(0, 0, 0, "Choose A Level", 35);
		_txtLevel.screenCenter(X);
		add(_txtLevel);
		
		for (i in 0...Data.amtLevels) {
			if (Data.canPlayLevel[i + 1]) {
				_btnLevel = new FlxButton(offset * (i % lvl_per_row + 4), offset * (Std.int(i / lvl_per_row) + 2),  i + 1 + "", clickLevel.bind(i+1));
				_btnLevel.scale.set(0.5, 2);
				_btnLevel.label.setFormat("", 15);
				add(_btnLevel);
			} else {// FlxText does not align with FlxButton, so the offset is hardcoded
				_txtCannotPlay = new FlxText(offset * (i % lvl_per_row + 4.5) + 5, offset * (Std.int(i / lvl_per_row) + 2) + 5, offset, i + 1 + "", 15);
				add(_txtCannotPlay);
			}
		}
		
		_btnMenu = new FlxButton(FlxG.width - offset*2, FlxG.height - offset*2, "Back To Menu", backMenu);
		add(_btnMenu);
		
		super.create();
	}
	
	private function clickLevel(level:Int):Void
	{
		Data.currLevel = level;
		Main.LOGGER.logLevelStart(Data.currLevel, {Start: Date.now().toString()});
		FlxG.switchState(new PlayState());
	}
	
	private function backMenu():Void
	{
		FlxG.switchState(new MenuState());
	}
	
}