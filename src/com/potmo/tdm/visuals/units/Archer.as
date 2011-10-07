package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.unit.Archer_Asset;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;

	public class Archer extends FightingUnitBase
	{
		private static const asset:TextureAnimationCacheObject = new TextureAnimationCacheObject( new Archer_Asset() );


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
