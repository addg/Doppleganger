package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	private var _player:FlxTypedGroup<Player>;
	private var _enemy:FlxTypedGroup<Player>;
	private var _spikes:FlxTypedGroup<Spikes>;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	
	override public function create():Void
	{
		// Change to your level here by editing this value
		//                                         |
		//                                         V
		_map = new FlxOgmoLoader(AssetPaths.room_004__oel);
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
		_map.loadEntities(placeEntities, "entities");
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.R) {
			FlxG.resetState();
		}
		super.update(elapsed);
		
		// Collisions for the blocks
		FlxG.collide(_mWalls, _player);
		FlxG.collide(_mWalls, _enemy);
	
		FlxG.overlap(_player, _player, joined);
		FlxG.overlap(_player, _enemy, failed);
		FlxG.overlap(_player, _spikes, failed);
		
		for (blocks in _player) {
			if (blocks.y > FlxG.height) {
				FlxG.resetState();
			}
		}
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		// currently 0,1 orange, 2,3 blue, 4,5 bad
		// normal determines whether its a reverse block or not
		 var x:Int = Std.parseInt(entityData.get("x"));
		 var y:Int = Std.parseInt(entityData.get("y"));
		 if (entityName == "player")
		 {
			// Creating an orange block
			// We probably want to name the other colored block or have an value to change here
			// Possibly var color:Int = Std.parseInt(entityData.get("color"));
			var normal:Int = Std.parseInt(entityData.get("normal"));
			if (normal == 1) {
				_player.add(new Player(x, y, 0));
			} else {
				_player.add(new Player(x, y, 1));
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
		 }
	}
	
	private function joined(Block1:Player, Block2:Player):Void {
		Block1.destroy();
		Block2.destroy();
	}
	
	private function failed(?Block1:Player, ?Block2:Player):Void {
		// Display message here and wait for them to click retry? Maybe instantly restart?
		FlxG.resetState();
	}
}