package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.BuildingFactory;
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.tdm.visuals.unit.UnitType;
	import com.potmo.util.logger.Logger;

	/**
	 * Camp
	 * Keep
	 * Fortress
	 * Castle
	 * Citadel
	 */
	public class Camp extends BuildingBase implements Building
	{

		private static const UNIT_DEPLOY_DELAY:uint = 15;
		private var _unitDeployCountdown:uint = UNIT_DEPLOY_DELAY;
		private static const SEQUENCE_NAME:String = "camp";


		public function Camp( spriteAtlas:SpriteAtlas )
		{
			super( BuildingType.CAMP, spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );

		}


		public function getUpgrade( buildingFactory:BuildingFactory ):Building
		{
			//TODO: Implement upgrade of building
			return null;
		}


		public function handleClick( x:int, y:int, gameLogics:GameLogics ):void
		{
			Logger.log( "Camp was clicked" );

			gameLogics.getHudManager().showCampHud( this );
		}


		public function handleClickOutside( x:int, y:int, gameLogics:GameLogics ):void
		{
		}


		public function update( gameLogics:GameLogics ):void
		{

			if ( units.length != MAX_UNITS )
			{
				_unitDeployCountdown--;

				if ( _unitDeployCountdown == 0 )
				{
					Logger.log( "Deploy Knight" );
					_unitDeployCountdown = UNIT_DEPLOY_DELAY;
					deployNewUnit( gameLogics );
				}
			}
		}


		private function deployNewUnit( gameLogics:GameLogics ):void
		{
			gameLogics.getUnitManager().addUnit( UnitType.KNIGHT, this, gameLogics );

		}


		public function init( gameLogics:GameLogics ):void
		{
			// create all units right up first
			for ( var i:int = 0; i < MAX_UNITS; i++ )
			{
				deployNewUnit( gameLogics );
			}
		}


		public function reset( gameLogics:GameLogics ):void
		{
			//TODO: Clean up here
		}

	}
}
