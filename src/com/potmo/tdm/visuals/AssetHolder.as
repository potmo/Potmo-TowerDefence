package com.potmo.tdm.visuals
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class AssetHolder
	{
		// Map Sero
		[Embed( source = "../assets/maps/map0-visuals.png" )]
		public static const MAP_ZERO_VISUAL_ASSET:Class;

		[Embed( source = "../assets/maps/map0-walkmap.png" )]
		public static const MAP_ZERO_WALK_DATA_IMAGE_ASSET:Class;

		[Embed( source = "../assets/maps/map0-lr-dijkstra.png" )]
		public static const MAP_ZERO_DIJKSTRA_LEFT_RIGHT_DATA_IMAGE_ASSET:Class;

		[Embed( source = "../assets/maps/map0-rl-dijkstra.png" )]
		public static const MAP_ZERO_DIJKSTRA_RIGHT_LEFT_DATA_IMAGE_ASSET:Class;

		// Atlas
		[Embed( source = "assets/atlas.png", mimeType = "image/png" )]
		private static const _ATLAS_IMAGE_ASSET:Class;
		public static const ATLAS_TEXTURE:BitmapData = ( new _ATLAS_IMAGE_ASSET() as Bitmap ).bitmapData;

		[Embed( source = "assets/atlas.xml", mimeType = "application/octet-stream" )]
		private static const _ATLAS_XML_ASSET:Class;
		public static const ATLAS_XML:XML = new XML( new _ATLAS_XML_ASSET() );

	}
}
