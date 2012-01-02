package com.potmo.tdm
{
	import com.potmo.tdm.connection.Connector;
	import com.potmo.tdm.visuals.ScreenSize;
	import com.potmo.tdm.visuals.unit.UnitBase;
	import com.potmo.util.fpsCounter.FPSCounter;
	import com.potmo.util.input.MouseManager;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;

	import starling.core.Starling;
	import starling.display.Sprite;

	[SWF( backgroundColor = "0xCCCCCC", frameRate = "30", width = "960", height = "640" )]
	public class TowerDefenceMulti extends flash.display.Sprite
	{
		private var starlingInstance:Starling;

		private var frameRateCounter:FPSCounter;


		public function TowerDefenceMulti()
		{
			Logger.log( "Startup" );

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			this.frameRateCounter = new FPSCounter();
			addChild( frameRateCounter );

			Starling.multitouchEnabled = true;

			starlingInstance = new Starling( Main, stage );
			starlingInstance.antiAliasing = 0;
			starlingInstance.simulateMultitouch = false;
			starlingInstance.enableErrorChecking = false;
			starlingInstance.start();

			MouseManager.initialize( stage );

		}

	}
}
