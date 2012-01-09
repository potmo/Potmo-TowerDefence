package com.potmo.tdm.visuals.map.tilemap.astar
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * This is a tiled map that knows the closest path from all walkable tiles to a specific tile
	 * It is easiest configured by giving it a AStarMap that it can calculate data from or a bitmap
	 * that is already populated with data
	 */
	public class AStarPathMap
	{

		private var _targetX:int;
		private var _targetY:int;
		private var _aStarMap:AStarMap;
		private var _data:Vector.<Vector.<AStarPathMapTile>>;
		private var _width:uint;
		private var _height:uint;


		public function AStarPathMap()
		{
		}


		public function loadFromAStarMap( aStarMap:AStarMap, targetX:int, targetY:int ):void
		{
			this._targetX = targetX;
			this._targetY = targetY;
			this._aStarMap = aStarMap;
			this._height = aStarMap.getHeight();
			this._width = aStarMap.getWidth();

			setupEmptyNulledMapData( aStarMap );

		}


		public function getDirection( fromTileX:uint, fromTileY:uint ):AStarPathMapTile
		{
			var tile:AStarPathMapTile = _data[ fromTileX ][ fromTileY ];

			// check if that tile has already been calculated
			if ( tile )
			{
				return tile;
			}

			generateDirectionsFrom( fromTileX, fromTileY );

			tile = _data[ fromTileX ][ fromTileY ];
			return tile;

		}


		private function generateDirectionsFrom( fromTileX:uint, fromTileY:uint ):void
		{
			//calculate the path for that tile
			var bestPath:AStarPath = _aStarMap.getBestPath( fromTileX, fromTileY, _targetX, _targetY );
			bestPath.data = bestPath.data.reverse();
			var l:int = bestPath.data.length;

			for ( var i:int = 0; i < l; i++ )
			{
				var aStarTile:AStarMapTile = bestPath.data[ i ];
				var x:int = aStarTile.x;
				var y:int = aStarTile.y;

				if ( _data[ x ][ y ] )
				{
					// this tile is already set so all tiles after it must already be that as well
					return;
				}

				// create a new tile
				var newTile:AStarPathMapTile = new AStarPathMapTile( x, y, aStarTile.getType() );

				// check if this is the last in the path
				if ( i + 1 >= l )
				{
					newTile.setDirection( 0, 0 );
				}
				else
				{
					// find the postion of the next tile
					var nextAStarTile:AStarMapTile = bestPath.data[ i + 1 ];
					var nextX:int = nextAStarTile.x;
					var nextY:int = nextAStarTile.y;

					// set the direction to the next tile
					newTile.setDirection( x - nextX, y - nextY );
				}

				_data[ x ][ y ] = newTile;
			}

		}


		private function setupEmptyNulledMapData( aStarMap:AStarMap ):void
		{
			var width:int = aStarMap.getWidth();
			var height:int = aStarMap.getHeight();

			_data = new Vector.<Vector.<AStarPathMapTile>>( width, true );

			for ( var x:int = 0; x < width; x++ )
			{
				_data[ x ] = new Vector.<AStarPathMapTile>( height, true );
			}

		}


		public function draw( canvas:BitmapData, horizontalTileSize:int, verticalTileSize:int ):void
		{

			canvas.lock();

			for ( var y:int = 0; y < _height; y++ )
			{
				for ( var x:int = 0; x < _width; x++ )
				{
					var tile:AStarPathMapTile = _data[ x ][ y ];
					var color:uint;

					if ( !tile )
					{
						color = 0xFFEEEEEE;
					}
					else
					{
						var xDir:int = tile.getDirectionX();
						var yDir:int = tile.getDirectionY();

						var c0:int = 127 + 127 * xDir;
						var c1:int = 127 + 127 * yDir;
						color = ( c0 << 16 ) | c1 | 0xFF000000;
					}
					canvas.fillRect( new Rectangle( x * horizontalTileSize, y * verticalTileSize, horizontalTileSize, verticalTileSize ), color );
				}
			}
			canvas.unlock();
		}

	}
}
