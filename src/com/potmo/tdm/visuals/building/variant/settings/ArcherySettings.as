package com.potmo.tdm.visuals.building.variant.settings
{
	import com.potmo.tdm.visuals.building.BuildingType;

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
	}
}
