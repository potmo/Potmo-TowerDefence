package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.unit.Archer_Asset;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.units.settings.ArcherSetting;

	public class Archer extends FightingUnitBase
	{
		private static const ASSET:TextureAnimationCacheObject = new TextureAnimationCacheObject( new Archer_Asset() );
		private static const SETTING:ArcherSetting = new ArcherSetting();


		public function Archer()
		{
			super( ASSET, SETTING );
		}


		override public function update( gameLogics:GameLogics ):void
		{
			super.update( gameLogics );
		}
	}
}
