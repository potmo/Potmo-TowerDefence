package com.potmo.tdm.visuals.building.variant.settings
{
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.tdm.visuals.unit.UnitType;

	public class MinersHutSettings implements BuildingSettings
	{
		public function MinersHutSettings()
		{
		}


		public function getBuildingType():BuildingType
		{
			return BuildingType.MINERS_HUT;
		}


		public function getCost():int
		{
			return 200;
		}


		public function getDemolishRefund():int
		{
			return 50;
		}


		public function getUnitType():UnitType
		{
			return UnitType.MINER;
		}
	}
}
