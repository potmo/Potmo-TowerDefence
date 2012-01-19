package com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra
{
	import com.potmo.tdm.visuals.map.tilemap.IMapTile;
	import com.potmo.tdm.visuals.map.tilemap.MapTile;
	import com.potmo.tdm.visuals.map.tilemap.MapTileType;

	public class DijkstraMapTile implements IMapTile
	{
		internal var neighbors:Vector.<DijkstraMapTile>;
		internal var ownCost:Number; // the cost to travel through this tile
		internal var walkable:Boolean;
		private var _x:int;
		private var _y:int;
		internal var bestTotalCost:Number; // the sum of the cost to the start of the search
		internal var bestPredessesor:DijkstraMapTile; // the previous tile in the best path to this tile right now
		internal var isSettled:Boolean; // if the best path to this tile is settled and needs no more investigation 
		private var type:MapTileType;


		public function DijkstraMapTile( x:int, y:int, type:MapTileType )
		{
			this.type = type;
			this._x = x;
			this._y = y;
			this.walkable = type.isWalkable();
			this.ownCost = type.getWalkCost();
			this.neighbors = new Vector.<DijkstraMapTile>();

			// initialize with infinity cost
			this.bestTotalCost = Number.POSITIVE_INFINITY;
			this.bestPredessesor = null;
			this.isSettled = false;
		}


		public static function fromMapTile( tile:MapTile ):DijkstraMapTile
		{

			var walkable:Boolean = tile.getType().isWalkable();
			var walkingCost:Number = tile.getType().getWalkCost();
			var type:MapTileType = tile.getType();
			return new DijkstraMapTile( tile.x, tile.y, type );
		}


		public function get x():int
		{
			return _x;
		}


		public function get y():int
		{
			return _y;
		}


		public function getType():MapTileType
		{
			return type;
		}


		public function setType( type:MapTileType ):void
		{
			this.type = type;
		}


		public function getHash():uint
		{
			return 0xBADF00D;
		}

	}
}
