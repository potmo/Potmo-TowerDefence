package com.potmo.tdm.visuals.map.tilemap.forcefieldmap.wall
{
	import com.potmo.tdm.visuals.map.tilemap.TileMap;
	import com.potmo.tdm.visuals.map.tilemap.MapTile;
	import com.potmo.tdm.visuals.map.tilemap.MapTileType;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.ForceFieldTile;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.IForceFieldMap;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.ITileForceFieldMap;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.MapDrawUtil;
	import com.potmo.util.math.StrictMath;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	public class WallForceFieldMap implements IForceFieldMap
	{

		protected var width:uint;
		protected var height:uint;

		private var tiles:Vector.<Vector.<Boolean>>;


		public function WallForceFieldMap()
		{
			super();
		}


		public function getCanvasSize( horizontalTileSize:int, verticalTileSize:int ):Rectangle
		{
			return new Rectangle( 0, 0, horizontalTileSize * width, verticalTileSize * height );

		}


		private function isTileWalkable( mapTile:MapTile ):Boolean
		{
			return mapTile.getType().isWalkable();
		}


		public function setupFromMap( map:TileMap ):void
		{
			this.width = map.getWidth();
			this.height = map.getHeight();

			tiles = new Vector.<Vector.<Boolean>>();

			for ( var x:int = 0; x < width; x++ )
			{
				tiles.push( new Vector.<Boolean>() );

				for ( var y:int = 0; y < height; y++ )
				{
					var tile:MapTile = map.getAt( x, y );
					tiles[ x ].push( isTileWalkable( tile ) );
				}
			}
		}


		public function getPathForce( x:Number, y:Number ):Force
		{

			//ABC
			//DiE
			//FGH
			// floor
			var ix:int = int( x );
			var iy:int = int( y );

			ix = StrictMath.max( StrictMath.min( ix, width - 1 ), 0 );
			iy = StrictMath.max( StrictMath.min( iy, height - 1 ), 0 );

			// fraction
			var fx:Number = x - ix;
			var fy:Number = y - iy;

			// direction of force from centre i
			var dx:Number = fx - 0.5;
			var dy:Number = fy - 0.5;

			// is it not walkable
			if ( !tiles[ ix ][ iy ] )
			{
				//absolute
				var dxa:Number = StrictMath.abs( dx );
				var dya:Number = StrictMath.abs( dy );

				var unwalkableFactor:Number = 2.5;
				return new Force( ( ( 1 - dxa ) * dx / dxa ) * unwalkableFactor, ( ( 1 - dya ) * dy / dya ) * unwalkableFactor );
			}

			var Ax:int;
			var Bx:int;
			var Cx:int;
			var Dx:int;
			var Ex:int;
			var Fx:int;
			var Gx:int;
			var Hx:int;

			Ax = Dx = Fx = StrictMath.max( 0, ix - 1 );
			Bx = Gx = ix;
			Cx = Ex = Hx = StrictMath.min( ix + 1, width - 1 );

			var Ay:int;
			var By:int;
			var Cy:int;
			var Dy:int;
			var Ey:int;
			var Fy:int;
			var Gy:int;
			var Hy:int;

			Ay = By = Cy = StrictMath.max( iy - 1, 0 );
			Dy = Ey = iy;
			Fy = Gy = Hy = StrictMath.min( iy + 1, height - 1 );

			var force:Force = new Force();
			var factor:Number = 2.0;

			if ( dx < 0 && !tiles[ Dx ][ Dy ] )
			{
				force.x += StrictMath.sqr( dx * factor );
			}

			if ( dx > 0 && !tiles[ Ex ][ Ey ] )
			{
				force.x += -StrictMath.sqr( dx * factor );
			}

			if ( dy < 0 && !tiles[ Bx ][ By ] )
			{
				force.y += StrictMath.sqr( dy * factor );
			}

			if ( dy > 0 && !tiles[ Gx ][ Gy ] )
			{
				force.y += -StrictMath.sqr( dy * factor );
			}

			return force;
		}


		public function draw( canvas:BitmapData, horizontalTileSize:int, verticalTileSize:int ):void
		{
			canvas.lock();

			for ( var x:int = 0; x < width * horizontalTileSize; x++ )
			{
				for ( var y:int = 0; y < height * verticalTileSize; y++ )
				{
					var mapX:Number = x / horizontalTileSize;
					var mapY:Number = y / verticalTileSize;
					var force:Force = getPathForce( mapX, mapY );
					MapDrawUtil.drawForce( canvas, x, y, force );
				}
			}
			canvas.unlock();
		}

	}
}
