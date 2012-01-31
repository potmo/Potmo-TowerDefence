package com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra
{
	import com.potmo.tdm.visuals.map.tilemap.IMapTile;
	import com.potmo.tdm.visuals.map.tilemap.MapTile;
	import com.potmo.tdm.visuals.map.tilemap.TileMap;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.IPathfindingMap;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.PathFindingPath;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class DijkstraMap implements IPathfindingMap
	{
		private static const SQRT2:Number = 1.41421356; // sqrt(2.0)

		private var _data:Vector.<Vector.<DijkstraMapTile>>;
		private var _width:int;
		private var _height:int;
		private var calculatedTargetX:int;
		private var calculatedTargetY:int;


		public function DijkstraMap()
		{
		}


		public function getCanvasSize( horizontalTileSize:int, verticalTileSize:int ):Rectangle
		{
			return new Rectangle( 0, 0, horizontalTileSize * _width, verticalTileSize * _height );

		}


		public function getBestPath( x:int, y:int, targetX:int, targetY:int ):PathFindingPath
		{
			if ( targetX != calculatedTargetX || targetY != calculatedTargetY )
			{
				throw new Error( "Have not calculated paths to: " + targetX + ", " + targetY + " not to: " + calculatedTargetX + ", " + calculatedTargetY );
			}

			var path:PathFindingPath = new PathFindingPath();
			var tile:DijkstraMapTile = _data[ x ][ y ];

			while ( tile.bestPredessesor )
			{
				path.data.push( tile );
				tile = tile.bestPredessesor;
			}

			path.data.reverse();

			return path;
		}


		/**
		 * Calculate the shortest paths from the tile to all other tiles
		 * keep the result internally
		 */
		public function buildShortestPathToPoint( x:int, y:int ):void
		{
			this.calculatedTargetX = x;
			this.calculatedTargetY = y;

			var unsettled:Vector.<DijkstraMapTile> = new Vector.<DijkstraMapTile>();

			// add the first tile to start with
			var startTile:DijkstraMapTile = _data[ x ][ y ];
			startTile.bestTotalCost = 0; // the total cost to the first tile is zero
			unsettled.push( startTile );

			// keep going until all tiles are settled
			while ( unsettled.length > 0 )
			{
				var current:DijkstraMapTile = extractMinimum( unsettled );
				current.isSettled = true;
				relaxNeighbours( current, unsettled );
			}

		}


		/**
		 * Calculate, for each unwalkable tile, the force to the closest walkable tile
		 * keep the results internally without removing previous calculations.
		 * If more than one with equal distance is found then use the one with lowest
		 * path cost
		 */
		public function buildPathsFromUnwalkableTilesToNearestWalkableTile():void
		{
			var closestWalkableTileCalculator:ClosestWalkableTileCalculator = new ClosestWalkableTileCalculator( _data );

			closestWalkableTileCalculator.addPathsFromUnwalkableTilesToNearestWalkableTiles();

		}


		/**
		 * Find all unsettled neighbours and relax them (i.e get the best path to them)
		 * If there is a new best path to them then add them to unsettled and sort it acending by bestTotalCost
		 */
		private function relaxNeighbours( current:DijkstraMapTile, unsettled:Vector.<DijkstraMapTile> ):void
		{
			// remember when we have added to the unsettled list so we can sort it only when we need to
			var updatedUnsettled:Boolean = false;

			for each ( var neightbour:DijkstraMapTile in current.neighbors )
			{
				// do not care about settled neightbours
				if ( neightbour.isSettled )
				{
					continue;
				}

				// check if we have found a better path to this one and in that case update it with the better path
				var movingCost:Number = getDiagonalOrStraightMovingCost( current, neightbour ); //TODO: Can multiplay with the cost for the tile here
				var testNewTotalCost:Number = current.bestTotalCost + movingCost;

				if ( neightbour.bestTotalCost > testNewTotalCost )
				{
					neightbour.bestTotalCost = testNewTotalCost;
					neightbour.bestPredessesor = current;
					unsettled.push( neightbour );
					updatedUnsettled = true;
				}
			}

			// if we have added to the unsettled then we need to sort it ascending (biggest last) 
			if ( updatedUnsettled )
			{
				unsettled.sort( sortAscendingByBestTotalCostComparatorFunction );
			}

		}


		private function sortAscendingByBestTotalCostComparatorFunction( a:DijkstraMapTile, b:DijkstraMapTile ):int
		{
			return b.bestTotalCost - a.bestTotalCost;
		}


		/**
		 * Find the tile in the list that has the lowest total cost
		 */
		private function extractMinimum( unsettled:Vector.<DijkstraMapTile> ):DijkstraMapTile
		{
			// we keep the highest in the end of the list. It is sorted acending
			return unsettled.pop();
		}


		/**
		 * Calculates the distance of one step. Diagonal or straight
		 * This does only return the correct answer as long as both tiles touch eachother
		 */
		private function getDiagonalOrStraightMovingCost( tileA:DijkstraMapTile, tileB:DijkstraMapTile ):Number
		{
			var ax:int = tileA.x;
			var ay:int = tileA.y;

			var bx:int = tileB.x;
			var by:int = tileB.y;

			// same tile
			if ( ax == bx && ay == by )
			{
				return 0;
			}

			// is it diagonal
			if ( ax != bx && ay != by )
			{
				return SQRT2;
			}

			// it is straight
			return 1;

		}


		public function loadFromMap( map:TileMap ):void
		{
			_width = map.getWidth();
			_height = map.getHeight();

			// init empty array
			this._data = new Vector.<Vector.<DijkstraMapTile>>( _width, true );

			for ( var i:int = 0; i < _width; i++ )
			{
				this._data[ i ] = new Vector.<DijkstraMapTile>( _height, true );
			}

			// fill the array with data
			for ( var x:int = 0; x < _width; x++ )
			{
				for ( var y:int = 0; y < _height; y++ )
				{

					var tile:MapTile = map.getAt( x, y );

					_data[ x ][ y ] = DijkstraMapTile.fromMapTile( tile );

				}
			}

			initializeNeighbours();

		}


		/***
		 * Setup all nodes and connect it to the proper neighbors
		 */
		public function initializeNeighbours():void
		{
			for ( var x:int = 0; x < _width; x++ )
			{
				for ( var y:int = 0; y < _height; y++ )
				{
					if ( this._data[ x ][ y ].walkable )
					{
						this._data[ x ][ y ].neighbors = this.getNeighbors( this._data[ x ][ y ] );
					}
				}
			}
		}


		/***
		 * Get all neighbors to a tile that the tile can be conencted to
		 * That is all tile one step from the tile in all directions as long as the tile connection does not cut corners of non walkable tiles
		 */
		private function getNeighbors( tile:DijkstraMapTile ):Vector.<DijkstraMapTile>
		{

			var x:int = tile.x;
			var y:int = tile.y;

			var neighbors:Vector.<DijkstraMapTile> = new Vector.<DijkstraMapTile>();

			var n:DijkstraMapTile;

			if ( x > 0 )
			{
				n = _data[ x - 1 ][ y ];

				if ( n.walkable )
				{
					neighbors.push( n );
				}
			}

			if ( y > 0 )
			{

				n = _data[ x ][ y - 1 ];

				if ( n.walkable )
				{
					neighbors.push( n );
				}
			}

			if ( x < _width - 1 )
			{

				n = _data[ x + 1 ][ y ];

				if ( n.walkable )
				{
					neighbors.push( n );
				}
			}

			if ( y < _height - 1 )
			{

				n = _data[ x ][ y + 1 ];

				if ( n.walkable )
				{
					neighbors.push( n );
				}
			}

			// Diagonal, no cutting corners

			// NW
			if ( x > 0 && y > 0 )
			{
				n = _data[ x - 1 ][ y - 1 ];

				if ( n.walkable && _data[ x - 1 ][ y ].walkable && _data[ x ][ y - 1 ].walkable )
				{
					neighbors.push( n );
				}
			}

			// NE
			if ( x < _width - 1 && y > 0 )
			{
				n = _data[ x + 1 ][ y - 1 ];

				if ( n.walkable && _data[ x + 1 ][ y ].walkable && _data[ x ][ y - 1 ].walkable )
				{
					neighbors.push( n );
				}
			}

			// SW
			if ( x > 0 && y < _height - 1 )
			{
				n = _data[ x - 1 ][ y + 1 ];

				if ( n.walkable && _data[ x - 1 ][ y ].walkable && _data[ x ][ y + 1 ].walkable )
				{
					neighbors.push( n );
				}
			}

			// SE
			if ( x < _width - 1 && y < _height - 1 )
			{
				n = _data[ x + 1 ][ y + 1 ];

				if ( n.walkable && _data[ x + 1 ][ y ].walkable && _data[ x ][ y + 1 ].walkable )
				{
					neighbors.push( n );
				}
			}

			return neighbors;

		}


		/**
		 * Draw for debugging purposes
		 */
		public function draw( canvas:BitmapData, horizontalTileSize:int, verticalTileSize:int ):void
		{

			var colorWheel:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>( 3, true );
			colorWheel[ 0 ] = new Vector.<uint>( 3, true );
			colorWheel[ 1 ] = new Vector.<uint>( 3, true );
			colorWheel[ 2 ] = new Vector.<uint>( 3, true );

			colorWheel[ 0 ][ 0 ] = 0xFFFF0090;
			colorWheel[ 1 ][ 0 ] = 0xFFFF0000;
			colorWheel[ 2 ][ 0 ] = 0xFFFF9000;

			colorWheel[ 0 ][ 1 ] = 0xFF900000;
			colorWheel[ 1 ][ 1 ] = 0xFFFFFFFF;
			colorWheel[ 2 ][ 1 ] = 0xFFFFFF00;

			colorWheel[ 0 ][ 2 ] = 0xFF0000FF;
			colorWheel[ 1 ][ 2 ] = 0xFF009090;
			colorWheel[ 2 ][ 2 ] = 0xFF90FF00;

			canvas.lock();

			for ( var y:int = 0; y < _height; y++ )
			{
				for ( var x:int = 0; x < _width; x++ )
				{
					var tile:DijkstraMapTile = _data[ x ][ y ];
					var color:uint;

					if ( !tile.bestPredessesor )
					{
						color = 0xFF000000;
					}
					else
					{
						var xDir:int = tile.bestPredessesor.x - tile.x;
						var yDir:int = tile.bestPredessesor.y - tile.y;

						xDir = StrictMath.clamp( xDir, -1, 1 );
						yDir = StrictMath.clamp( yDir, -1, 1 );

						color = colorWheel[ 1 + xDir ][ 1 + yDir ];

						/*	var c0:int = 127 + 127 * xDir;
						   var c1:int = 127 + 127 * yDir;
						   color = ( c0 << 16 ) | c1 | 0xFF000000;*/
					}
					canvas.fillRect( new Rectangle( x * horizontalTileSize, y * verticalTileSize, horizontalTileSize, verticalTileSize ), color );
				}
			}
			canvas.unlock();
		}


		public function getWidth():uint
		{
			return _width;
		}


		public function getHeight():uint
		{
			return _height;
		}


		public function getNodeAt( x:int, y:int ):IMapTile
		{
			return _data[ x ][ y ];
		}
	}
}
