package com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra.precalculated
{
	import com.potmo.tdm.visuals.map.tilemap.IMapTile;
	import com.potmo.tdm.visuals.map.tilemap.MapTileType;

	public class DijkstraPrecalculatedMapTile implements IMapTile
	{

		private var _x:int;
		private var _y:int;
		private var _xDir:int;
		private var _yDir:int;


		public function DijkstraPrecalculatedMapTile( x:int, y:int )
		{
			_x = x;
			_y = y;
		}


		internal function setDirection( xDir:int, yDir:int ):void
		{
			_xDir = xDir;
			_yDir = yDir;
		}


		public function getDirectionX():int
		{
			return _xDir;
		}


		public function getDirectionY():int
		{
			return _yDir;
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
			return MapTileType.DEFAULT_WALKABLE_TILE;
		}


		public function setType( type:MapTileType ):void
		{
			// Nada
		}


		public function getHash():uint
		{
			return 0xBADF00D;
		}
	}
}
