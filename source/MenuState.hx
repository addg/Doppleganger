package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	private var _txtTitle:FlxText;
	private var _btnPlay:FlxButton;
	private var _btnLevel:FlxButton;
	private var _lblColor:FlxColor = FlxColor.WHITE;
	
	override public function create():Void
	{
		_txtTitle = new FlxText(20, 20, 0, "Too Many Blocks", 32);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(X);
		add(_txtTitle);
		
		_btnPlay = new FlxButton(0, FlxG.height/3, "Play", clickPlay);
		_btnPlay.loadGraphic("assets/images/blocks_for_button.png", true, 50, 65);
		_btnPlay.label.setFormat("", 10, _lblColor, CENTER);
		add(_btnPlay);
		_btnPlay.screenCenter(X);
		
		_btnLevel = new FlxButton(0, FlxG.height/3 + 75, "Level", clickLevel);
		add(_btnLevel);
		_btnLevel.screenCenter(X);
		Data.resetBestTimes();
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	private function clickLevel():Void
	{
		//go to level screen
	}
}