package com.potmo.tdm
{
	import com.potmo.tdm.connection.Connector;
	import com.potmo.tdm.visuals.ScreenSize;
	import com.potmo.util.fpsCounter.FPSCounter;
	import com.potmo.util.input.MouseManager;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;

	[SWF( backgroundColor="0xCCCCCC", frameRate="30", width="960", height="640" )]
	public class TowerDefenceMulti extends Sprite
	{

		private var connector:Connector;
		private var gameView:GameView;
		private var gameLogics:GameLogics;
		private var orderManager:OrderManager;
		private var frameRateCounter:FPSCounter;


		public function TowerDefenceMulti()
		{
			Logger.log( "Startup" );

			addGame();

			this.frameRateCounter = new FPSCounter();
			addChild( frameRateCounter );

			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			MouseManager.initialize( this );

		}


		private function onEnterFrame( event:Event ):void
		{
			gameLogics.update();
			gameView.update();
		}


		private function connect():void
		{
			connector = new Connector();
			connector.connect( "testGroup", ( Math.round( Math.random() * 1000 ) ).toString() );
		}


		private function addGame():void
		{
			orderManager = new OrderManager();

			gameView = new GameView( ScreenSize.WIDTH );
			addChild( gameView );

			gameLogics = new GameLogics( gameView, orderManager );

			gameView.setGameLogics( gameLogics );
			gameView.setOrderManager( orderManager );
			orderManager.setGameLogics( gameLogics );

		}
	}
}