package com.potmo.tdm.player
{
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.tdm.visuals.map.DeployFlag;
	import com.potmo.tdm.GameLogics;

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
		public function requestConstructBuilding( constructionSite:BuildingBase, type:BuildingType ):void
		{
			// TODO: Let message go over network first
			gameLogics.getBuildingManager().swapBuildingType( constructionSite, type, gameLogics );
			gameLogics.removeHud();
		}


		/**
		 * Request to demolish a building to a construction site
		 */
		public function requestDemolishHouse( building:BuildingBase ):void
		{
			// TODO: Let message go over network first
			gameLogics.getBuildingManager().demolishBuilding( building, gameLogics );
			gameLogics.removeHud();
		}


		/**
		 * Request that all units from this building should attack
		 */
		public function requestAttack( building:BuildingBase ):void
		{
			// TODO: Let message go over network first			
			building.chargeWithAllUnits( gameLogics );
			gameLogics.removeHud();
		}


		/**
		 * Request to upgrade a building to a new level
		 */
		public function requestUpgradeBuilding( building:BuildingBase ):void
		{
			// TODO: Let message go over network first
			gameLogics.getBuildingManager().upgradeBuilding( building, gameLogics );
			gameLogics.removeHud();
		}


		public function requestShowDeployFlag( building:BuildingBase ):void
		{
			gameLogics.showDeployFlag( building );
		}


		public function requestSetDeployFlag( x:int, y:int, building:BuildingBase ):void
		{
			// TODO: Let message go over network first	
			gameLogics.removeHud();
			gameLogics.setDeployFlag( x, y, building );
		}

	}
}
