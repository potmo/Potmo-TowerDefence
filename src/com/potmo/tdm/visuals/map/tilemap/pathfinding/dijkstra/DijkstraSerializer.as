package com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra
{
	import com.potmo.util.math.StrictMath;

	import flash.utils.ByteArray;

	public class DijkstraSerializer
	{

		private static const X_DIR_SIZE_MASK:uint = 0x00000001;
		private static const X_DIR_NEGATIVE_MASK:uint = 0x00000002;
		private static const Y_DIR_SIZE_MASK:uint = 0x00000004;
		private static const Y_DIR_NEGATIVE_MASK:uint = 0x00000008;
		private static const WALKABLE_MASK:uint = 0x00000010;


		public function DijkstraSerializer()
		{

		}


		/**
		 * @returns a byte value (8 low bits used only)
		 */
		public function getAsBinary( xDir:int, yDir:int, walkable:Boolean ):uint
		{
			var result:uint = 0x00000000;

			// check for not zero
			if ( xDir != 0 )
			{
				// add rightmost bit
				result |= X_DIR_SIZE_MASK;

				// check for negative
				if ( xDir < 0 )
				{
					// add second rightmost bit
					result |= X_DIR_NEGATIVE_MASK;
				}
			}

			// check for not zero
			if ( yDir != 0 )
			{
				// add rightmost bit
				result |= Y_DIR_SIZE_MASK;

				// check for negative
				if ( yDir < 0 )
				{
					// add second rightmost bit
					result |= Y_DIR_NEGATIVE_MASK;
				}
			}

			if ( walkable )
			{
				result |= WALKABLE_MASK;
			}

			return result;

		}


		public function getXFromByte( byte:uint ):int
		{
			var size:int = ( ( byte & X_DIR_SIZE_MASK ) == X_DIR_SIZE_MASK ) ? 1 : 0;
			var negative:Boolean = ( byte & X_DIR_NEGATIVE_MASK ) == X_DIR_NEGATIVE_MASK;

			if ( negative )
			{
				size = -size;
			}

			return size;
		}


		public function getYFromByte( byte:uint ):int
		{
			var size:int = ( ( byte & Y_DIR_SIZE_MASK ) == Y_DIR_SIZE_MASK ) ? 1 : 0;
			var negative:Boolean = ( byte & Y_DIR_NEGATIVE_MASK ) == Y_DIR_NEGATIVE_MASK;

			if ( negative )
			{
				size = -size;
			}

			return size;
		}


		public function getWalkableFromByte( byte:uint ):Boolean
		{
			return ( byte & WALKABLE_MASK ) == WALKABLE_MASK;
		}

	}
}
