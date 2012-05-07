package com.potmo.tdm.player
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.map.DeployFlag;

	public class OrderManager
	{
		private var gameLogics:GameLogics;


		public function OrderManager()
		{

		}


		public function setGameLogics( gameLogics:GameLogics ):void
		{
			this.gameLogics = gameLogics;
		}


		/**
		 * Request to build a building on a construction site
		 */
		public function requestConstructBuilding( constructionSite:ConstructionSite, type:BuildingType ):void
		{
			// TODO: Let message go over network first
			gameLogics.getBuildingManager().buildBuildingOfTypeOnConstructionSite( type, constructionSite, gameLogics );
		}


		/**
		 * Request to demolish a building to a construction site
		 */
		public function requestDemolishBuilding( building:Building ):void
		{
			// TODO: Let message go over network first
			gameLogics.getBuildingManager().demolishBuilding( building, gameLogics );
		}


		/**
		 * Request that all units from this building should attack
		 */
		public function requestAttack( building:Building ):void
		{
			// TODO: Let message go over network first			
			building.chargeWithAllUnits( gameLogics );
		}


		/**
		 * Request to upgrade a building to a new level
		 */
		public function requestUpgradeBuilding( building:Building ):void
		{
			// TODO: Let message go over network first
			gameLogics.getBuildingManager().upgradeBuilding( building, gameLogics );
		}


		public function requestSetDeployFlag( x:int, y:int, building:Building ):void
		{
			// TODO: Let message go over network first	
			gameLogics.getBuildingManager().setDeployFlag( x, y, building, gameLogics );
		}

	}
}
