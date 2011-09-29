package com.potmo.tdm.visuals.buildings
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.building.Archery_Asset;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.units.Archer;
	import com.potmo.tdm.visuals.units.UnitType;
	import com.potmo.util.image.BitmapAnimationCacheObject;
	import com.potmo.util.image.BitmapUtil;

	import flash.display.BitmapData;

	public class Archery extends BuildingBase
	{

		private static const graphics:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new Archery_Asset() );

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