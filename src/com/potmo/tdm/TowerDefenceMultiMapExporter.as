package com.potmo.tdm
{

	import com.potmo.tdm.visuals.map.tilemap.IMapTile;
	import com.potmo.tdm.visuals.map.tilemap.TileMap;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.PathFindingPath;
	import com.potmo.tdm.visuals.map.tilemap.pathfinding.dijkstra.DijkstraMap;
	import com.potmo.tdm.visuals.map.util.MapImageAnalyzer;
	import com.potmo.util.image.encoder.PNGEncoder;
	import com.potmo.util.logger.Logger;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	[SWF( backgroundColor = "0xCCCCCC", frameRate = "30", width = "960", height = "640" )]
	public class TowerDefenceMultiMapExporter extends Sprite
	{

		[Embed( source = "../assets/maps/map0-walkmap.png" )]
		private static const MAP_DATA_ASSET:Class;

		private var sourceCanvas:BitmapData;
		private var forceCanvas:BitmapData;

		private var tileMap:TileMap;
		private var dijkstraMap:DijkstraMap;

		private var endPoints:Vector.<Point>;

		private var tX:int = 0;
		private var tY:int = 0;

		private var forceMapBitmap:Bitmap;


		public function TowerDefenceMultiMapExporter()
		{
			super();

			var sourceMapBitmap:Bitmap = new MAP_DATA_ASSET();
			sourceCanvas = sourceMapBitmap.bitmapData;
			addChild( sourceMapBitmap );
			sourceMapBitmap.x = 10;
			sourceMapBitmap.y = 10;

			forceCanvas = new BitmapData( sourceCanvas.width, sourceCanvas.height );
			forceMapBitmap = new Bitmap( forceCanvas );
			addChild( forceMapBitmap );
			stage.addEventListener( MouseEvent.CLICK, saveToFile );
			forceMapBitmap.y = sourceMapBitmap.y + sourceMapBitmap.height + 10;
			forceMapBitmap.x = sourceMapBitmap.x;

			var mapImageAnalyzer:MapImageAnalyzer = new MapImageAnalyzer();
			endPoints = mapImageAnalyzer.getEndPoints( sourceCanvas, 1 );

			tileMap = mapImageAnalyzer.createMap( sourceCanvas, 1, 1 );
			dijkstraMap = new DijkstraMap();
			dijkstraMap.loadFromMap( tileMap );
			dijkstraMap.buildShortestPathToPoint( endPoints[ 0 ].x, endPoints[ 0 ].y );

			dijkstraMap.buildPathsFromUnwalkableTilesToNearestWalkableTile();

			dijkstraMap.draw( forceCanvas, 1, 1 );

			// draw the best path between the start points
			forceCanvas.lock();
			var path:PathFindingPath = dijkstraMap.getBestPath( endPoints[ 1 ].x, endPoints[ 1 ].y, endPoints[ 0 ].x, endPoints[ 0 ].y );

			for each ( var tile:IMapTile in path.data )
			{
				forceCanvas.fillRect( new Rectangle( tile.x, tile.y, 1, 1 ), 0xFFFFFFFF );
			}
			forceCanvas.unlock();

		/*	aStarPathMap = new AStarPathMap();
		   aStarPathMap.loadFromAStarMap( dijkstraMap, endPoints[ 0 ].x, endPoints[ 0 ].y );
		 */
			 //	aStarPathMap.getDirection( 24, 29 );
			 //	aStarPathMap.draw( forceMap, 1, 1 );

		/*			addEventListener( Event.ENTER_FRAME, onEnterFrame );*/
		}


		/*	private function onEnterFrame( event:Event ):void
		   {

		   var start:int = getTimer();

		   while ( start + 500 > getTimer() )
		   {
		   aStarPathMap.getDirection( tX, tY );

		   tY++;

		   if ( tY >= dijkstraMap.getHeight() )
		   {
		   tY = 0;
		   tX++;

		   if ( tX >= dijkstraMap.getWidth() )
		   {
		   removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		   break;
		   }
		   }
		   }

		   aStarPathMap.draw( forceCanvas, 1, 1 );

		   }*/

		private function saveToFile( event:MouseEvent ):void
		{

			if ( !forceMapBitmap.getRect( this ).contains( event.stageX, event.stageY ) )
			{
				return;
			}

			Logger.log( "Save to file" );

			var data:ByteArray = PNGEncoder.encode( forceCanvas );

			var fileReference:FileReference = new FileReference();
			fileReference.save( data, ".png" );
		}
	}
}
