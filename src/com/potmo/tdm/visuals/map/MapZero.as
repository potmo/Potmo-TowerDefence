package com.potmo.tdm.visuals.map
{
	import com.potmo.tdm.asset.map.MapZero_Asset;
	import com.potmo.util.image.BitmapUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;

	import starling.display.Image;
	import starling.textures.Texture;

	public class MapZero extends MapBase
	{

		private static const graphics:Vector.<BitmapData> = BitmapUtil.rasterizeMovieClip( new MapZero_Asset() );

		[Embed( source = "../assets/maps/map0-walkmap.png" )]
		private static const MAP_DATA_IMAGE_ASSET:Class;


		public function MapZero()
		{
			var mapDataImage:Bitmap = new MAP_DATA_IMAGE_ASSET() as Bitmap;
			var visualRepresentation:BitmapData = graphics[ 0 ];

			// Just for a while copy the mapDataImage onto the background
			var matrix:Matrix = new Matrix();
			matrix.scale( 10, 10 );
			var colorTransform:ColorTransform = new ColorTransform( 1, 1, 1, 0.5 );
			visualRepresentation.draw( mapDataImage, matrix, colorTransform );

			super( visualRepresentation, mapDataImage.bitmapData );

		}


		override protected function setCheckpoints():void
		{
			checkpoints = new Vector.<PathCheckpoint>();
			checkpoints.push( new PathCheckpoint( 0, 15, 206 ) );
			checkpoints.push( new PathCheckpoint( 1, 209, 179 ) );
			checkpoints.push( new PathCheckpoint( 2, 404, 236 ) );
			checkpoints.push( new PathCheckpoint( 3, 419, 462 ) );
			checkpoints.push( new PathCheckpoint( 4, 608, 531 ) );
			checkpoints.push( new PathCheckpoint( 5, 802, 470 ) );
			checkpoints.push( new PathCheckpoint( 6, 850, 271 ) );
			checkpoints.push( new PathCheckpoint( 7, 952, 75 ) );
			checkpoints.push( new PathCheckpoint( 8, 1236, 38 ) );
			checkpoints.push( new PathCheckpoint( 9, 1355, 249 ) );
			checkpoints.push( new PathCheckpoint( 10, 1512, 419 ) );
			checkpoints.push( new PathCheckpoint( 11, 2356, 428 ) );
			checkpoints.push( new PathCheckpoint( 12, 2513, 258 ) );
			checkpoints.push( new PathCheckpoint( 13, 2632, 47 ) );
			checkpoints.push( new PathCheckpoint( 14, 2916, 84 ) );
			checkpoints.push( new PathCheckpoint( 15, 3018, 280 ) );
			checkpoints.push( new PathCheckpoint( 16, 3066, 479 ) );
			checkpoints.push( new PathCheckpoint( 17, 3260, 570 ) );
			checkpoints.push( new PathCheckpoint( 18, 3449, 471 ) );
			checkpoints.push( new PathCheckpoint( 19, 3464, 245 ) );
			checkpoints.push( new PathCheckpoint( 20, 3659, 188 ) );
		}

	/*public override function getPlayer0BuildingPositions():Vector.<Point>
	   {
	   var v:Vector.<Point> = new Vector.<Point>();
	   v.push( new Point( 36, 273 ) );
	   v.push( new Point( 505, 304 ) );
	   return v;
	   }


	   public override function getPlayer1BuildingPositions():Vector.<Point>
	   {
	   var v:Vector.<Point> = new Vector.<Point>();
	   v.push( new Point( 3590, 336 ) );
	   v.push( new Point( 3297, 238 ) );

	   v.push( new Point( 805, 304 ) );
	   return v;
	   }*/

	}
}
