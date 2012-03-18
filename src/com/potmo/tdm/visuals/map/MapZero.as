package com.potmo.tdm.visuals.map
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.visuals.AssetHolder;

	import flash.display.Bitmap;

	public class MapZero extends MapBase
	{

		private static const NAME:String = "map0";


		public function MapZero( spriteAtlas:SpriteAtlas )
		{
			var mapDataImage:Bitmap = new AssetHolder.MAP_ZERO_WALK_DATA_IMAGE_ASSET() as Bitmap;
			var dijkstraLeftRight:Bitmap = new AssetHolder.MAP_ZERO_DIJKSTRA_LEFT_RIGHT_DATA_IMAGE_ASSET() as Bitmap;
			var dijkstraRightLeft:Bitmap = new AssetHolder.MAP_ZERO_DIJKSTRA_RIGHT_LEFT_DATA_IMAGE_ASSET() as Bitmap;
			var visualMap:Bitmap = new AssetHolder.MAP_ZERO_VISUAL_ASSET() as Bitmap;

			// Just for a while copy the mapDataImage onto the background
			/*var matrix:Matrix = new Matrix();
			   matrix.scale( 8, 8 );
			   var colorTransform:ColorTransform = new ColorTransform( 1, 1, 1, 0.5 );
			   visualMap.bitmapData.draw( mapDataImage, matrix, colorTransform );*/

			super( spriteAtlas, NAME, mapDataImage.bitmapData, dijkstraLeftRight.bitmapData, dijkstraRightLeft.bitmapData, NAME );

		}

	}
}
