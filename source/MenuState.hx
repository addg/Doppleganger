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
	private var _txtPlay:FlxText;
	private var _sprUp:FlxSprite;
	private var _sprLeft:FlxSprite;
	private var _sprRight:FlxSprite;
	private var _btnPlay:FlxButton;
	private var _btnLevel:FlxButton;
	private var _btnHighscore:FlxButton;
	private var _btnResetData:FlxButton;
	private var clearDataPopup:FlxUIPopup;
	private var highScorePopup:FlxUIPopup;
	private var _lblColor:FlxColor = FlxColor.BLACK;
	
	private var _btnAlbinoBlackSheep:FlxButton;
	private var absPopup:FlxUIPopup;
	
	private var _btnMute:FlxButton;
	private var _btnToggleParticles:FlxButton;
	
	private var offset = 50; // same as the pixel size of the square
	private var font_size = 50;
	
	var _soundSelect:FlxSound;
	
	override public function create():Void
	{
		FlxG.mouse.visible = true;
		if (FlxG.sound.music == null) {
			//#if not flash
			FlxG.sound.playMusic("assets/music/combinedsongs.ogg", 0.05, true);
			FlxG.sound.list.maxSize = 1;
			//#end
		}
		
		_backgroundColor = new FlxSprite();
		_backgroundColor.loadGraphic(AssetPaths.bg_color__jpg);
		add(_backgroundColor);
		
		_backgroundBlock = new FlxSprite();
		_backgroundBlock.loadGraphic(AssetPaths.menu_bg__png);
		add(_backgroundBlock);
		
		_txtTitle = new FlxText(20, 20, 0, "Doppelgänger", font_size);
		_txtTitle.setFormat(AssetPaths.Unlock__ttf, font_size);
		_txtTitle.color = _lblColor;
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(X);
		add(_txtTitle);
		
		// buttons
		_btnPlay = new FlxButton(0, FlxG.height/3 - 30, "", clickPlay);
		_btnPlay.loadGraphic(AssetPaths.btn_play_new__png, true, 150, 50);
		//_btnPlay.label.setFormat(_txtTitle.font, font_size - 10, _lblColor, CENTER);
		//_btnPlay.label.offset.x += offset;
		add(_btnPlay);
		_btnPlay.screenCenter(X);
		
		_txtPlay = new FlxText(0, FlxG.height / 3 - 30, "Play", font_size - 20);
		_txtPlay.setFormat(_txtTitle.font, font_size - 20);
		_txtPlay.color = _lblColor;
		_txtPlay.alignment = CENTER;
		_txtPlay.screenCenter(X);
		_txtPlay.offset.x += 25;
		_txtPlay.offset.y -= 5;
		add(_txtPlay);
		
		_btnLevel = new FlxButton(0, 30 + offset * 5, "Level Select", clickLevel);
		_btnLevel.scale.set(1.5, 1.5);
		_btnLevel.label.fieldWidth = 100;
		_btnLevel.label.setFormat(_txtTitle.font, 14, _lblColor, CENTER);
		_btnLevel.label.offset.x += 10;
		_btnLevel.label.offset.y += 3;
		add(_btnLevel);
		_btnLevel.screenCenter(X);
		
		_btnMute = new FlxButton(0, 40 + offset * 5.65, "Sound ON", soundToggle);
		if (FlxG.sound.muted) {
			_btnMute.text = "Sound OFF";
		} else {
			_btnMute.text = "Sound ON";
		}
		add(_btnMute);
		_btnMute.screenCenter(X);
		
		_btnToggleParticles = new FlxButton(0, 65 + offset * 5.65, "Particles ON", particleToggle);
		if (Data.useParticles) {
			_btnToggleParticles.text = "Particles ON";
		} else {
			_btnToggleParticles.text = "Particles OFF";
		}
		add(_btnToggleParticles);
		_btnToggleParticles.screenCenter(X);
		
		/*
		_btnAlbinoBlackSheep = new FlxButton(0, FlxG.height - 25, "ABS!", clickABS);
		_btnAlbinoBlackSheep.loadGraphic(AssetPaths.btn_abs__png, false, 75, 25);
		_btnAlbinoBlackSheep.label.setFormat(_txtTitle.font, 15, _lblColor, CENTER);
		_btnAlbinoBlackSheep.label.offset.x += 11;
		//_btnAlbinoBlackSheep.label.offset.y -= 8;
		add(_btnAlbinoBlackSheep);
		*/
		
		/*
		 * 
		 * To be implemented, leaderboard for users to see the best time to complete the game
		_btnHighscore = new FlxButton(0, 20 + offset * 8, "Leaderboard", clickHighscore);
		_btnHighscore.label.setFormat(_txtTitle.font, 10, _lblColor, CENTER);
		_btnHighscore.scale.set(1.5, 1.5);
		add(_btnHighscore);
		_btnHighscore.screenCenter(X);
		*/
		
		_btnResetData = new FlxButton(FlxG.width - 80, FlxG.height - 20, "Clear Save", clearSavePopup);
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
		
		_txtControls = new FlxText(_btnPlay.x, -10 + offset * 4.5, 0, "Jump: \nMove: ", font_size - 30);
		_txtControls.setFormat(_txtTitle.font, font_size - 30, _lblColor);
		_sprUp = new FlxSprite(_btnPlay.x + offset * 2.25, -10 + offset * 4.5, AssetPaths.up_arrow__png);
		_sprLeft = new FlxSprite(_btnPlay.x + offset * 2, -10 + offset * 5.0, AssetPaths.left_arrow__png);
		_sprRight = new FlxSprite(_btnPlay.x + offset * 2.5, -10 + offset * 5.0, AssetPaths.right_arrow__png);
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
	
	private function clickHighscore():Void {
		highScorePopup = new Popup_Highscore(); //create the popup
		// We would have to periodically update this leaderboard which and replace the middle string.
		highScorePopup.quickSetup("Best game completion time, updated daily!", "First: 543.21s in 123 attempts \nSecond: 544.44 in 321 attempts", ["Close"]);
		openSubState(highScorePopup);
	}
	
	private function clickABS():Void {
		absPopup= new Popup_Highscore(); //create the popup
		absPopup.quickSetup("Thank you ABS!", "Given permission to be hosted by albinoblacksheep.com!", ["Close [ESC]"]);
		openSubState(absPopup);
	}
	
	private function clearSavePopup():Void {
		clearDataPopup = new Popup_ClearData(); //create the popup
		clearDataPopup.quickSetup("Are you sure you want to delete your save data?", "Once the data is deleted, you cannot get it back.", ["Yes", "No"]);
		openSubState(clearDataPopup);
	}
	
	private function soundToggle():Void {
		FlxG.sound.toggleMuted();
		
		if (FlxG.sound.muted) {
			_btnMute.text = "Sound OFF";
		} else {
			_btnMute.text = "Sound ON";
		}
	}
	
	private function particleToggle():Void {
		Data.useParticles = !Data.useParticles;
		
		if (Data.useParticles) {
			_btnToggleParticles.text = "Particles ON";
		} else {
			_btnToggleParticles.text = "Particles OFF";
		}
	}
}