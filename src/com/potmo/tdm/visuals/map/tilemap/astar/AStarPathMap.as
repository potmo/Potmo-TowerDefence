package com.potmo.tdm.visuals.map.tilemap.astar
{
	import flash.geom.Point;

	/**
	 * This is a tiled map that knows the closest path from all walkable tiles to a specific tile
	 * It is easiest configured by giving it a AStarMap that it can calculate data from or a bitmap
	 * that is already populated with data
	 */
	public class AStarPathMap
	{

		private var targetX:int;
		private var targetY:int;
		private var aStarMap:AStarMap;
		private var data:Vector.<Vector.<AStarPathMapTile>>;


		public function AStarPathMap()
		{
		}


		public function loadFromAStarMap( aStarMap:AStarMap, targetX:int, targetY:int ):void
		{
			this.targetX = targetX;
			this.targetY = targetY;
			this.aStarMap = aStarMap;

			setupEmptyNulledMapData( aStarMap );
			
		}

		public function getDirection(fromTileX:uint, fromTileY:uint):Point
		{
			var tile:AStarPathMapTile = data[fromTileX][fromTileY];
			
			// check if that tile has already been calculated
			if (tile)
			{
				return tile.getDirection();
			}
			
			
			//calculate the path for that tile
			var bestPath:AStarPath = aStarMap.getBestPath(fromTileX, fromTileY, targetX, targetY);
			
			//TODO: Assign best path to data and return the direction. Stop if direction is already set at a tile
		}

		private function setupEmptyNulledMapData( aStarMap:AStarMap ):void
		{
			var width:int = aStarMap.getWidth();
			var height:int = aStarMap.getHeight();
			
			data = new Vector.<Vector.<AStarPathMapTile>>( width, true );
			for (var x:int = 0; x < width, x++)
			{
				data[x] = new Vector.<AStarPathMapTile>(height, true);
			}

		}

	}
}
