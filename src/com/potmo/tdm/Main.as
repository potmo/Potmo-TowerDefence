package com.potmo.tdm
{
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.util.input.MouseManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{

		//private var connector:Connector;
		private var gameView:GameView;
		private var gameLogics:GameLogics;
		private var orderManager:OrderManager;
		private var frame:int;

		private var debugCanvas:BitmapData;

		private var debugCanvasBitmap:Bitmap;


		public function Main()
		{
			super();

			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );

			// make none take touchevents
			this.touchable = false;

			addGame();
		}


		private function onEnterFrame( event:Event = null ):void
		{
			gameLogics.update();
			gameView.update();

		/*	frame++;

		   if ( frame % 5 == 0 )
		   {
		   debugCanvas.lock();
		   gameLogics.getUnitManager().draw( debugCanvas );
		   debugCanvasBitmap.x = -gameView.getCameraPosition();
		   debugCanvas.unlock();
		   }*/
		}


		/*private function connect():void
		   {
		   connector = new Connector();
		   connector.connect( "testGroup", ( Math.round( Math.random() * 1000 ) ).toString() );
		   }*/

		private function addGame():void
		{

			gameView = new GameView();
			orderManager = new OrderManager();
			gameLogics = new GameLogics( gameView, orderManager );

			gameView.setGameLogics( gameLogics );
			gameView.setOrderManager( orderManager );

			orderManager.setGameLogics( gameLogics );

			addChild( gameView );

			onEnterFrame();

		/*debugCanvas = new BitmapData( gameLogics.getMap().getMapWidth(), gameLogics.getMap().getMapHeight(), true );
		   debugCanvasBitmap = new Bitmap( debugCanvas );
		   Starling.current.nativeStage.addChild( debugCanvasBitmap );*/

		}
	}
}
