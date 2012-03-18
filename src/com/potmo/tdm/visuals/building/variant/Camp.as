package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.hud.variant.CampHud;
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

		private static const UNIT_DEPLOY_DELAY:uint = 15;
		private var _unitDeployCountdown:uint = UNIT_DEPLOY_DELAY;
		private static const SEQUENCE_NAME:String = "camp";


		public function Camp( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );

		}


		public override function handleClick( x:int, y:int, gameLogics:GameLogics ):void
		{
			Logger.log( "Camp was clicked" );

			gameLogics.getHudManager().showCampHud( this );
		}


		override public function update( gameLogics:GameLogics ):void
		{

			if ( units.length != MAX_UNITS )
			{
				_unitDeployCountdown--;

				if ( _unitDeployCountdown == 0 )
				{
					Logger.log( "Deploy Knight" );
					_unitDeployCountdown = UNIT_DEPLOY_DELAY;
					gameLogics.getUnitManager().addUnit( UnitType.KNIGHT, this, gameLogics );
				}
			}
		}
	}
}
