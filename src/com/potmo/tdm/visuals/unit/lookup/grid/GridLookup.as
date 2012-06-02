package com.potmo.tdm.visuals.unit.lookup.grid
{
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.util.math.StrictMath;

	public class GridLookup
	{

		// lookup is a threedimetional grid with x,y,units
		private var _lookup:Vector.<Vector.<Vector.<Unit>>>;
		private static const TILE_WIDTH:Number = 100;
		private static const TILE_HIGHT:Number = 100;
		private var _tilesHorizontal:uint;
		private var _tilesVertical:uint;

		private var _width:Number;
		private var _height:Number;


		public function GridLookup( width:Number, height:Number )
		{

			setup( width, height );

		}


		private function setup( width:Number, height:Number ):void
		{
			this._width = width;
			this._height = height;

			// each grid part is 100 times 100
			_tilesHorizontal = StrictMath.ceil( width / TILE_WIDTH );
			_tilesVertical = StrictMath.ceil( height / TILE_HIGHT );

			_lookup = new Vector.<Vector.<Vector.<Unit>>>( _tilesHorizontal, true );

			for ( var i:int = 0; i < _tilesHorizontal; i++ )
			{
				_lookup[ i ] = new Vector.<Vector.<Unit>>( _tilesVertical, true );

				for ( var j:int = 0; j < _tilesVertical; j++ )
				{
					_lookup[ i ][ j ] = new Vector.<Unit>( 0, false );
				}
			}
		}


		public function insert( unit:Unit ):void
		{
			var gridX:uint = getGridXFromX( unit.getOldX() );
			var gridY:uint = getGridYFromY( unit.getOldY() );

			insertToTile( unit, gridX, gridY );
		}


		private function insertToTile( unit:Unit, gridX:uint, gridY:uint ):void
		{
			_lookup[ gridX ][ gridY ].push( unit );

		}


		public function remove( unit:Unit ):void
		{
			var gridX:uint = getGridXFromX( unit.getOldX() );
			var gridY:uint = getGridYFromY( unit.getOldY() );

			removeFromTile( unit, gridX, gridY );

			unit.setPositionAsClean();
		}


		private function removeFromTile( unit:Unit, gridX:uint, gridY:uint ):void
		{
			var list:Vector.<Unit> = _lookup[ gridX ][ gridY ];
			var index:int = list.indexOf( unit );

			list.splice( index, 1 );
		}


		public function retriveFromRect( x:Number, y:Number, width:Number, height:Number ):Vector.<Unit>
		{
			var output:Vector.<Unit> = new Vector.<Unit>();

			var startX:uint = getGridXFromX( x );
			var startY:uint = getGridXFromX( y );

			var endX:uint = getGridXFromX( x + width );
			var endY:uint = getGridXFromX( y + height );

			for ( var gridX:uint = startX; gridX <= endX; gridX++ )
			{
				for ( var gridY:uint = startY; gridY <= endY; gridY++ )
				{
					var list:Vector.<Unit> = _lookup[ gridX ][ gridY ];
					var unitsCount:uint = list.length;

					for ( var i:int = 0; i < unitsCount; i++ )
					{
						output.push( list[ i ] );
					}
				}

			}

			return output;

		}


		public function cleanPosition( unit:Unit ):void
		{

			var oldGridX:uint = getGridXFromX( unit.getOldX() );
			var oldGridY:uint = getGridYFromY( unit.getOldY() );

			var newGridX:uint = getGridXFromX( unit.getX() );
			var newGridY:uint = getGridYFromY( unit.getY() );

			if ( oldGridX == newGridX && oldGridY == newGridY )
			{
				// unit has not changed tile. Do nothing but set it as clean
				unit.setPositionAsClean();
			}
			else
			{
				// remove from old
				removeFromTile( unit, oldGridX, oldGridY );
				insertToTile( unit, newGridX, newGridY );
				unit.setPositionAsClean();
			}

		}


		private function getGridXFromX( x:Number ):uint
		{
			return StrictMath.floor( x / TILE_WIDTH );
		}


		private function getGridYFromY( y:Number ):uint
		{
			return StrictMath.floor( y / TILE_HIGHT );

		}
	}
}
