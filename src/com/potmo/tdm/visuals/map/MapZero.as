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
		private static const MAP_WALK_DATA_IMAGE_ASSET:Class;

		[Embed( source = "../assets/maps/map0-lr-dijkstra.png" )]
		private static const MAP_DIJKSTRA_LEFT_RIGHT_DATA_IMAGE_ASSET:Class;

		[Embed( source = "../assets/maps/map0-rl-dijkstra.png" )]
		private static const MAP_DIJKSTRA_RIGHT_LEFT_DATA_IMAGE_ASSET:Class;

		private static const NAME:String = "map0";


		public function MapZero()
		{
			var mapDataImage:Bitmap = new MAP_WALK_DATA_IMAGE_ASSET() as Bitmap;
			var dijkstraLeftRight:Bitmap = new MAP_DIJKSTRA_LEFT_RIGHT_DATA_IMAGE_ASSET() as Bitmap;
			var dijkstraRightLeft:Bitmap = new MAP_DIJKSTRA_RIGHT_LEFT_DATA_IMAGE_ASSET() as Bitmap;

			var visualRepresentation:BitmapData = graphics[ 0 ];

			// Just for a while copy the mapDataImage onto the background
			var matrix:Matrix = new Matrix();
			matrix.scale( 8, 8 );
			var colorTransform:ColorTransform = new ColorTransform( 1, 1, 1, 0.5 );
			visualRepresentation.draw( mapDataImage, matrix, colorTransform );

			super( visualRepresentation, mapDataImage.bitmapData, dijkstraLeftRight.bitmapData, dijkstraRightLeft.bitmapData, NAME );

		}

	}
}
