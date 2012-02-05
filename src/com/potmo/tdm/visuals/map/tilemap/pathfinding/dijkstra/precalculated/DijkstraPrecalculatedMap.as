package com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra.precalculated
{
	import com.potmo.tdm.visuals.map.tilemap.IMapTile;
	import com.potmo.tdm.visuals.map.tilemap.MapTileType;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.IPathfindingMap;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.PathFindingPath;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra.DijkstraColorToDirectionConverter;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra.DijkstraMap;

	import flash.display.BitmapData;

	public class DijkstraPrecalculatedMap implements IPathfindingMap
	{
		private var _width:int = 0;
		private var _height:int = 0;

		private var _data:Vector.<Vector.<DijkstraPrecalculatedMapTile>>;


		public function DijkstraPrecalculatedMap()
		{
		}


		public function setupFromImage( image:BitmapData ):void
		{
			_width = image.width;
			_height = image.height;

			_data = new Vector.<Vector.<DijkstraPrecalculatedMapTile>>( _width, true );

			for ( var x:int = 0; x < _width; x++ )
			{
				_data[ x ] = new Vector.<DijkstraPrecalculatedMapTile>( _height, true );

				for ( var y:int = 0; y < _height; y++ )
				{
					var tile:DijkstraPrecalculatedMapTile = new DijkstraPrecalculatedMapTile( x, y );
					_data[ x ][ y ] = tile;

					var color:uint = image.getPixel32( x, y );
					var force:Force = DijkstraColorToDirectionConverter.getForceFromColor( color );
					var walkable:Boolean = DijkstraColorToDirectionConverter.isWalkable( color );

					if ( walkable )
					{
						tile.setType( MapTileType.DEFAULT_WALKABLE_TILE );
					}
					else
					{
						tile.setType( MapTileType.DEFAULT_UNWALKABLE_TILE );
					}

					tile.setDirection( force.x, force.y );

				}
			}

		}


		public function setupFromDijkstraMap( map:DijkstraMap ):void
		{

		}


		public function getBestPath( startX:int, startY:int, targetX:int, targetY:int ):PathFindingPath
		{
			var out:PathFindingPath = new PathFindingPath();
			var x:int = startX;
			var y:int = startY;

			if ( startX == targetX && startY == targetY )
			{
				return out;
			}
			var tile:DijkstraPrecalculatedMapTile;
			var xDir:int = 0;
			var yDir:int = 0;

			do
			{
				x += xDir;
				y += yDir;

				tile = _data[ x ][ y ];
				out.data.push( tile );

				xDir = tile.getDirectionX();
				yDir = tile.getDirectionY();
			}
			while ( !( x == targetX && y == targetY ) && !( xDir == 0 && yDir == 0 ) || ( x == startX && y == startY ) );

			return out;
		}


		public function getNodeAt( x:int, y:int ):IMapTile
		{
			return _data[ x ][ y ];
		}


		public function getWidth():uint
		{
			return _width;
		}


		public function getHeight():uint
		{
			return _height;
		}
	}
}
