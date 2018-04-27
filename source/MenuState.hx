package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	private var _txtTitle:FlxText;
	private var _txtSubtitle:FlxText;
	private var _txtRestart:FlxText;
	private var _txtControls:FlxText;
	private var _sprUp:FlxSprite;
	private var _sprLeft:FlxSprite;
	private var _sprRight:FlxSprite;
	private var _btnPlay:FlxButton;
	private var _btnLevel:FlxButton;
	private var _lblColor:FlxColor = FlxColor.WHITE;
	
	private var offset = 50; // same as the pixel size of the square
	private var font_size = 35;
	
	override public function create():Void
	{
		_txtTitle = new FlxText(20, 20, 0, "Too Many Blocks!", font_size);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(X);
		add(_txtTitle);
		
		// buttons
		_btnPlay = new FlxButton(0, FlxG.height/3, "Play", clickPlay);
		_btnPlay.loadGraphic("assets/images/blocks_for_button_long.png", true, 150, 50);
		_btnPlay.label.setFormat("", font_size - 10, _lblColor, CENTER);
		_btnPlay.label.offset.x += offset;
		add(_btnPlay);
		_btnPlay.screenCenter(X);
		
		_btnLevel = new FlxButton(0, 20 + offset * 6, "Level", clickLevel);
		add(_btnLevel);
		_btnLevel.screenCenter(X);
		
		
		// tips for player
		_txtSubtitle = new FlxText(20, 20 + offset, 0, "Join the Blocks!", font_size - 10);
		_txtSubtitle.screenCenter(X);
		add(_txtSubtitle);
		
		_txtRestart = new FlxText(20, 20 + offset * 7, 0, "Press R to Restart Level", font_size - 20);
		_txtRestart.screenCenter(X);
		add(_txtRestart);
		
		_txtControls = new FlxText(_btnPlay.x - offset * 0.25, 20 + offset * 4.5, 0, "Move: \nJump: ", font_size - 15);
		_sprUp = new FlxSprite(_btnPlay.x + offset * 2.25, 20 + offset * 5.0, "assets/images/up_arrow.png");
		_sprLeft = new FlxSprite(_btnPlay.x + offset * 2, 20 + offset * 4.5, "assets/images/left_arrow.png");
		_sprRight = new FlxSprite(_btnPlay.x + offset * 2.5, 20 + offset * 4.5, "assets/images/right_arrow.png");
		//_txtMove.loadGraphic("assets/images/keyboard_arrows.png");
		//_txtJump.loadGraphic("assets/images/keyboard_arrow_up.png");
		add(_txtControls);
		add(_sprUp);
		add(_sprLeft);
		add(_sprRight);
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