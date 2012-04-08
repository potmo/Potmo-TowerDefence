package com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra
{
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.util.logger.Logger;

	public class DijkstraColorToDirectionConverter
	{
		public static const NO_DIRECTION_COLOR:uint = 0xFF000000;
		private static const LEFT_UP:uint = 0xFFFF0090;
		private static const CENTER_UP:uint = 0xFFFF0000;
		private static const RIGHT_UP:uint = 0xFFFF9000;
		private static const LEFT_MIDDLE:uint = 0xFF900000;
		private static const CENTER_MIDDLE:uint = NO_DIRECTION_COLOR;
		private static const RIGHT_MIDDLE:uint = 0xFFFFFF00;
		private static const LEFT_DOWN:uint = 0xFF0000FF;
		private static const CENTER_DOWN:uint = 0xFF009090;
		private static const RIGHT_DOWN:uint = 0xFF90FF00;

		private static const UNWALKABLE_MASK:uint = 0x55FFFFFF;


		public function DijkstraColorToDirectionConverter()
		{
		}


		private static function getDirectionToColorMatrix():Vector.<Vector.<uint>>
		{
			var colorWheel:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>( 3, true );
			colorWheel[ 0 ] = new Vector.<uint>( 3, true );
			colorWheel[ 1 ] = new Vector.<uint>( 3, true );
			colorWheel[ 2 ] = new Vector.<uint>( 3, true );

			colorWheel[ 0 ][ 0 ] = LEFT_UP;
			colorWheel[ 1 ][ 0 ] = CENTER_UP;
			colorWheel[ 2 ][ 0 ] = RIGHT_UP;

			colorWheel[ 0 ][ 1 ] = LEFT_MIDDLE;
			colorWheel[ 1 ][ 1 ] = CENTER_MIDDLE;
			colorWheel[ 2 ][ 1 ] = RIGHT_MIDDLE;

			colorWheel[ 0 ][ 2 ] = LEFT_DOWN;
			colorWheel[ 1 ][ 2 ] = CENTER_DOWN;
			colorWheel[ 2 ][ 2 ] = RIGHT_DOWN;
			return colorWheel;
		}


		public static function getColorFromDirection( xDir:int, yDir:int, walkable:Boolean ):uint
		{
			if ( !DijkstraMap.DIRECTION_COLOR_MATRIX )
			{
				DijkstraMap.DIRECTION_COLOR_MATRIX = getDirectionToColorMatrix();
			}

			var color:uint = DijkstraMap.DIRECTION_COLOR_MATRIX[ xDir ][ yDir ];

			if ( !walkable )
			{
				// mask the color with walkable or unwalkable
				color = color & UNWALKABLE_MASK;
			}

			return color;
		}


		public static function getForceFromColor( color:uint ):Force
		{
			// set upper bits to 1
			switch ( uint( color | 0xFF000000 ) )
			{
				case LEFT_UP:
					return new Force( -1, -1 );
				case CENTER_UP:
					return new Force( 0, -1 );
				case RIGHT_UP:
					return new Force( 1, -1 );
				case LEFT_MIDDLE:
					return new Force( -1, 0 );
				case RIGHT_MIDDLE:
					return new Force( 1, 0 );
				case LEFT_DOWN:
					return new Force( -1, 1 );
				case CENTER_DOWN:
					return new Force( 0, 1 );
				case RIGHT_DOWN:
					return new Force( 1, 1 );
				case NO_DIRECTION_COLOR:
				case CENTER_MIDDLE:
					return new Force( 0, 0 );
				default:
					//throw new Error( "color can not be converted: 0x" + color.toString( 16 ) + " : 0x" + uint( color | 0xFF000000 ).toString( 16 ) );
					Logger.error( "color can not be converted: 0x" + color.toString( 16 ) + " : 0x" + uint( color | 0xFF000000 ).toString( 16 ) );
					return new Force( 0, 0 );
			}
		}


		public static function isWalkable( color:uint ):Boolean
		{
			// mask away biggest and see if that us the unwalkable mask
			return !( ( color & 0xFF000000 | 0x00FFFFFF ) == UNWALKABLE_MASK );
		}

	}
}
