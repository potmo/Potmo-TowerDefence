package com.potmo.tdm.visuals.map.tilemap.astar
{
	public class AStarPath
	{
		public var data:Vector.<AStarMapTile>;
		
		

		public function AStarPath()
		{
			
		}
		
		public static function makeEmptyPath():AStarPath
		{
			var path:AStarPath = new AStarPath();
			path.data = new Vector.<AStarMapTile>();
			return path;
		}
		
		/***
		 * Makes a path from one node to another
		 * It is reversed so the last index in this list is the first tile that the unit stands on
		 * the first index is the destination
		 **/
		public static function MakePath(n:AStarMapTile, start:AStarMapTile, pathCalculationNumber:uint, map:AStarMap):AStarPath
		{
			
			var path:AStarPath = new AStarPath();
			
			path.data = new Vector.<AStarMapTile>();
			while (n.getParent(pathCalculationNumber) != null) {
				path.data.push(n);
				n = n.getParent(pathCalculationNumber);
			}
			path.data.push(start);
			//data.reverse();
			
			return path;
		}
		
		public function clone():AStarPath
		{
			var path:AStarPath = AStarPath.makeEmptyPath();
			for each (var tile:AStarMapTile in this.data)
			{
				path.data.push(tile);
			}
			return path;
		}

	}
}