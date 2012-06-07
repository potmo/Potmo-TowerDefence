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

	public class MinersHut extends BuildingBase implements Building
	{
		//TODO: Miners hut should have its own graphics
		private static const SEQUENCE_NAME:String = "minershut";
		private static const UNIT_DEPLOY_DELAY:int = 60;

		private var _unitDeployCountdown:int = UNIT_DEPLOY_DELAY;


		public function MinersHut( spriteAtlas:SpriteAtlas )
		{
			super( BuildingType.MINERS_HUT, spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );

		}


		public function getUpgrade( buildingFactory:BuildingFactory ):Building
		{
			//TODO: Implement upgrade of building
			return null;
		}


		public function update( gameLogics:GameLogics ):void
		{

			if ( units.length != MAX_UNITS )
			{
				_unitDeployCountdown--;

				if ( _unitDeployCountdown == 0 )
				{
					Logger.log( "Deploy Miner" );
					_unitDeployCountdown = UNIT_DEPLOY_DELAY;
					deployNewUnit( gameLogics );
				}
			}
		}


		public function init( gameLogics:GameLogics ):void
		{
		}


		public function reset( gameLogics:GameLogics ):void
		{
		}


		public function handleClick( x:int, y:int, gameLogics:GameLogics ):void
		{
		}


		public function handleClickOutside( x:int, y:int, gameLogics:GameLogics ):void
		{
		}
	}
}
