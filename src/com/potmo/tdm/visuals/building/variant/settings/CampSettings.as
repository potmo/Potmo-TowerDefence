package com.potmo.tdm.visuals.building.variant.settings
{
	import com.potmo.tdm.visuals.building.BuildingType;

	public class CampSettings implements BuildingSettings
	{
		public function CampSettings()
		{
		}


		public function getBuildingType():BuildingType
		{
			return BuildingType.CAMP;
		}


		public function getCost():int
		{
			return 200;
		}


		public function getDemolishRefund():int
		{
			return 50;
		}
	}
}
