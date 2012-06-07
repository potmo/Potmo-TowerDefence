package com.potmo.tdm.visuals.building.variant.settings
{
	import com.potmo.tdm.visuals.building.BuildingType;

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
	}
}
