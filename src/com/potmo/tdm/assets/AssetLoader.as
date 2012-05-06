package com.potmo.tdm.assets
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import com.potmo.util.logger.Logger;

	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.utils.ByteArray;

	public class AssetLoader
	{

		private var _bulkLoader:BulkLoader;
		private var _doneCallback:Function;
		private var _failCallback:Function;


		public function AssetLoader()
		{
			_bulkLoader = new BulkLoader();
		}


		private function queue( url:String, name:String, type:String ):void
		{
			Logger.info( "Loading: " + name + " - " + url );
			_bulkLoader.add( url, { id:name, type:type } );
		}


		/**
		 * Start the loading
		 * Both callbacks should be implemented as
		 * <code>public function callback(message:String):void {}</code>
		 */
		public function start( doneCallack:Function = null, failCallback:Function = null ):void
		{
			addItemsToLoad();

			_doneCallback = doneCallack;
			_failCallback = failCallback;
			_bulkLoader.addEventListener( BulkProgressEvent.COMPLETE, onComplete );
			_bulkLoader.addEventListener( ErrorEvent.ERROR, onError );
			_bulkLoader.start();

		}


		public function getXML( id:String ):XML
		{
			return _bulkLoader.getXML( id, true );
		}


		public function getBitmapData( id:String ):BitmapData
		{
			return _bulkLoader.getBitmapData( id, true );
		}


		public function getByteBlob( id:String ):ByteArray
		{
			return _bulkLoader.getBinary( id, true );
		}


		private function onError( event:ErrorEvent ):void
		{
			if ( _failCallback != null )
			{
				_failCallback.call( this, event.text );
			}
		}


		private function onComplete( event:BulkProgressEvent ):void
		{
			if ( _doneCallback != null )
			{
				_doneCallback.call( this, "OK" );
			}
		}


		private function addItemsToLoad():void
		{
			queue( "assets/atlas.xml", "atlasxml", BulkLoader.TYPE_XML );
			queue( "assets/atlas.png", "atlaspng", BulkLoader.TYPE_IMAGE );
			queue( "assets/maps/map0_atlas.xml", "map0xml", BulkLoader.TYPE_XML );
			queue( "assets/maps/map0_atlas.png", "map0png", BulkLoader.TYPE_IMAGE );
			queue( "assets/maps/map0_walkmap.png", "map0walkmap", BulkLoader.TYPE_IMAGE );
			/*	queue( "assets/maps/map0_lr_dijkstra.png", "map0lrdijkstra" );
			   queue( "assets/maps/map0_rl_dijkstra.png", "map0rldijkstra" );*/

			queue( "assets/maps/map0_dijkstra.map", "map0dijkstra", BulkLoader.TYPE_BINARY );
		}


		public function getAtlasDescriptor():XML
		{
			var xml:XML = getXML( "atlasxml" );

			if ( !xml )
			{
				throw new Error( "atlasxml not readable" );
			}
			return xml;
		}


		public function getAtlasImage():BitmapData
		{
			var bitmap:BitmapData = getBitmapData( "atlaspng" );

			if ( !bitmap )
			{
				throw new Error( "atlaspng not readable" );
			}
			return bitmap;
		}


		public function getMapDescriptor():XML
		{
			var xml:XML = getXML( "map0xml" );

			if ( !xml )
			{
				throw new Error( "map0xml not readable" );
			}
			return xml;
		}


		public function getMapImage():BitmapData
		{
			var bitmap:BitmapData = getBitmapData( "map0png" );

			if ( !bitmap )
			{
				throw new Error( "map0png not readable" );
			}
			return bitmap;
		}


		public function getMapWalkmap():BitmapData
		{
			var bitmap:BitmapData = getBitmapData( "map0walkmap" );

			if ( !bitmap )
			{
				throw new Error( "map0walkmap not readable" );
			}
			return bitmap;
		}


		public function getDijsktraMap():ByteArray
		{
			var bytes:ByteArray = getByteBlob( "map0dijkstra" );

			if ( !bytes )
			{
				throw new Error( "map0dijkstra not readable" );
			}
			return bytes;
		}

	/*	public function getLeftRightMap():BitmapData
	   {
	   var bitmap:BitmapData = getBitmapData( "map0lrdijkstra" );

	   if ( !bitmap )
	   {
	   throw new Error( "map0lrdijkstra not readable" );
	   }
	   return bitmap;
	   }


	   public function getRightLeftMap():BitmapData
	   {
	   var bitmap:BitmapData = getBitmapData( "map0rldijkstra" );

	   if ( !bitmap )
	   {
	   throw new Error( "map0rldijkstra not readable" );
	   }
	   return bitmap;
	   }*/
	}
}
