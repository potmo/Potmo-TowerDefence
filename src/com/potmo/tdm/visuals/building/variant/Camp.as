package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.building.Camp_Asset;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.hud.CampHud;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.unit.UnitType;
	import com.potmo.util.logger.Logger;

	/**
	 * Camp
	 * Keep
	 * Fortress
	 * Castle
	 * Citadel
	 */
	public class Camp extends BuildingBase
	{

		private static const graphics:TextureAnimationCacheObject = new TextureAnimationCacheObject( new Camp_Asset() );

		private static const UNIT_DEPLOY_DELAY:uint = 120;
		private var unitDeployCountdown:uint = UNIT_DEPLOY_DELAY;


		public function Camp()
		{
			super( graphics );

		}


		public override function handleClick( x:int, y:int, logics:GameLogics ):void
		{
			Logger.log( "Camp was clicked" );
			logics.setHud( new CampHud( this ) );

		}


		override public function update( gameLogics:GameLogics ):void
		{

			if ( units.length != MAX_UNITS )
			{
				unitDeployCountdown--;

				if ( unitDeployCountdown == 0 )
				{
					Logger.log( "Deploy Knight" );
					unitDeployCountdown = UNIT_DEPLOY_DELAY;
					gameLogics.getUnitManager().addUnit( UnitType.KNIGHT, this, gameLogics );
				}
			}
		}
	}
}
