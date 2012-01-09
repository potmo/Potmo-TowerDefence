package com.potmo.tdm
{

	import com.potmo.tdm.visuals.map.tilemap.TileMap;
	import com.potmo.tdm.visuals.map.tilemap.astar.AStarMap;
	import com.potmo.tdm.visuals.map.tilemap.astar.AStarPathMap;
	import com.potmo.tdm.visuals.map.util.MapImageAnalyzer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	[SWF( backgroundColor = "0xCCCCCC", frameRate = "30", width = "960", height = "640" )]
	public class TowerDefenceMultiMapExporter extends Sprite
	{

		[Embed( source = "../assets/maps/map0-walkmap.png" )]
		private static const MAP_DATA_ASSET:Class;

		private var sourceMap:BitmapData;
		private var forceMap:BitmapData;

		private var tileMap:TileMap;
		private var aStarMap:AStarMap;
		private var aStarPathMap:AStarPathMap;

		private var endPoints:Vector.<Point>;

		private var tX:int = 0;
		private var tY:int = 0;


		public function TowerDefenceMultiMapExporter()
		{
			super();

			var sourceMapBitmap:Bitmap = new MAP_DATA_ASSET();
			sourceMap = sourceMapBitmap.bitmapData;
			addChild( sourceMapBitmap );
			sourceMapBitmap.x = 10;
			sourceMapBitmap.y = 10;

			forceMap = new BitmapData( sourceMap.width, sourceMap.height );
			var forceMapBitmap:Bitmap = new Bitmap( forceMap );
			addChild( forceMapBitmap );
			forceMapBitmap.y = sourceMapBitmap.y + sourceMapBitmap.height + 10;
			forceMapBitmap.x = sourceMapBitmap.x;

			var mapImageAnalyzer:MapImageAnalyzer = new MapImageAnalyzer();
			endPoints = mapImageAnalyzer.getEndPoints( sourceMap, 1 );

			tileMap = mapImageAnalyzer.createMap( sourceMap, 1, 1 );
			aStarMap = new AStarMap();
			aStarMap.loadFromMap( tileMap );

			aStarPathMap = new AStarPathMap();
			aStarPathMap.loadFromAStarMap( aStarMap, endPoints[ 0 ].x, endPoints[ 0 ].y );

			//	aStarPathMap.getDirection( 24, 29 );
			//	aStarPathMap.draw( forceMap, 1, 1 );

			addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}


		private function onEnterFrame( event:Event ):void
		{

			for ( var i:int = 0; i < 10; i++ )
			{
				aStarPathMap.getDirection( tX, tY );

				tX++;

				if ( tX >= aStarMap.getWidth() )
				{
					tX = 0;
					tY++;

					if ( tY >= aStarMap.getHeight() )
					{
						removeEventListener( Event.ENTER_FRAME, onEnterFrame );
						break;
					}
				}
			}

			aStarPathMap.draw( forceMap, 1, 1 );

		}
	}
}
