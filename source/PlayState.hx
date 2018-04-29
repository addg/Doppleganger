package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxTimer;
import flixel.addons.ui.FlxUIPopup;

class PlayState extends FlxState
{
	private var _player:FlxTypedGroup<Player>;
	private var _enemy:FlxTypedGroup<Player>;
	private var _spikes:FlxTypedGroup<Spikes>;
	private var _lock:FlxTypedGroup<Lock>;
	private var _key:FlxTypedGroup<Key>;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	private var failures:FlxText;
	private var currTime:FlxText;
	private var bestTime:FlxText;
	private var levelCount:FlxText;
	private var Timer:FlxTimer;
	private var started:Bool = false;
	private var beatLevelPopup:FlxUIPopup;
	private var pauseMenuPopup:FlxUIPopup;
	
	override public function create():Void
	{
		Timer = new FlxTimer();
		FlxObject.SEPARATE_BIAS = 15;
		FlxG.worldBounds.set(500,500);
		// Old way
		// Change to your level here by editing this value
		//                                           |
		//                                           V
		// _map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		
		// Since we are using a string instead of AssetPaths.blabla,
		// we have to give the file path as a string
		var _roomNumber:String = "assets/data/room-";
		
		// This just figures out how many 0's we need for our level
		if (Data.currLevel < 100) {
			if (Data.currLevel < 10) {
				_roomNumber += "00";
			} else {
				_roomNumber += "0";
			}
		}
		
		_roomNumber += "" + Data.currLevel + ".oel";
		
		_map = new FlxOgmoLoader(_roomNumber);
		_mWalls = _map.loadTilemap(AssetPaths.tiles3__png, 25, 25, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
		
		_player = new FlxTypedGroup<Player>();
		add(_player);
		
		_spikes = new FlxTypedGroup<Spikes>();
		add(_spikes);
		
		_enemy = new FlxTypedGroup<Player>();
		add(_enemy);
		
		_lock = new FlxTypedGroup<Lock>();
		add(_lock);
		
		_key = new FlxTypedGroup<Key>();
		add(_key);
		
		_map.loadEntities(placeEntities, "entities");
		
		failures = new FlxText(2, 2, 200);
		failures.size = 16;
		failures.text = "Attempts: " + Data.attempts;
		add(failures);
		
		currTime = new FlxText(FlxG.width - 200, 2 + 25, 200);
		currTime.size = 16;
		currTime.text = "Current time: " + 0.00;
		add(currTime);
		
		bestTime = new FlxText(FlxG.width - 200, 2, 200);
		bestTime.size = 16;
		bestTime.text = "Best time: " + Data.bestTimes[Data.currLevel];
		add(bestTime);
		
		levelCount = new FlxText(0, 2, 200);
		levelCount.size = 16;
		levelCount.screenCenter(X);
		levelCount.text = "Level " + Data.currLevel;
		add(levelCount);
		
		//for (blocks in _player) {
		//	FlxG.watch.add(blocks, "y");
		//}
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		
		if (FlxG.keys.justPressed.O) {
			updateLevel(-1);	
		}
		
		if (FlxG.keys.justPressed.P) {
			updateLevel(1);
		}
		
		if (FlxG.keys.justPressed.ESCAPE) {
			pauseMenu();
		}
		
		if (FlxG.keys.anyJustPressed([UP, LEFT, RIGHT, W, A, D, SPACE]) && !started) {
			started = true;
			Timer.start(100, null, 0);
		}
		if (started) {
			var num = Timer.elapsedTime;
			num = num * Math.pow(10, 2);
			num = Math.round(num) / Math.pow(10, 2);
			currTime.text = "Current time: " + num;
		}
		if (FlxG.keys.justPressed.R) {
			Data.attempts++;
			FlxG.resetState();
		}
		
		// If the game is ever paused, it sets the timer to be inactive
		// Popup_Pause.hx functions set Data.paused to be false for resuming
		if (!Timer.active && !Data.paused) {
			Timer.active = true;
		}
		
		FlxG.overlap(_player, _player, blocksCollide);
		FlxG.overlap(_player, _enemy, failed);
		FlxG.overlap(_player, _spikes, failed);
		FlxG.overlap(_player, _key, playerCollideKey);
		
		// Collisions for the blocks
		FlxG.collide(_mWalls, _player);
		FlxG.collide(_mWalls, _enemy);
		FlxG.collide(_player, _lock);
		FlxG.collide(_lock, _enemy);
	
		
		for (blocks in _player) {
			if (blocks.y > FlxG.height) {
				failed();
				break;
			}
		}
		
		super.update(elapsed);
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		// currently 0,1 orange, 2,3 blue, 4,5 bad, 6 = sleepy orange, 7 = sleepy blue
		// normal determines whether its a reverse block or not
		 var x:Int = Std.parseInt(entityData.get("x"));
		 var y:Int = Std.parseInt(entityData.get("y"));
		 if (entityName == "player") {
			// Creating an orange block
			// We probably want to name the other colored block or have an value to change here
			// Possibly var color:Int = Std.parseInt(entityData.get("color"));
			var color:Int = Std.parseInt(entityData.get("color"));
			var normal:Int = Std.parseInt(entityData.get("normal"));
			var sleepy:Int = Std.parseInt(entityData.get("sleepy"));
			if (sleepy == 1) {
				_player.add(new Player(x, y, 6 + color, color, 0));
			} else if (normal == 1) {
				_player.add(new Player(x, y, 0 + color * 2, color));
			} else {
				_player.add(new Player(x, y, 1 + color * 2, color));
			}
		 } else if (entityName == "enemy") {
			// Creating an enemy block
			var normal:Int = Std.parseInt(entityData.get("normal"));
			if (normal == 1) {
				_enemy.add(new Player(x, y, 4));
			} else {
				_enemy.add(new Player(x, y, 5));
			}
		 } else if (entityName == "spikes") {
			 _spikes.add(new Spikes(x, y + 17));
		 } else if (entityName == "lock") {
			 var color:Int = Std.parseInt(entityData.get("color"));
			 _lock.add(new Lock(x, y, color));
		 } else if (entityName == "key") {
			 var color:Int = Std.parseInt(entityData.get("color"));
			 _key.add(new Key(x, y, color));
		 }
	}
	
	private function blocksCollide(Block1:Player, Block2:Player):Void {
		if (Block1.thisColor == Block2.thisColor) {
			Block1.destroy();
			Block2.destroy();
			if (_player.countLiving() == 0) {
				Timer.cancel();
				var num = formatTime(Timer.elapsedTime);
				Data.bestTimes[Data.currLevel] = Math.min(num, Data.bestTimes[Data.currLevel]);
				bestTime.text = "Best time: " + Data.bestTimes[Data.currLevel];
				winScreen();
			}
		} else {
			if (Block1.exists && Block2.exists) {
				FlxObject.separate(Block1, Block2);
				Block1.setPosition(Block1.x, Math.ffloor(Block1.y) + 0.611);
				Block2.setPosition(Block2.x, Math.ffloor(Block2.y) + 0.611);
			}
		}
	}
	
	private function failed(?Block1:Player, ?Block2:Player):Void {
		// Display message here and wait for them to click retry? Maybe instantly restart?
		Data.attempts++;
		FlxG.resetState();
	}
	
	// Stores the key's color, then destroys the key and all locks with the same color
	private function playerCollideKey(player:Player, key:Key):Void {
		var keyColor:Int = key.thisColor;
		key.destroy();
		for (lock in _lock.members) {
			if (lock.thisColor == keyColor) {
				lock.destroy();
			}
		}
	}
	
	// i SHOULD always be either -1 or 1, but you can input any value
	// bounds checks: currLevel must be between 1 and amtLevels, inclusive on both
	// function adds i to currLevel and then tries to load that level
	private function updateLevel(i:Int):Void {
		Data.currLevel += i;
		if (Data.currLevel < 1) {
			Data.currLevel = 1;
		} else if (Data.currLevel > Data.amtLevels) {
			Data.currLevel = Data.amtLevels;
		}
		Data.attempts = 0;
		FlxG.switchState(new PlayState());
	}
	
	private function formatTime(time:Float, ?numDecimals:Int=2):Float {
		time = time * Math.pow(10, numDecimals);
		time = Math.round(time) / Math.pow(10, numDecimals);
		return time;
	}
	
	private function winScreen() {
		updateCompletedLevel();
		beatLevelPopup = new Popup_Simple(); //create the popup
		beatLevelPopup.quickSetup("You beat the level!", "You beat the level in " + formatTime(Timer.elapsedTime) + " seconds. Good Job!", ["Main Menu", "Retry", "Next Level"]);
		openSubState(beatLevelPopup);
	}
	
	// This is currently called in winScreen()
	private function updateCompletedLevel() {
		Data.completedLevel[Data.currLevel] = true;
	}
	
	// Creates the pause menu, sets timer to inactive and Data.paused to true
	private function pauseMenu():Void {
		Data.paused = true;
		Timer.active = false;
		pauseMenuPopup = new Popup_Pause(); //create the popup
		pauseMenuPopup.quickSetup("Pause Menu", "", ["Main Menu", "Retry", "Unpause"]);
		openSubState(pauseMenuPopup);
	}
}