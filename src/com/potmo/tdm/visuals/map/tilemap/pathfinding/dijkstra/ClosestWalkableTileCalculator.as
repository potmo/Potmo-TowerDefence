package com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra
{
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	public class ClosestWalkableTileCalculator
	{

		private var _data:Vector.<Vector.<DijkstraMapTile>>;
		private var _width:int;
		private var _height:int;

		private var bestTile:DijkstraMapTile;
		private var bestCost:Number;
		private var bestDistanceSquared:Number;


		public function ClosestWalkableTileCalculator( data:Vector.<Vector.<DijkstraMapTile>> )
		{
			_data = data;
			_width = _data.length;
			_height = _data[ 0 ].length;
		}


		public function addPathsFromUnwalkableTilesToNearestWalkableTiles():void
		{
			for ( var x:int = 0; x < _width; x++ )
			{
				for ( var y:int = 0; y < _height; y++ )
				{
					if ( !_data[ x ][ y ].getType().isWalkable() )
					{
						var closest:DijkstraMapTile = this.getClosestWalkableTile( x, y );

						if ( closest )
						{

							/*	if ( isInsideGrid( x - 1, y ) )
							   {
							   _data[ x ][ y ].bestPredessesor = _data[ x - 1 ][ y ];
							   }*/

							// get all the tiles in a line between them
							/*var tilesBetween:Vector.<DijkstraMapTile> = getTilesBetweenTiles( x, y, closest.x, closest.y );
							   var l:int = tilesBetween.length;

							   for ( var i:int = 0; i < l - 1; i++ )
							   {
							   if ( !tilesBetween[ i ].bestPredessesor )
							   {
							   tilesBetween[ i ].bestPredessesor = tilesBetween[ i + 1 ];
							   }
							   }*/

							var dx:Number = closest.x - x;
							var dy:Number = closest.y - y;
							var dist:Number = StrictMath.getDist( 0, 0, dx, dy );
							dx /= dist;
							dy /= dist;
							var tx:int = StrictMath.round( x + dx );
							var ty:int = StrictMath.round( y + dy );

							if ( isInsideGrid( tx, ty ) )
							{
								_data[ x ][ y ].bestPredessesor = _data[ tx ][ ty ];
							}

						}
						else
						{
							Logger.error( "Could not find best path" );
						}
					}
				}
			}

		}


		private function getTilesBetweenTiles( x:uint, y:uint, x2:uint, y2:uint ):Vector.<DijkstraMapTile>
		{
			var out:Vector.<DijkstraMapTile> = new Vector.<DijkstraMapTile>();

			// use Po-Han Lin's extemely fast line algorithm

			var shortLen:int = y2 - y;
			var longLen:int = x2 - x;

			if ( ( shortLen ^ ( shortLen >> 31 ) ) - ( shortLen >> 31 ) > ( longLen ^ ( longLen >> 31 ) ) - ( longLen >> 31 ) )
			{
				shortLen ^= longLen;
				longLen ^= shortLen;
				shortLen ^= longLen;

				var yLonger:Boolean = true;
			}
			else
			{
				yLonger = false;
			}

			var inc:int = longLen < 0 ? -1 : 1;

			var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;

			var tx:int;
			var ty:int;

			if ( yLonger )
			{
				for ( var i:int = 0; i != longLen + 1; i += inc )
				{

					tx = x + i * multDiff;
					ty = y + i;

					if ( isInsideGrid( tx, ty ) )
					{
						out.push( _data[ tx ][ ty ] );
					}
				}
			}
			else
			{
				for ( i = 0; i != longLen + 1; i += inc )
				{

					tx = x + i;
					ty = y + i * multDiff;

					if ( isInsideGrid( tx, ty ) )
					{
						out.push( _data[ tx ][ ty ] );
					}
				}
			}

			return out;
		}


		private function getClosestWalkableTile( x:int, y:int ):DijkstraMapTile
		{
			var best:DijkstraMapTile;

			for ( var radius:int = 1; radius < _height; radius++ )
			{
				best = getWalkableTileOnCircleWithLowestCost( x, y, radius );

				if ( best )
				{
					return best;
				}
			}

			return null;
		}


		private function getWalkableTileOnCircleWithLowestCost( x0:int, y0:int, radius:int ):DijkstraMapTile
		{

			bestDistanceSquared = Number.POSITIVE_INFINITY;
			bestCost = Number.POSITIVE_INFINITY;
			bestTile = null;

			// use bresenhams circle drawing algorithm
			var f:int = 1 - radius;
			var ddF_x:int = 1;
			var ddF_y:int = -2 * radius;
			var x:int = 0;
			var y:int = radius;

			// first test the vertical and horizontal
			updateBestIfBest( x0, y0, x0, y0 + radius );
			updateBestIfBest( x0, y0, x0, y0 - radius );
			updateBestIfBest( x0, y0, x0 + radius, y0 );
			updateBestIfBest( x0, y0, x0 - radius, y0 );

			while ( x < y )
			{
				// ddF_x == 2 * x + 1;
				// ddF_y == -2 * y;
				// f == x*x + y*y - radius*radius + 2*x - y + 1;
				if ( f >= 0 )
				{
					y--;
					ddF_y += 2;
					f += ddF_y;
				}
				x++;
				ddF_x += 2;
				f += ddF_x;

				updateBestIfBest( x0, y0, x0 + x, y0 + y );
				updateBestIfBest( x0, y0, x0 - x, y0 + y );
				updateBestIfBest( x0, y0, x0 + x, y0 - y );
				updateBestIfBest( x0, y0, x0 - x, y0 - y );
				updateBestIfBest( x0, y0, x0 + y, y0 + x );
				updateBestIfBest( x0, y0, x0 - y, y0 + x );
				updateBestIfBest( x0, y0, x0 + y, y0 - x );
				updateBestIfBest( x0, y0, x0 - y, y0 - x );
			}

			return bestTile;

		}


		private function updateBestIfBest( x0:int, y0:int, tx:int, ty:int ):void
		{
			if ( isInsideGrid( tx, ty ) && isTileWalkable( tx, ty ) )
			{
				var dist:Number = StrictMath.distSquared( x0, y0, tx, ty );

				if ( dist < bestDistanceSquared )
				{
					bestCost = _data[ tx ][ ty ].bestTotalCost;
					bestDistanceSquared = dist;
					bestTile = _data[ tx ][ ty ];
				}
				else if ( dist == bestDistanceSquared )
				{
					var cost:Number = _data[ tx ][ ty ].bestTotalCost;

					if ( cost < bestCost )
					{
						bestCost = _data[ tx ][ ty ].bestTotalCost;
						bestDistanceSquared = dist;
						bestTile = _data[ tx ][ ty ];
					}
				}
			}
		}


		private function isInsideGrid( x:int, y:int ):Boolean
		{
			if ( x < 0 || x >= _width )
			{
				return false;
			}

			if ( y < 0 || y >= _height )
			{
				return false;
			}

			return true;
		}


		private function isTileWalkable( x:int, y:int ):Boolean
		{
			return _data[ x ][ y ].getType().isWalkable();
		}

	}
}
