package com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra.precalculated
{
	import com.potmo.tdm.visuals.map.tilemap.IMapTile;
	import com.potmo.tdm.visuals.map.tilemap.MapTileType;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.IForceFieldMap;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.IPathfindingMap;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.PathFindingPath;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra.DijkstraColorToDirectionConverter;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra.DijkstraMap;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;

	public class DijkstraPrecalculatedMap implements IPathfindingMap, IForceFieldMap
	{
		private var _width:int = 0;
		private var _height:int = 0;

		private var _data:Vector.<Vector.<DijkstraPrecalculatedMapTile>>;


		public function DijkstraPrecalculatedMap()
		{
		}


		public function getPathForce( x:Number, y:Number ):Force
		{
			// comment this in if you like fast non bilinear interpolation
			/*		x = StrictMath.floor( x );
			   y = StrictMath.floor( y );
			   var tile:DijkstraPrecalculatedMapTile = _data[ x ][ y ];

			   return new Force( tile.getDirectionX(), tile.getDirectionY() );*/

			// force is calculated with a bilinear interpolation
			// this means that the force acting in the centre of a tile might
			// not be equal to the force acting on the edges depending on the
			// neighbouring tiles

			x -= 0.5;
			y -= 0.5;
			var xTrunc:int = x;
			var yTrunc:int = y;

			var x1:int = StrictMath.max( 0, StrictMath.min( xTrunc, _width - 1 ) );
			var x2:int = StrictMath.max( 0, StrictMath.min( xTrunc + 1, _width - 1 ) );
			var y1:int = StrictMath.max( 0, StrictMath.min( yTrunc, _height - 1 ) );
			var y2:int = StrictMath.max( 0, StrictMath.min( yTrunc + 1, _height - 1 ) );

			var xFrac:Number = x - xTrunc;
			var yFrac:Number = y - yTrunc;
			var xInvFrac:Number = 1.0 - xFrac;
			var yInvFrac:Number = 1.0 - yFrac;

			//solve x value
			var aX:Number = _data[ x1 ][ y1 ].getDirectionX();
			var bX:Number = _data[ x2 ][ y1 ].getDirectionX();
			var cX:Number = _data[ x2 ][ y2 ].getDirectionX();
			var dX:Number = _data[ x1 ][ y2 ].getDirectionX();

			var abX:Number = aX * xInvFrac + bX * xFrac;
			var dcX:Number = dX * xInvFrac + cX * xFrac;

			var abcdX:Number = abX * yInvFrac + dcX * yFrac;

			//solve y value
			var aY:Number = _data[ x1 ][ y1 ].getDirectionY();
			var bY:Number = _data[ x2 ][ y1 ].getDirectionY();
			var cY:Number = _data[ x2 ][ y2 ].getDirectionY();
			var dY:Number = _data[ x1 ][ y2 ].getDirectionY();

			var adY:Number = aY * yInvFrac + dY * yFrac;
			var bcY:Number = bY * yInvFrac + cY * yFrac;

			var abcdY:Number = adY * xInvFrac + bcY * xFrac;

			return new Force( abcdX, abcdY );
		}


		public function getUnwalkableAreaForce( x:Number, y:Number ):Force
		{
			// force is calculated with a bilinear interpolation
			// this means that the force acting in the centre of a tile might
			// not be equal to the force acting on the edges depending on the
			// neighbouring tiles

			x -= 0.5;
			y -= 0.5;
			var xTrunc:int = x;
			var yTrunc:int = y;

			var x1:int = StrictMath.max( 0, StrictMath.min( xTrunc, _width - 1 ) );
			var x2:int = StrictMath.max( 0, StrictMath.min( xTrunc + 1, _width - 1 ) );
			var y1:int = StrictMath.max( 0, StrictMath.min( yTrunc, _height - 1 ) );
			var y2:int = StrictMath.max( 0, StrictMath.min( yTrunc + 1, _height - 1 ) );

			var xFrac:Number = x - xTrunc;
			var yFrac:Number = y - yTrunc;
			var xInvFrac:Number = 1.0 - xFrac;
			var yInvFrac:Number = 1.0 - yFrac;

			//solve x value
			//walkable tiles do not provide force
			var aX:Number = _data[ x1 ][ y1 ].getType().isWalkable() ? 0 : _data[ x1 ][ y1 ].getDirectionX();
			var bX:Number = _data[ x2 ][ y1 ].getType().isWalkable() ? 0 : _data[ x2 ][ y1 ].getDirectionX();
			var cX:Number = _data[ x2 ][ y2 ].getType().isWalkable() ? 0 : _data[ x2 ][ y2 ].getDirectionX();
			var dX:Number = _data[ x1 ][ y2 ].getType().isWalkable() ? 0 : _data[ x1 ][ y2 ].getDirectionX();

			var abX:Number = aX * xInvFrac + bX * xFrac;
			var dcX:Number = dX * xInvFrac + cX * xFrac;

			var abcdX:Number = abX * yInvFrac + dcX * yFrac;

			//solve y value
			var aY:Number = _data[ x1 ][ y1 ].getType().isWalkable() ? 0 : _data[ x1 ][ y1 ].getDirectionY();
			var bY:Number = _data[ x2 ][ y1 ].getType().isWalkable() ? 0 : _data[ x2 ][ y1 ].getDirectionY();
			var cY:Number = _data[ x2 ][ y2 ].getType().isWalkable() ? 0 : _data[ x2 ][ y2 ].getDirectionY();
			var dY:Number = _data[ x1 ][ y2 ].getType().isWalkable() ? 0 : _data[ x1 ][ y2 ].getDirectionY();

			var adY:Number = aY * yInvFrac + dY * yFrac;
			var bcY:Number = bY * yInvFrac + cY * yFrac;

			var abcdY:Number = adY * xInvFrac + bcY * xFrac;

			return new Force( abcdX, abcdY );
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
