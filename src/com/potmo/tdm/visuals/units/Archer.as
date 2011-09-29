package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.unit.Archer_Asset;
	import com.potmo.tdm.player.Player;
	import com.potmo.util.image.BitmapAnimationCacheObject;
	import com.potmo.util.image.BitmapUtil;

	import flash.display.BitmapData;

	public class Archer extends UnitBase
	{
		private static const asset:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new Archer_Asset() );


		public function Archer()
		{
			super( asset );
		}


		override public function update( gameLogics:GameLogics ):void
		{
			walkToNextCheckpoint( gameLogics );
			nextFrame();
		}
	}
}