package com.potmo.tdm.visuals.map.forcemap.astar
{
	//	import com.potmo.secretServer.application.rts.units.Unit;
	import com.potmo.tdm.visuals.map.forcemap.TileMap;
	import com.potmo.tdm.visuals.map.forcemap.MapTile;
	import com.potmo.util.image.BitmapUtil;
	import com.potmo.util.math.StrictMath;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class AStarMap
	{

		private var _data:Vector.<Vector.<AStarMapTile>>;
		private const COST_DIAG:Number = 1.41421356; // sqrt(2.0)

		private var _pathCalculationNumber:uint = 0;

		private var _width:uint;
		private var _height:uint;


		public function AStarMap()
		{

		}


		public function getCanvasSize( horizontalTileSize:int, verticalTileSize:int ):Rectangle
		{
			return new Rectangle( 0, 0, horizontalTileSize * _width, verticalTileSize * _height );

		}


		/***
		 * Get the best path from x0,y0 to x1,y1
		 * If a path that would reach to the goal can not be found the closest point to the goal will be returned as end position
		 * @param x0, y0 start pos
		 * @param x1, y1 end pos
		 * @haltAtHashedTiles
		 */
		public function getBestPath( x0:int, y0:int, x1:int, y1:int, haltAtHashedTiles:Vector.<uint> = null ):AStarPath
		{

			var shouldCheckHashedTiles:Boolean = haltAtHashedTiles != null;
			var foundGoal:Boolean = false;
			//every time a new path is calculated we increase the pathCalculationNumber
			// in that way we can determin if the g,h and f values are for this calculation
			_pathCalculationNumber++;

			// clear vectors
			var open:Vector.<AStarMapTile> = new Vector.<AStarMapTile>();
			var closed:Vector.<AStarMapTile> = new Vector.<AStarMapTile>();

			var len:Number = _width * _height;

			var start:AStarMapTile = this._data[ x0 ][ y0 ];
			var goal:AStarMapTile = this._data[ x1 ][ y1 ];

			start.setG( 0, this._pathCalculationNumber );
			start.setH( this.distance( start, goal ), this._pathCalculationNumber );
			start.setF( start.getF( this._pathCalculationNumber ), this._pathCalculationNumber );
			start.setParent( null, this._pathCalculationNumber );
			start.setInOpen( true, this._pathCalculationNumber );
			open.push( start );

			while ( open.length > 0 )
			{

				// Find node with lowest f
				var tf:Number = Number.POSITIVE_INFINITY;
				var current:AStarMapTile = null;

				for ( var i:int = 0; i < open.length; i++ )
				{
					var e:AStarMapTile = open[ i ];

					//var ie:int = this.indexOf(e);
					if ( e.getF( this._pathCalculationNumber ) < tf )
					{

						tf = e.getF( this._pathCalculationNumber );
						current = e;

					}
				}

				//check if we found goal
				if ( current == goal )
				{
					foundGoal = true;
				}
				else if ( shouldCheckHashedTiles )
				{
					// check if this is a early exit tile that we are standing on
					var index:int = haltAtHashedTiles.indexOf( current.getHash() );

					if ( index != -1 )
					{
						foundGoal = true;
					}
				}

				if ( foundGoal )
				{
					return AStarPath.MakePath( current, start, this._pathCalculationNumber, this );
				}

				open.splice( open.indexOf( current ), 1 );
				current.setInOpen( false, this._pathCalculationNumber );

				if ( current == null )
				{
					continue;
				}

				closed.push( current );
				current.setInClosed( true, this._pathCalculationNumber );

				for each ( var y:AStarMapTile in current.neighbors )
				{

					//if (closed.indexOf(y) != -1) continue;

					if ( ( closed.indexOf( y ) != -1 ) != y.getInClosed( this._pathCalculationNumber ) )
					{
						throw new Error( "Does not match" );
					}

					if ( y.getInClosed( this._pathCalculationNumber ) )
					{
						continue;
					}

					//var ix:int = indexOf(x);
					var tg:Number = current.getG( this._pathCalculationNumber ) + this.distance( current, y );
					var better:Boolean = false;

					//if (open.indexOf(y) == -1) {

					if ( ( open.indexOf( y ) == -1 ) != !y.getInOpen( this._pathCalculationNumber ) )
					{
						throw new Error( "Does not match" );
					}

					if ( !y.getInOpen( this._pathCalculationNumber ) )
					{
						open.push( y );
						y.setInOpen( true, this._pathCalculationNumber );
						better = true;
					}
					else if ( tg < y.getG( this._pathCalculationNumber ) )
					{
						better = true;
					}

					if ( better )
					{
						y.setParent( current, this._pathCalculationNumber );
						y.setG( tg, this._pathCalculationNumber );
						y.setH( this.distance( y, goal ), this._pathCalculationNumber );
						y.setF( y.getH( this._pathCalculationNumber ) + y.getG( this._pathCalculationNumber ), this._pathCalculationNumber );
					}
				}
			}

			// No solution found, return shortest alternative
			var min:Number = Number.POSITIVE_INFINITY;
			var ng:AStarMapTile = null;

			for each ( var n:AStarMapTile in closed )
			{
				var d:Number = this.distance( goal, n );

				if ( d < min )
				{
					min = d;
					ng = n;
				}
			}
			return AStarPath.MakePath( ng, start, this._pathCalculationNumber, this );
		}


		/***
		 * Get the index in a linear list of the node
		 */
		public function indexOf( node:AStarMapTile ):int
		{
			return node.y * ( _width ) + node.x;
		}


		public function loadFromMap( map:TileMap ):void
		{
			_width = map.getWidth();
			_height = map.getHeight();

			// init empty array
			this._data = new Vector.<Vector.<AStarMapTile>>( _width, true );

			for ( var i:int = 0; i < _width; i++ )
			{
				this._data[ i ] = new Vector.<AStarMapTile>( _height, true );
			}

			// fill the array with data
			for ( var x:int = 0; x < _width; x++ )
			{
				for ( var y:int = 0; y < _height; y++ )
				{

					var tile:MapTile = map.getAt( x, y );

					_data[ x ][ y ] = AStarMapTile.fromMapTile( tile );

				}
			}

			initializeNodes();

		}


		/***
		 * Setup all nodes and connect it to the proper neighbors
		 */
		public function initializeNodes():void
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
		 * Get all neighbors to a node that the node can be conencted to
		 * That is all nodes one step from the node in all directions as long as the node connection does not cut corners of non walkable nodes
		 */
		public function getNeighbors( node:AStarMapTile ):Vector.<AStarMapTile>
		{

			var x:int = node.x;
			var y:int = node.y;

			var neighbors:Vector.<AStarMapTile> = new Vector.<AStarMapTile>();

			var n:AStarMapTile;

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


		private function distance( n1:AStarMapTile, n2:AStarMapTile ):Number
		{

			var h_diag:Number = StrictMath.min( StrictMath.abs( n1.x - n2.x ), StrictMath.abs( n1.y - n2.y ) );

			var h_orth:Number = ( StrictMath.abs( n1.x - n2.x ) + StrictMath.abs( n1.y - n2.y ) );

			return COST_DIAG * h_diag + h_orth - 2 * h_diag;

		}


		public function getNodeAt( x:int, y:int ):AStarMapTile
		{
			return _data[ x ][ y ];
		}


		public function setNodeAt( x:int, y:int, value:AStarMapTile ):void
		{
			_data[ x ][ y ] = value;
		}


		public function getData():Vector.<Vector.<AStarMapTile>>
		{
			return _data;
		}


		public function draw( canvas:BitmapData, horizontalTileSize:int, verticalTileSize:int ):void
		{

			canvas.lock();

			for ( var y:int = 0; y < _height; y++ )
			{
				for ( var x:int = 0; x < _width; x++ )
				{
					var color:uint;
					color = _data[ x ][ y ].walkable ? 0x00FF00 : 0xFF0000;
					canvas.fillRect( new Rectangle( x * horizontalTileSize, y * verticalTileSize, horizontalTileSize, verticalTileSize ), color );
				}
			}
			canvas.unlock();
		}


		public function drawPath( canvas:Bitmap, path:AStarPath, horizontalTileSize:int, verticalTileSize:int ):void
		{

			canvas.bitmapData.lock();

			for each ( var node:AStarMapTile in path.data )
			{
				BitmapUtil.drawCirlce( node.x * horizontalTileSize + horizontalTileSize / 2, node.y * verticalTileSize + verticalTileSize / 2, verticalTileSize / 4, 0x0000FF, canvas.bitmapData );
			}

			canvas.bitmapData.unlock();
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
