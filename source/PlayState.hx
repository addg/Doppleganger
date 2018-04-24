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
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	
	override public function create():Void
	{
		_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles2__png, 25, 25, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
		_player = new FlxTypedGroup<Player>();
		add(_player);
		_map.loadEntities(placeEntities, "entities");
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.R) {
			reset();
		}
		super.update(elapsed);
		FlxG.collide(_mWalls, _player);
		FlxG.overlap(_player, _player, joined);
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		 var x:Int = Std.parseInt(entityData.get("x"));
		 var y:Int = Std.parseInt(entityData.get("y"));
		 if (entityName == "player")
		 {
			var normal:Int = Std.parseInt(entityData.get("normal"));
			if (normal == 1) {
				_player.add(new Player(x, y, 1));
			} else {
				_player.add(new Player(x, y, -1));
			}
		 }
	}
	
	private function joined(Block1:Player, Block2:Player):Void {
		Block1.kill();
		Block2.kill();
	}
	
	private function reset():Void {
		for (blocks in _player) {
			blocks.destroy();
		}
		_map.loadEntities(placeEntities, "entities");
	}
}