package com.potmo.tdm.visuals.building.variant.settings
{
	import com.potmo.tdm.visuals.building.BuildingType;

	public interface BuildingSettings
	{
		function getBuildingType():BuildingType;
		function getCost():int;
		function getDemolishRefund():int;
	}
}
