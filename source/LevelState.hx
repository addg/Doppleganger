package;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.util.FlxColor;


class LevelState extends FlxState
{
	private var _backgroundColor:FlxSprite;
	private var _backgroundBlock:FlxSprite;
	private var _background:FlxSprite;
	private var _btnLevel:FlxButton;
	private var _btnSprite:FlxSprite;
	private var _txtLevel:FlxText;
	private var _txtCannotPlay:FlxText;
	private var _txtSprite:FlxSprite;
	private var _txtBestTime:FlxText;
	private var _btnMenu:FlxButton;
	private var _lblColor:FlxColor = FlxColor.BLACK;
	
	private var offset = 50;
	private var lvl_per_row = 6; // change this when the buttons are pushed out of the screen
	
	override public function create():Void 
	{
		_backgroundColor = new FlxSprite();
		_backgroundColor.loadGraphic(AssetPaths.bg_color__jpg);
		add(_backgroundColor);
		
		_backgroundBlock = new FlxSprite();
		_backgroundBlock.loadGraphic(AssetPaths.level_bg__png);
		add(_backgroundBlock);
		
		_txtLevel = new FlxText(0, 0, 0, "Choose A Level", 35);
		_txtLevel.color = _lblColor;
		_txtLevel.screenCenter(X);
		add(_txtLevel);
		
		for (i in 0...Data.amtLevels) {
			if (Data.canPlayLevel[i + 1]) {
				_btnLevel = new FlxButton(offset * (i % lvl_per_row * 1.25 + 3), offset * (Std.int(i / lvl_per_row) * 1.25 + 2),  i + 1 + "", clickLevel.bind(i+1));
				_btnLevel.loadGraphic(AssetPaths.btn_white__png, true, 50, 50);
				_btnLevel.label.setFormat(_txtLevel.font, 15, _lblColor, FlxTextAlign.CENTER);
				add(_btnLevel);
				if (Data.completedLevel[i + 1]) {
					_txtBestTime = new FlxText(_btnLevel.x, _btnLevel.y + _btnLevel.height * 0.6, offset, Data.bestTimes[i + 1] + "s", 10);
					_txtBestTime.color = _lblColor;
					_txtBestTime.alignment = "center";
					add(_txtBestTime);
				}
			} else {
				_btnSprite = new FlxSprite(offset * (i % lvl_per_row * 1.25 + 3), offset * (Std.int(i / lvl_per_row) * 1.25 + 2));
				_btnSprite.loadGraphic(AssetPaths.btn_black__png);
				add(_btnSprite);
				//_txtCannotPlay = new FlxText(offset * (i % lvl_per_row * 1.25 + 3.25) + 5, offset * (Std.int(i / lvl_per_row) * 1.25 + 2) + 5, offset, i + 1 + "", 15);
				_txtCannotPlay = new FlxText(offset * (i % lvl_per_row * 1.25 + 3), offset * (Std.int(i / lvl_per_row) * 1.25 + 2), offset, i + 1 + "", 15);
				_txtCannotPlay.alignment = "center";
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