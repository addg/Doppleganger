package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxTimer;
import flixel.addons.ui.FlxUIPopup;
import flixel.addons.api.FlxKongregate;


class PlayState extends FlxState
{
	private var _player:FlxTypedGroup<Player>;
	private var _enemy:FlxTypedGroup<Player>;
	private var _spikes:FlxTypedGroup<Spikes>;
	private var _lock:FlxTypedGroup<Lock>;
	private var _key:FlxTypedGroup<Key>;
	private var _dye:FlxTypedGroup<Dye>;
	private var _colorZone:FlxTypedGroup<ColorZone>;
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
	
	private var fellOffMap:Bool = false;
	private var die:Bool = false;
	private var oldTime:Float;
	
	private var orange:FlxColor;
	private var blue:FlxColor;
	
	private var _emitter:FlxEmitter;
	private var _emitterCombine:FlxEmitter;
	
	static var recording:Bool = false;
	static var replaying:Bool = false;
	
	var _soundJoin:FlxSound;
	
	var _hintText:FlxText;
	
	override public function create():Void
	{
		super.create();
		
		orange = new FlxColor(1);
		orange.setRGB(255, 178, 127, 255);
		
		blue = new FlxColor(1);
		blue.setRGB(0, 148, 255, 255);
		
		FlxG.mouse.visible = false;
		
		Data.incAttempt();
		
		Timer = new FlxTimer();
		FlxObject.SEPARATE_BIAS = 15;
		FlxG.worldBounds.set(500,500);

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
		loadMap();
		
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
		
		_dye = new FlxTypedGroup<Dye>();
		add(_dye);
		
		_colorZone = new FlxTypedGroup<ColorZone>();
		add(_colorZone);
		
		_map.loadEntities(placeEntities, "entities");
		
		failures = new FlxText(2, 2, 200);
		failures.setFormat(AssetPaths.Unlock__ttf);
		failures.size = 20;
		failures.text = "Attempts: " + Data.attempts;
		add(failures);
		
		currTime = new FlxText(FlxG.width - 210, 2, 250);
		currTime.setFormat(AssetPaths.Unlock__ttf);
		currTime.size = 20;
		currTime.text = "Elapsed time: " + 0.00;
		add(currTime);
		
		/*
		bestTime = new FlxText(FlxG.width - 200, 2, 200);
		bestTime.size = 16;
		bestTime.text = "Best time: " + Data.bestTimes[Data.currLevel];
		add(bestTime);
		*/
		
		levelCount = new FlxText(0, 2, 100);
		levelCount.setFormat(AssetPaths.Unlock__ttf);
		levelCount.size = 20;
		levelCount.screenCenter(X);
		levelCount.text = "Level " + Data.currLevel;
		add(levelCount);
		
		_hintText = new FlxText(0, FlxG.height - 25, -1);
		_hintText.setFormat(AssetPaths.Unlock__ttf);
		_hintText.size = 20;
		_hintText.color = FlxColor.BLACK;
		_hintText.text = "Press \"H\" for a hint!";
		add(_hintText);
		
		if (Data.useParticles) {
			
			_emitterCombine = new FlxEmitter(FlxG.width / 2, FlxG.height / 2, 20);
			_emitterCombine.lifespan.set(0.4, 0.8);
			_emitterCombine.launchAngle.set(-150, -30);
			_emitterCombine.acceleration.start.min.y = 200;
			_emitterCombine.acceleration.start.max.y = 300;
			_emitterCombine.acceleration.end.min.y = 400;
			_emitterCombine.acceleration.end.max.y = 500;
			_emitterCombine.makeParticles(4, 4, FlxColor.WHITE, 20);
			_emitterCombine.color.set(FlxColor.RED, FlxColor.PINK, FlxColor.BLUE, FlxColor.CYAN);
			add(_emitterCombine);
			
			_emitter = new FlxEmitter(FlxG.width / 2, FlxG.height / 2, 20);
			_emitter.scale.set(0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25);
			_emitter.lifespan.set(0.4, 0.8);
			_emitter.launchAngle.set(-150, -30);
			_emitter.acceleration.start.min.y = 200;
			_emitter.acceleration.start.max.y = 300;
			_emitter.acceleration.end.min.y = 400;
			_emitter.acceleration.end.max.y = 500;
			add(_emitter);
		}
		
		init();
	}

	override public function update(elapsed:Float):Void
	{
		
		if (Data.devTools) {
			if (FlxG.keys.justPressed.O) {
				updateLevel(-1);	
			}
			
			if (FlxG.keys.justPressed.P) {
				updateLevel(1);
			}
		}
		
		if (!recording && !replaying)
		{
			startRecording();
		}
		
		/**
		 * Notice that I add "&& recording", because recording will recording every input
		 * so R key for replay will also be recorded and be triggered at replaying
		 * Please pay attention to the inputs that are not supposed to be recorded
		 */
		if (FlxG.keys.justPressed.H && recording)
		{
			loadReplay();
		}
		
		if (FlxG.keys.justPressed.ESCAPE) {
			pauseMenu();
		}
		
		if (FlxG.keys.anyJustPressed([UP, LEFT, RIGHT, W, A, D, SPACE]) && !started) {
			started = true;
			Timer.start(9999999, null, 0);
		}
		if (started) {
			var num = Timer.elapsedTime;
			num = num * Math.pow(10, 2);
			num = Math.round(num) / Math.pow(10, 2);
			currTime.text = "Elapsed time: " + num;
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
		FlxG.overlap(_player, _enemy, failedEnemy);
		FlxG.overlap(_player, _spikes, failedSpike);
		FlxG.overlap(_player, _key, playerCollideKey);
		FlxG.overlap(_player, _dye, dyeBlock);
		FlxG.overlap(_player, _colorZone, blockColorZoneCollide);
		
		// Collisions for the blocks
		FlxG.collide(_mWalls, _player);
		FlxG.collide(_mWalls, _enemy);
		FlxG.collide(_player, _lock);
		FlxG.collide(_lock, _enemy);
	
		// When the player would fall off the map, this for loop
		// would keep getting called causing the death animation
		// to be called many times. This makes it so once a player
		// falls off, this stops getting run through
		if (!fellOffMap) {
			for (blocks in _player) {
				if (blocks.y > FlxG.height || blocks.x < -25 || blocks.x > FlxG.width) {

					FlxG.sound.load(AssetPaths.hurt__mp3, .25).play();
					
					fellOffMap = true;
					
					var x:Float;
					if (blocks.y > FlxG.height) {
						x = blocks.x;
					} else {
						x = (blocks.x < -25) ? 5 : FlxG.width - 5;
					}
					var y:Float = blocks.y;
					var color:FlxColor = blocks.thisColor == 0 ? orange : blue;
					blocks.destroy();
					spawnParticles(x, y - 10, color);
					resetLevel();
				}
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
			 // X + 3 is how much lenience we want to give players to run into the spikes, 3 on both sides
			 _spikes.add(new Spikes(x + 3, y + 18));
		 } else if (entityName == "lock") {
			 var color:Int = Std.parseInt(entityData.get("color"));
			 _lock.add(new Lock(x, y, color));
		 } else if (entityName == "key") {
			 var color:Int = Std.parseInt(entityData.get("color"));
			 _key.add(new Key(x, y, color));
		 } else if (entityName == "dye") {
			 var color:Int = Std.parseInt(entityData.get("color"));
			 _dye.add(new Dye(x, y + 22, color));
		 } else if (entityName == "colorZone") {
			 var color:Int = Std.parseInt(entityData.get("color"));
			 _colorZone.add(new ColorZone(x, y, color));
		 }
	}
	
	private function blocksCollide(Block1:Player, Block2:Player):Void {
		if (Block1.thisColor == Block2.thisColor) {
			// Do we have to load it each time? Could not get it working with doing this.
			//#if not flash
			_soundJoin = FlxG.sound.load(AssetPaths.combine__mp3, 0.20);
			_soundJoin.play(true);
			//#end
			

			
			var x:Float = (Block1.x + Block2.x) / 2 + 12.5;
			var y:Float = (Block1.y + Block2.y) / 2;
			Block1.destroy();
			Block2.destroy();
			spawnParticlesCombine(x, y);
			if (_player.countLiving() == 0) {
				Timer.cancel();
				updateCompletedLevel();
				var num = formatTime(Timer.elapsedTime);
				oldTime = Data.bestTimes[Data.currLevel];
				Data.bestTimes[Data.currLevel] = Math.min(num, Data.bestTimes[Data.currLevel]);
				
				if (Data.gameBeaten() && num < oldTime) {
					var totalTime:Float = 0;
					for (i in 0...(Data.amtLevels + 1)) {
						totalTime += Data.bestTimes[i];
					}
					FlxKongregate.submitStats("Fastest Time", formatTime(totalTime));
				}
				
				winScreen();
			}
		} else {
			if (Block1.exists && Block2.exists) { //0.611
				FlxObject.separate(Block1, Block2);
				Block1.setPosition(Block1.x, Math.ffloor(Block1.y) + 0.611);
				Block2.setPosition(Block2.x, Math.ffloor(Block2.y) + 0.611);
			}
		}
	}
	
	private function failedEnemy(?Block1:Player, ?Enemy:Player):Void {
		
		// sound
		FlxG.sound.load(AssetPaths.hurt__mp3, .25).play();
		
		var x:Float = Block1.x;
		var y:Float = Block1.y;
		var color:FlxColor = Block1.thisColor == 0 ? orange : blue;
		
		Block1.destroy();
		
		spawnParticles(x, y, color);
		
		if (!die) {
			die = true;
			resetLevel();
		}
	}
	
	private function failedSpike(?Block:Player, ?Spike:Spikes):Void {
		
		// sound
		FlxG.sound.load(AssetPaths.hurt__mp3, .25).play();
		
		var x:Float = Block.x + (Block.width / 2);
		var y:Float = Block.y + (Block.height / 2);
		var color:FlxColor = Block.thisColor == 0 ? orange : blue;
		Block.destroy();
		spawnParticles(x, y, color);
		
		
		if (!die) {
			die = true;
			resetLevel();
		}
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
	
	// custom collision for blocks and locks
	private function playerCollideLock(player:Player, lock:Lock):Void {
		FlxObject.separate(player, lock);
		// incase block is ontop of lock...
		if (!player.isTouching(FlxObject.DOWN) && !lock.isTouching(FlxObject.UP)) {
			if (player.x > lock.x) {
				player.x = player.x + 1.25;
			}
		}
	}
	
	// dye the block into corresponding color, only two colors for now
	private function dyeBlock(player:Player, dye:Dye):Void {
		if (dye.thisColor != player.thisColor) {
			if (dye.thisColor == 0) {
				player.animation.add("color_change", [player.reverse == 1 ? 0 : 1], 6, false);
				player.animation.play("color_change");
				player.thisColor -= 1;
			} else if (dye.thisColor == 1) {
				player.animation.add("color_change", [player.reverse == 1 ? 2 : 3], 6, false);
				player.animation.play("color_change");
				player.thisColor += 1;
			}
		}
	}
	
	private function blockColorZoneCollide(player:Player, colorZone:ColorZone) {
		if (player.thisColor != colorZone.thisColor) {
			FlxObject.separate(player, colorZone);
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
		Data.attempts = 1;
		FlxG.switchState(new PlayState());
	}
	
	private function formatTime(time:Float, ?numDecimals:Int=2):Float {
		time = time * Math.pow(10, numDecimals);
		time = Math.round(time) / Math.pow(10, numDecimals);
		return time;
	}
	
	private function winScreen() {
		
		stopMovement();
		var endLevelTimer:FlxTimer = new FlxTimer();

		if (Data.currLevel == Data.amtLevels) {
			endLevelTimer.start(1, winGameCallback, 1);
		} else {
			endLevelTimer.start(1, winScreenCallback, 1);
		}
	}
	
	// Don't call this
	private function winScreenCallback(timer:FlxTimer) {
		beatLevelPopup = new Popup_Simple(); //create the popup
		var header:String = oldTime < Timer.elapsedTime ? "Congratulations!" : "NEW RECORD!";
		beatLevelPopup.quickSetup(header, "You beat the level in " + formatTime(Timer.elapsedTime) + " seconds in " + Data.attempts + (Data.attempts == 1 ? " attempt." : " attempts.")
			+ "\nYour best time is " + (oldTime < Timer.elapsedTime ? "" : "now ") + formatTime(Data.bestTimes[Data.currLevel]) + " seconds.", ["Main Menu [M]", "Retry [R]", "Next Level [SPACE]"]);
		openSubState(beatLevelPopup);
	}
	
	private function winGameCallback(timer:FlxTimer) {
		
		var totalTime:Float = 0;
		var totalAttempts:Int = 0;
		
		for (i in 0...(Data.amtLevels + 1)) {
			totalTime += Data.bestTimes[i];
		}
		
		for (attempts in Data.amountPlayed) {
			totalAttempts += attempts;
		}
		
		
		beatLevelPopup = new Popup_WonGame(); //create the popup
		/*beatLevelPopup.quickSetup("You beat the game!", "Your combined best times was " + formatTime(totalTime) + " seconds.\n" +
								  "Your total attempts to beat the game was " + totalAttempts + ".\n\n" +
								  "Game made by: Add Gritman & Tony Quach\n" +
								  "Music made by: OurMusicBox & Mark Sparling\n" +
								  "Artwork made by: Kenney Vleugels\n\n" +
								  "Thank you for playing!"
								  , ["Main Menu [M]"]); */
		beatLevelPopup.quickSetup("You beat the game!", "Your combined best times was " + formatTime(totalTime) + " seconds in " + totalAttempts + " attempts.\n" +
						  "Game made by: Add Gritman & Tony Quach\n" +
						  "Music made by: OurMusicBox & Mark Sparling\n" +
						  "Artwork made by: Kenney Vleugels\n\n" +
						  "Thank you for playing!"
						  , ["Main Menu [M]"]);

		openSubState(beatLevelPopup);
	}
	
	// This is currently called in winScreen()
	private function updateCompletedLevel() {
		Data.completedLevel[Data.currLevel] = true;
		
		if (Data.currLevel + 1 <= Data.amtLevels) {
			Data.canPlayLevel[Data.currLevel + 1] = true;
		}
	}
	
	// Creates the pause menu, sets timer to inactive and Data.paused to true
	private function pauseMenu():Void {
		Data.paused = true;
		Timer.active = false;
		pauseMenuPopup = new Popup_Pause(); //create the popup
		pauseMenuPopup.quickSetup("Pause Menu", "", ["Main Menu [M]", "Retry [R]", "Resume [SPACE]"]);
		openSubState(pauseMenuPopup);
	}
	
	// Spawns particles at x, y
	private function spawnParticles(x:Float, y:Float, ?color:FlxColor = FlxColor.WHITE):Void {
		
		if (!Data.useParticles) {
			return;
		}
		
		_emitter.x = x;
		_emitter.y = y;
		//_emitter.color.set(color);
		if (color == orange) {
			_emitter.loadParticles(AssetPaths.orangeParticle__png, 20);
		} else {
			_emitter.loadParticles(AssetPaths.blueParticle__png, 20);
		}
		
		_emitter.start(true, 0.01, 0);
	}
	
	private function spawnParticlesCombine(x:Float, y:Float):Void {
		if (!Data.useParticles) {
			return;
		}
		_emitterCombine.x = x;
		_emitterCombine.y = y;
		_emitterCombine.start(true, 0.01, 0);
	}
	
	// Call when you want to reset the level, 0.5 sec delay
	private function resetLevel() {
		stopMovement();
		var endLevelTimer:FlxTimer = new FlxTimer();
		endLevelTimer.start(0.5, resetLevelCallback, 1);
	}
	
	// Don't call this
	private function resetLevelCallback(timer:FlxTimer):Void {
		Data.attempts++;
		FlxG.resetState();
	}
	
	// Makes it so all players and enemies can't move
	private function stopMovement():Void {
		for (player in _player) {
			if (player.exists) {
				player.movementAllowed = false;
				player.velocity.x = 0;
				player.acceleration.x = 0;
			}
		}
		for (enemy in _enemy) {
			if (enemy.exists) {
				enemy.movementAllowed = false;
				enemy.velocity.x = 0;
				enemy.acceleration.x = 0;
			}
		}
	}
	
	function loadReplay():Void 
	{
		replaying = true;
		recording = false;
		
		/**
		 * Here we get a string from stopRecoding()
		 * which records all the input during recording
		 * Then we load the save
		 */

		FlxG.vcr.stopRecording(false);
		/*
		var f = File.write("./test.txt");
		f.writeString(save);
		f.close();
		*/
		FlxG.vcr.loadReplay(Data.levelHints[Data.currLevel], new PlayState(), ["ANY", "MOUSE"], 0, startRecording);
	}
	
	function startRecording():Void 
	{
		recording = true;
		replaying = false;
		
		/**
		 * Note FlxG.recordReplay will restart the game or state
		 * This function will trigger a flag in FlxGame
		 * and let the internal FlxReplay to record input on every frame
		 */
		FlxG.vcr.startRecording(false);
	}

	function init():Void
	{
		if (recording) 
		{
			for (players in _player) {
				players.alpha = 1;
			}
			for (enemies in _enemy) {
				enemies.alpha = 1;
			}
		}
		else if (replaying) 
		{
			for (players in _player) {
				players.alpha = 0.5;
			}
			for (enemies in _enemy) {
				enemies.alpha = 0.5;
			}
		}
	}
	
	
	private function loadMap():Void {
		_mWalls = _map.loadTilemap(AssetPaths.tiles3__png, 25, 25, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		_mWalls.setTileProperties(3, FlxObject.ANY);
		_mWalls.setTileProperties(4, FlxObject.NONE);
		_mWalls.setTileProperties(5, FlxObject.NONE);
		_mWalls.setTileProperties(6, FlxObject.NONE);
		_mWalls.setTileProperties(7, FlxObject.NONE);
		_mWalls.setTileProperties(8, FlxObject.NONE);
		_mWalls.setTileProperties(9, FlxObject.NONE);
		_mWalls.setTileProperties(10, FlxObject.NONE);
		_mWalls.setTileProperties(11, FlxObject.ANY);
		_mWalls.setTileProperties(12, FlxObject.ANY);
		
		// These are the color zones
		// BLUE
		_mWalls.setTileProperties(13, FlxObject.NONE);
		_mWalls.setTileProperties(14, FlxObject.NONE);
		_mWalls.setTileProperties(15, FlxObject.NONE);
		_mWalls.setTileProperties(19, FlxObject.NONE);
		_mWalls.setTileProperties(33, FlxObject.NONE);
		_mWalls.setTileProperties(34, FlxObject.NONE);
		_mWalls.setTileProperties(35, FlxObject.NONE);
		_mWalls.setTileProperties(53, FlxObject.NONE);
		_mWalls.setTileProperties(54, FlxObject.NONE);
		_mWalls.setTileProperties(55, FlxObject.NONE);
		_mWalls.setTileProperties(73, FlxObject.NONE);
		_mWalls.setTileProperties(74, FlxObject.NONE);
		_mWalls.setTileProperties(75, FlxObject.NONE);
		_mWalls.setTileProperties(93, FlxObject.NONE);
		_mWalls.setTileProperties(94, FlxObject.NONE);
		_mWalls.setTileProperties(95, FlxObject.NONE);
		
		// ORANGE
		_mWalls.setTileProperties(16, FlxObject.NONE);
		_mWalls.setTileProperties(17, FlxObject.NONE);
		_mWalls.setTileProperties(18, FlxObject.NONE);
		_mWalls.setTileProperties(36, FlxObject.NONE);
		_mWalls.setTileProperties(37, FlxObject.NONE);
		_mWalls.setTileProperties(38, FlxObject.NONE);
		_mWalls.setTileProperties(39, FlxObject.NONE);
		_mWalls.setTileProperties(56, FlxObject.NONE);
		_mWalls.setTileProperties(57, FlxObject.NONE);
		_mWalls.setTileProperties(58, FlxObject.NONE);
		_mWalls.setTileProperties(76, FlxObject.NONE);
		_mWalls.setTileProperties(77, FlxObject.NONE);
		_mWalls.setTileProperties(78, FlxObject.NONE);
		_mWalls.setTileProperties(96, FlxObject.NONE);
		_mWalls.setTileProperties(97, FlxObject.NONE);
		_mWalls.setTileProperties(98, FlxObject.NONE);
		
		// TEXT
		_mWalls.setTileProperties(100, FlxObject.NONE);
		_mWalls.setTileProperties(101, FlxObject.NONE);
		_mWalls.setTileProperties(102, FlxObject.NONE);
		_mWalls.setTileProperties(103, FlxObject.NONE);
		_mWalls.setTileProperties(104, FlxObject.NONE);
		_mWalls.setTileProperties(105, FlxObject.NONE);
		_mWalls.setTileProperties(106, FlxObject.NONE);
		_mWalls.setTileProperties(107, FlxObject.NONE);
		_mWalls.setTileProperties(108, FlxObject.NONE);
		_mWalls.setTileProperties(109, FlxObject.NONE);
		_mWalls.setTileProperties(110, FlxObject.NONE);
		_mWalls.setTileProperties(111, FlxObject.NONE);
		_mWalls.setTileProperties(112, FlxObject.NONE);
		_mWalls.setTileProperties(113, FlxObject.NONE);
		_mWalls.setTileProperties(114, FlxObject.NONE);
		_mWalls.setTileProperties(115, FlxObject.NONE);
		_mWalls.setTileProperties(116, FlxObject.NONE);
		_mWalls.setTileProperties(117, FlxObject.NONE);
		_mWalls.setTileProperties(118, FlxObject.NONE);
		_mWalls.setTileProperties(119, FlxObject.NONE);
		
		_mWalls.setTileProperties(80, FlxObject.NONE);
		_mWalls.setTileProperties(81, FlxObject.NONE);
		_mWalls.setTileProperties(82, FlxObject.NONE);
		_mWalls.setTileProperties(83, FlxObject.NONE);
		_mWalls.setTileProperties(84, FlxObject.NONE);
		_mWalls.setTileProperties(85, FlxObject.NONE);
		_mWalls.setTileProperties(86, FlxObject.NONE);	
		
		add(_mWalls);
	}
}