package com.potmo.tdm.visuals.building.variant.settings
{
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.tdm.visuals.unit.UnitType;

	public class ArcherySettings implements BuildingSettings
	{
		public function ArcherySettings()
		{
		}


		public function getBuildingType():BuildingType
		{
			return BuildingType.ARCHERY;
		}


		public function getCost():int
		{
			return 500;
		}


		public function getDemolishRefund():int
		{
			return 100;
		}


		public function getUnitType():UnitType
		{
			//TODO: Implement so that archery can build units
			return null;
		}
	}
}
