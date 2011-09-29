package com.potmo.tdm.visuals.buildings
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.building.Archery_Asset;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.units.UnitType;

	public class Archery extends BuildingBase
	{

		private static const graphics:TextureAnimationCacheObject = new TextureAnimationCacheObject( new Archery_Asset() );

		private static const UNIT_DEPLOY_DELAY:uint = 30;
		private var unitDeployCountdown:uint = UNIT_DEPLOY_DELAY;;


		public function Archery()
		{
			super( graphics );
		}


		override public function update( gameLogics:GameLogics ):void
		{

			if ( units.length != MAX_UNITS )
			{
				unitDeployCountdown--;

				if ( unitDeployCountdown == 0 )
				{
					unitDeployCountdown = UNIT_DEPLOY_DELAY;
					gameLogics.addUnit( UnitType.ARCHER, this );
				}
			}
		}
	}
}
