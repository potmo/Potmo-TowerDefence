package com.potmo.tdm
{
	import com.potmo.util.input.MouseManager;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{

		//private var connector:Connector;
		private var gameView:GameView;
		private var gameLogics:GameLogics;
		private var orderManager:OrderManager;


		public function Main()
		{
			super();

			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );

			// make none take touchevents
			this.touchable = false;

			addGame();
		}


		private function onEnterFrame( event:Event ):void
		{
			gameLogics.update();
			gameView.update();
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

		}
	}
}
