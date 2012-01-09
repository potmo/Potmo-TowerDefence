package com.potmo.tdm.visuals.map.tilemap.astar
{
	import com.potmo.tdm.visuals.map.tilemap.MapTile;
	import com.potmo.tdm.visuals.map.tilemap.MapTileType;

	import flash.geom.Point;

	public class AStarPathMapTile extends MapTile
	{
		private var _next:AStarPathMapTile;
		private var _directionX:int;
		private var _directionY:int;


		public function AStarPathMapTile( x:int, y:int, type:MapTileType )
		{
			super( x, y, type );
		}


		public function setDirection( dirX:int, dirY:int ):void
		{
			this._directionX = dirX;
			this._directionY = dirY;
		}


		public function getDirectionX():int
		{
			return _directionX;
		}


		public function getDirectionY():int
		{
			return _directionY;
		}


		public function isWalkable():Boolean
		{
			return this._type.isWalkable();
		}

	}
}
