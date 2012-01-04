package com.potmo.tdm.visuals.map.forcemap.forcefieldmap.astar
{
	import com.potmo.tdm.visuals.map.forcemap.MapTileType;
	import com.potmo.tdm.visuals.map.forcemap.astar.AStarMap;
	import com.potmo.tdm.visuals.map.forcemap.astar.AStarMapTile;
	import com.potmo.tdm.visuals.map.forcemap.astar.AStarPath;
	import com.potmo.tdm.visuals.map.forcemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.map.forcemap.forcefieldmap.ForceFieldMap;
	import com.potmo.tdm.visuals.map.forcemap.forcefieldmap.ForceFieldTile;
	import com.potmo.tdm.visuals.map.forcemap.forcefieldmap.IForceFieldMap;
	import com.potmo.util.math.StrictMath;

	public class AStarForceFieldMap extends ForceFieldMap implements IForceFieldMap
	{
		private var _targetY:int;
		private var _targetX:int;
		private var _aStarMap:AStarMap;


		public function AStarForceFieldMap()
		{
			super();
		}


		public function getTargetX():int
		{
			return _targetX;
		}


		public function getTargetY():int
		{
			return _targetY;
		}


		public function setupFromAStarMap( aStarMap:AStarMap, goToPosX:int, goToPosY:int, initializeFlowMap:Boolean ):void
		{
			_aStarMap = aStarMap;
			width = aStarMap.getWidth();
			height = aStarMap.getHeight();
			this._targetX = goToPosX;
			this._targetY = goToPosY;

			// initialize by creating an empty map. Tiles will be generated when they are needed
			tiles = getEmptyNulledMap();

			// should we construct the flowmap rightaway or when it is used?
			if ( initializeFlowMap )
			{
				tiles = constructFlowPathMap( aStarMap );
			}

		}


		override public function getTileForce( x:Number, y:Number ):Force
		{

			// first check if the tile needs to get the forces then get the forces from super.getTileForce()
			var xTrunc:int = x - 0.5;
			var yTrunc:int = y - 0.5;

			var x1:int = StrictMath.max( 0, StrictMath.min( xTrunc, width - 1 ) );
			var x2:int = StrictMath.max( 0, StrictMath.min( xTrunc + 1, width - 1 ) );
			var y1:int = StrictMath.max( 0, StrictMath.min( yTrunc, height - 1 ) );
			var y2:int = StrictMath.max( 0, StrictMath.min( yTrunc + 1, height - 1 ) );

			if ( !tiles[ x1 ][ y1 ] )
			{
				setPathForPos( x1, y1 );
			}

			if ( !tiles[ x1 ][ y2 ] )
			{
				setPathForPos( x1, y2 );
			}

			if ( !tiles[ x2 ][ y2 ] )
			{
				setPathForPos( x2, y2 );
			}

			if ( !tiles[ x2 ][ y1 ] )
			{
				setPathForPos( x2, y1 );
			}

			return super.getTileForce( x, y );
		}


		/**
		 * Create a map (2D matrix) with null pointer values
		 */
		private function getEmptyNulledMap():Vector.<Vector.<ForceFieldTile>>
		{
			var out:Vector.<Vector.<ForceFieldTile>> = new Vector.<Vector.<ForceFieldTile>>( width, true );

			for ( var a:int = 0; a < width; a++ )
			{
				out[ a ] = new Vector.<ForceFieldTile>( height, true );

				/*	for ( var b:int = 0; b < height; b++ )
				   {
				   out[ a ][ b ] = new ForceFieldTile( this, a, b, aStarMap.getNodeAt( a, b ).getType(), new Vector3D( 0, 0, -1 ) );
				   }*/
			}

			return out;
		}


		/**
		 * Create a non progressive force field map (calculate all tiles at once)
		 */
		private function constructFlowPathMap( aStarMap:AStarMap ):Vector.<Vector.<ForceFieldTile>>
		{
			var visitedHashTiles:Vector.<uint> = new Vector.<uint>();

			var x:int;
			var y:int;

			//make a path from each tile
			for ( x = 0; x < width; x++ )
			{
				for ( y = 0; y < height; y++ )
				{
					if ( !tiles[ x ][ y ] )
					{
						setPathForPos( x, y );
					}
				}
			}

			return tiles;
		}


		/**
		 * Calculate the closest path to target from x and update the map with it
		 */
		protected function setPathForPos( x:int, y:int ):void
		{
			var forceFieldTile:ForceFieldTile;
			var path:AStarPath = _aStarMap.getBestPath( x, y, _targetX, _targetY ); //,visitedHashTiles
			path.data.reverse();

			var length:int = path.data.length;

			// standing on the tile or something?
			if ( length <= 1 )
			{
				forceFieldTile = new ForceFieldTile( this, x, y, _aStarMap.getNodeAt( x, y ).getType(), new Force( 0, 0 ) );
				tiles[ x ][ y ] = forceFieldTile;

					//visitedHashTiles.push( _aStarMap.getHash() );
			}

			for ( var i:int = 0; i < length - 1; i++ )
			{
				var force:Force = new Force( path.data[ i + 1 ].x - path.data[ i ].x, path.data[ i + 1 ].y - path.data[ i ].y );
				force.normalize();
				forceFieldTile = new ForceFieldTile( this, path.data[ i ].x, path.data[ i ].y, path.data[ i ].getType(), force );
				tiles[ path.data[ i ].x ][ path.data[ i ].y ] = forceFieldTile;

					//visitedHashTiles.push( forceFieldTile.getHash() );
			}
		}
	}
}
