
package com.potmo.tdm.visuals.map.util
{
	import com.potmo.tdm.visuals.map.forcemap.MapTileType;
	import com.potmo.tdm.visuals.map.forcemap.TileMap;

	import flash.display.BitmapData;
	import flash.geom.Point;

	public class MapImageAnalyzer
	{

		private static const END_POINT_COLOR:uint = 0xFFFF0000;
		private static const BUILDING_POSITION_COLOR:uint = 0xFFFF00FF;
		private static const WALKABLE_COLOR_0:uint = 0xFF00FF00;
		private static const WALKABLE_COLOR_1:uint = END_POINT_COLOR;


		public function MapImageAnalyzer()
		{
		}


		/**
		 * Creates a map with walkable and non walkable tiles in depending on colors
		 */
		public function createMap( mapDataImage:BitmapData, tileWidth:int, tileHeight:int ):TileMap
		{
			var output:TileMap = new TileMap();

			//start with a empty map
			output.loadEmptyMap( mapDataImage.width, mapDataImage.height );

			// go thru all the pixels to determine if the pixel/tile is walkable
			for ( var x:int = 0; x < mapDataImage.width; x++ )
			{
				for ( var y:int = 0; y < mapDataImage.height; y++ )
				{
					var color:uint = mapDataImage.getPixel32( x, y );

					// check if the tile is walkable and otherwise set it to unwalkable
					if ( color != WALKABLE_COLOR_0 && color != WALKABLE_COLOR_1 )
					{
						output.setTypeAt( x, y, MapTileType.DEFAULT_UNWALKABLE_TILE );
					}
					else
					{
						continue;
					}
				}
			}

			return output;

		}


		/**
		 * Finds all startpoints in the map
		 * The rightmost point is player0's endpoint and the leftmost is player1's endpoint
		 * all full red (0xFFFF000) plus shape (like swiz flag) is considered a endpoint
		 * @returns two points containing the endpoints for the players in real map coordinates
		 * @throws Error if not exactly two points found
		 */
		public function getEndPoints( referenceMapImage:BitmapData, mapScale:Number ):Vector.<Point>
		{
			var output:Vector.<Point> = getPlusShapePositionsScaled( referenceMapImage, mapScale, END_POINT_COLOR );
			output.sort( rightToLeftComparator );

			if ( output.length != 2 )
			{
				throw new Error( "There are not exactly two enpoints: " + output.join() );
			}

			return output;

		}


		/**
		 * Finds all the buildingpositions in the map
		 * The leftmost half of the buildings is player0's and the rest is player1's
		 * a full purple (0xFFFF00FF) plus shape (like swiz flag) is considered a building position
		 * @returns two dimensional list of building postitions
		 * @throws Error if the number of building positions is odd
		 */
		public function getBuildingPositions( referenceMapImage:BitmapData, mapScale:Number ):Vector.<Vector.<Point>>
		{
			var preoutput:Vector.<Point> = getPlusShapePositionsScaled( referenceMapImage, mapScale, BUILDING_POSITION_COLOR );
			preoutput.sort( leftToRightComparator );

			if ( preoutput.length % 2 != 0 )
			{
				throw new Error( "There are not equal amount of building positions: " + preoutput.join() );
			}

			// cut in half
			var output:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
			output.push( preoutput.splice( 0, preoutput.length / 2 ) ); // remove the first half and add it to output
			output.push( preoutput ); // add the rest
			return output;
		}


		/**
		 * sort vector left to right
		 **/
		private function leftToRightComparator( a:Point, b:Point ):int
		{
			return a.x - b.x;
		}


		/**
		 * sort vector right to left
		 **/
		private function rightToLeftComparator( a:Point, b:Point ):int
		{
			return b.x - a.x;
		}


		/**
		 * Find all plus shapes of a color and scale it by mapscale
		 */
		private function getPlusShapePositionsScaled( referenceMapImage:BitmapData, mapScale:Number, color:uint ):Vector.<Point>
		{
			var output:Vector.<Point> = new Vector.<Point>();

			var w:int = referenceMapImage.width;
			var h:int = referenceMapImage.height;

			// pull out a list of all the pixels for faster access
			var pixels:Vector.<uint> = referenceMapImage.getVector( referenceMapImage.rect );

			// find all the endpoints bu traversing the list
			for ( var x:int = 1; x < w - 1; x++ )
			{
				for ( var y:int = 0; y < h - 2; y++ )
				{

					// check if we have found a cross

					if ( pixels[ y * w + x ] ) // up middle
					{
						if ( pixels[ ( y + 1 ) * w + ( x - 1 ) ] == color ) // center left
						{
							if ( pixels[ ( y + 1 ) * w + x ] == color ) // center middle
							{
								if ( pixels[ ( y + 1 ) * w + ( x + 1 ) ] == color ) // center right
								{
									if ( pixels[ ( y + 2 ) * w + x ] == color ) // down moddle
									{
										output.push( new Point( x * mapScale, y * mapScale ) );
									}
								}
							}
						}
					}
				}
			}

			return output;
		}

	}
}
