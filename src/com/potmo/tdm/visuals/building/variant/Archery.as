package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.BuildingBase;

	public class Archery extends BuildingBase
	{

		private static const UNIT_DEPLOY_DELAY:uint = 30;
		private var unitDeployCountdown:uint = UNIT_DEPLOY_DELAY;
		private static const SEQUENCE_NAME:String = "archery";


		public function Archery( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas.getSequenceByName( SEQUENCE_NAME ), 50, 75 );
		}


		override public function update( gameLogics:GameLogics ):void
		{

			if ( units.length != MAX_UNITS )
			{
				unitDeployCountdown--;

				if ( unitDeployCountdown == 0 )
				{
					unitDeployCountdown = UNIT_DEPLOY_DELAY;
						//gameLogics.getUnitManager().addUnit( UnitType.ARCHER, this );
				}
			}
		}
	}
}
