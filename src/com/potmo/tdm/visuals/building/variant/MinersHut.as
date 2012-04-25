package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.p2d.atlas.animation.SpriteAtlasSequence;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.unit.UnitType;
	import com.potmo.util.logger.Logger;

	public class MinersHut extends BuildingBase
	{
		//TODO: Miners hut should have its own graphics
		private static const SEQUENCE_NAME:String = "archery";
		private static const UNIT_DEPLOY_DELAY:int = 60;

		private var _unitDeployCountdown:int = UNIT_DEPLOY_DELAY;


		public function MinersHut( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );

		}


		override public function update( gameLogics:GameLogics ):void
		{

			if ( units.length != MAX_UNITS )
			{
				_unitDeployCountdown--;

				if ( _unitDeployCountdown == 0 )
				{
					//TODO: Deploy miners instead of knights
					Logger.log( "Deploy Miner" );
					_unitDeployCountdown = UNIT_DEPLOY_DELAY;
					gameLogics.getUnitManager().addUnit( UnitType.MINER, this, gameLogics );
				}
			}
		}
	}
}
