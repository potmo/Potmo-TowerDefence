package com.potmo.tdm.visuals.map.tilemap.forcefieldmap
{
	import com.potmo.tdm.visuals.map.tilemap.MapTile;
	import com.potmo.util.math.StrictMath;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	public class ForceFieldMap implements ITileForceFieldMap
	{

		protected var tiles:Vector.<Vector.<ForceFieldTile>>;

		protected var width:uint;
		protected var height:uint;


		public function ForceFieldMap()
		{
			tiles = new Vector.<Vector.<ForceFieldTile>>();
		}


		public function getCanvasSize( horizontalTileSize:int, verticalTileSize:int ):Rectangle
		{
			return new Rectangle( 0, 0, horizontalTileSize * width, verticalTileSize * height );

		}


		public function setMap( map:Vector.<Vector.<ForceFieldTile>> ):void
		{
			tiles = map;
			width = map.length;
			height = map[ 0 ].length;
		}


		public function draw( canvas:BitmapData, horizontalTileSize:int, verticalTileSize:int ):void
		{
			canvas.lock();

			for ( var x:int = 0; x < width; x++ )
			{
				for ( var y:int = 0; y < height; y++ )
				{

					if ( tiles[ x ][ y ] )
					{
						tiles[ x ][ y ].draw( canvas, horizontalTileSize, verticalTileSize );
					}

				}
			}

			canvas.unlock();
		}


		/**
		 * Get the force from the map at postion x,y (not tile)
		 */
		public function getForce( x:Number, y:Number ):Force
		{
			var tileForce:Force = getTileForce( x, y );

			return tileForce;
		}


		/**
		 * Calculate the force comming from the tile
		 */
		public function getTileForce( x:Number, y:Number ):Force
		{
			// force is calculated with a bilinear interpolation
			// this means that the force acting in the centre of a tile might
			// not be equal to the force acting on the edges depending on the
			// neighbouring tiles

			x -= 0.5;
			y -= 0.5;
			var xTrunc:int = x;
			var yTrunc:int = y;

			var x1:int = StrictMath.max( 0, StrictMath.min( xTrunc, width - 1 ) );
			var x2:int = StrictMath.max( 0, StrictMath.min( xTrunc + 1, width - 1 ) );
			var y1:int = StrictMath.max( 0, StrictMath.min( yTrunc, height - 1 ) );
			var y2:int = StrictMath.max( 0, StrictMath.min( yTrunc + 1, height - 1 ) );

			var xFrac:Number = x - xTrunc;
			var yFrac:Number = y - yTrunc;
			var xInvFrac:Number = 1.0 - xFrac;
			var yInvFrac:Number = 1.0 - yFrac;

			//solve x value
			var aX:Number = tiles[ x1 ][ y1 ].force.x;
			var bX:Number = tiles[ x2 ][ y1 ].force.x;
			var cX:Number = tiles[ x2 ][ y2 ].force.x;
			var dX:Number = tiles[ x1 ][ y2 ].force.x;

			var abX:Number = aX * xInvFrac + bX * xFrac;
			var dcX:Number = dX * xInvFrac + cX * xFrac;

			var abcdX:Number = abX * yInvFrac + dcX * yFrac;

			//solve y value
			var aY:Number = tiles[ x1 ][ y1 ].force.y;
			var bY:Number = tiles[ x2 ][ y1 ].force.y;
			var cY:Number = tiles[ x2 ][ y2 ].force.y;
			var dY:Number = tiles[ x1 ][ y2 ].force.y;

			var adY:Number = aY * yInvFrac + dY * yFrac;
			var bcY:Number = bY * yInvFrac + cY * yFrac;

			var abcdY:Number = adY * xInvFrac + bcY * xFrac;

			return new Force( abcdX, abcdY );
		}

	}
}
