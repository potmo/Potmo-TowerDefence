package com.potmo.tdm.visuals.building.variant.settings
{
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.tdm.visuals.unit.UnitType;

	public interface BuildingSettings
	{
		function getBuildingType():BuildingType;
		function getCost():int;
		function getDemolishRefund():int;
		function getUnitType():UnitType;
	}
}
