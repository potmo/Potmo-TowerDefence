package com.potmo.tdm.visuals.map.tilemap.astar
{
	import com.potmo.tdm.visuals.map.tilemap.MapTile;
	import com.potmo.tdm.visuals.map.tilemap.MapTileType;

	import flash.geom.Point;

	public class AStarPathMapTile extends MapTile
	{
		private var _next:AStarPathMapTile;
		private var _direction:Point;


		public function AStarPathMapTile( x:int, y:int, type:MapTileType )
		{
			super( x, y, type );
		}


		public function setDirection( direction:Point ):void
		{
			this._direction = direction;
		}


		public function getDirection():Point
		{
			return _direction;
		}


		public function isWalkable():Boolean
		{
			this._type.isWalkable();
		}

	}
}
