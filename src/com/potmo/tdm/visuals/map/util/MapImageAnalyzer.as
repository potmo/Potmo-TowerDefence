package com.potmo.tdm.visuals.map.util
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class MapImageAnalyzer
	{

		private static const END_POINT_COLOR:uint = 0xFFFF0000;
		private static const BUILDING_POSITION_COLOR:uint = 0xFFFF00FF;


		public function MapImageAnalyzer()
		{
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
			output.sort( leftToRightComparator );

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
