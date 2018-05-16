package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxUIPopup;

class MenuState extends FlxState
{
	private var _backgroundColor:FlxSprite;
	private var _backgroundBlock:FlxSprite;
	private var _txtTitle:FlxText;
	private var _txtSubtitle:FlxText;
	private var _txtRestart:FlxText;
	private var _txtControls:FlxText;
	private var _sprUp:FlxSprite;
	private var _sprLeft:FlxSprite;
	private var _sprRight:FlxSprite;
	private var _btnPlay:FlxButton;
	private var _btnLevel:FlxButton;
	private var _btnResetData:FlxButton;
	private var clearDataPopup:FlxUIPopup;
	private var _lblColor:FlxColor = FlxColor.BLACK;
	
	private var offset = 50; // same as the pixel size of the square
	private var font_size = 35;
	
	var _soundSelect:FlxSound;
	
	override public function create():Void
	{
		//FlxG.mouse.enabled = true;
		FlxG.mouse.visible = true;
			if (FlxG.sound.music == null) {
			FlxG.sound.playMusic("assets/music/combinedsongs.ogg", 0.05, true);
			FlxG.sound.list.maxSize = 1;
		}
		
		_backgroundColor = new FlxSprite();
		_backgroundColor.loadGraphic(AssetPaths.bg_color__jpg);
		add(_backgroundColor);
		
		_backgroundBlock = new FlxSprite();
		_backgroundBlock.loadGraphic(AssetPaths.menu_bg__png);
		add(_backgroundBlock);
		
		_txtTitle = new FlxText(20, 20, 0, "Too Many Blocks!", font_size);
		_txtTitle.color = _lblColor;
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(X);
		add(_txtTitle);
		
		// buttons
		_btnPlay = new FlxButton(0, FlxG.height/3, "Play", clickPlay);
		_btnPlay.loadGraphic(AssetPaths.btn_play__png, true, 150, 50);
		_btnPlay.label.setFormat(_txtTitle.font, font_size - 10, _lblColor, CENTER);
		_btnPlay.label.offset.x += offset;
		add(_btnPlay);
		_btnPlay.screenCenter(X);
		
		_btnLevel = new FlxButton(0, 20 + offset * 6, "Level Select", clickLevel);
		add(_btnLevel);
		_btnLevel.screenCenter(X);
		
		_btnResetData = new FlxButton(FlxG.width - 85, FlxG.height - 25, "Clear Save", clearSavePopup);
		add(_btnResetData);
		
		
		// tips for player
		/*
		_txtSubtitle = new FlxText(20, 20 + offset, 0, "Join the Blocks!", font_size - 10);
		_txtSubtitle.color = _lblColor;
		_txtSubtitle.screenCenter(X);
		add(_txtSubtitle);
		*/
		
		/*
		_txtRestart = new FlxText(20, 20 + offset * 8, 0, "Press R to Restart Level", font_size - 20);
		_txtRestart.color = _lblColor;
		_txtRestart.screenCenter(X);
		add(_txtRestart);
		*/
		
		_txtControls = new FlxText(_btnPlay.x - offset * 0.25, 20 + offset * 4.5, 0, "Jump: \nMove: ", font_size - 15);
		_txtControls.color = _lblColor;
		_sprUp = new FlxSprite(_btnPlay.x + offset * 2.25, 20 + offset * 4.5, AssetPaths.up_arrow__png);
		_sprLeft = new FlxSprite(_btnPlay.x + offset * 2, 20 + offset * 5.0, AssetPaths.left_arrow__png);
		_sprRight = new FlxSprite(_btnPlay.x + offset * 2.5, 20 + offset * 5.0, AssetPaths.right_arrow__png);
		add(_txtControls);
		add(_sprUp);
		add(_sprLeft);
		add(_sprRight);
		
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{	/*
		if (Data.devTools) {
			if (FlxG.keys.justPressed.BACKSLASH) {
				Data.clearSavedData();
			}
		}
		*/
		if (FlxG.keys.justPressed.SPACE) {
			clickPlay();
		}
		super.update(elapsed);
	}
	
	private function clickPlay():Void
	{
		Main.LOGGER.logLevelStart(Data.currLevel);
		FlxG.switchState(new PlayState());
	}
	
	private function clickLevel():Void
	{
		FlxG.switchState(new LevelState());
	}
	
	private function clearSavePopup():Void {
		clearDataPopup = new Popup_ClearData(); //create the popup
		clearDataPopup.quickSetup("Are you sure you want to delete your save data?", "Once the data is deleted, you cannot get it back.", ["Yes", "No"]);
		openSubState(clearDataPopup);
	}
}