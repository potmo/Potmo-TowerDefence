package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.BuildingFactory;
	import com.potmo.tdm.visuals.building.BuildingType;

	public class Archery extends BuildingBase implements Building
	{

		private static const UNIT_DEPLOY_DELAY:uint = 30;
		private var unitDeployCountdown:uint = UNIT_DEPLOY_DELAY;
		private static const SEQUENCE_NAME:String = "archery";


		public function Archery( spriteAtlas:SpriteAtlas )
		{
			super( BuildingType.ARCHERY, spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );
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
				unitDeployCountdown--;

				if ( unitDeployCountdown == 0 )
				{
					unitDeployCountdown = UNIT_DEPLOY_DELAY;
						//gameLogics.getUnitManager().addUnit( UnitType.ARCHER, this );
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
