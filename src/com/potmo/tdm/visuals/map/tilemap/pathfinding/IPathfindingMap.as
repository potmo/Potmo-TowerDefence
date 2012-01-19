package com.potmo.tdm.visuals.map.tilemap.pathfinding
{
	import com.potmo.tdm.visuals.map.tilemap.IMapTile;

	public interface IPathfindingMap
	{
		function getWidth():uint;
		function getHeight():uint;
		function getBestPath( x:int, y:int, targetX:int, _targetY:int ):PathFindingPath;
		function getNodeAt( x:int, y:int ):IMapTile;
	}
}
