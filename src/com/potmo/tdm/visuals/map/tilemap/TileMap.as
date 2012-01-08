package com.potmo.tdm.visuals.map.tilemap
{
	import com.potmo.util.numbers.SeedRandom;

	public class TileMap
	{
		private var data:Vector.<Vector.<MapTile>>;
		private var width:uint;
		private var height:uint;


		public function TileMap()
		{
		}


		public function loadTestMap( width:uint, height:uint ):void
		{

			loadEmptyMap( width, height )

			// Just randomize some
			for ( var j:int = 0; j < 15; j++ )
			{
				var x2:int = Math.round( 1 + SeedRandom.random() * ( width - 3 ) );
				var y2:int = Math.round( 1 + SeedRandom.random() * ( height - 3 ) );

				this.data[ x2 ][ y2 ].setType( MapTileType.DEFAULT_UNWALKABLE_TILE );
				/*this.data[ x2 + 1 ][ y2 ].setType( MapTileType.DEFAULT_UNWALKABLE_TILE );
				   this.data[ x2 + 1 ][ y2 + 1 ].setType( MapTileType.DEFAULT_UNWALKABLE_TILE );
				   this.data[ x2 ][ y2 + 1 ].setType( MapTileType.DEFAULT_UNWALKABLE_TILE );*/
			}
		}


		/**
		 * Load an empty map with non walkables on the edges
		 */
		public function loadEmptyMap( width:uint, height:uint ):void
		{
			this.width = width;
			this.height = height;

			// initialize empty arrays
			this.data = new Vector.<Vector.<MapTile>>( width, true );

			for ( var i:int = 0; i < width; i++ )
			{
				this.data[ i ] = new Vector.<MapTile>( height, true );
			}

			// add deafult tiles (non walkable on the edges)
			for ( var x:int = 0; x < width; x++ )
			{
				for ( var y:int = 0; y < height; y++ )
				{

					if ( x == 0 || y == 0 || ( x == width - 1 ) || ( y == height - 1 ) )
					{
						this.data[ x ][ y ] = new MapTile( x, y, MapTileType.DEFAULT_UNWALKABLE_TILE );
						continue;
					}

					this.data[ x ][ y ] = new MapTile( x, y, MapTileType.DEFAULT_WALKABLE_TILE );

				}
			}
		}


		public function getAt( x:uint, y:uint ):MapTile
		{
			return data[ x ][ y ];
		}


		/**
		 * Sets the type on a tile
		 */
		public function setTypeAt( x:uint, y:uint, type:MapTileType ):void
		{
			this.data[ x ][ y ].setType( type );
		}


		public function getWidth():uint
		{
			return width;
		}


		public function getHeight():uint
		{
			return height;
		}

	}
}
