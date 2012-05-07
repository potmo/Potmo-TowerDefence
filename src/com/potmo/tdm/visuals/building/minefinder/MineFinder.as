package com.potmo.tdm.visuals.building.minefinder
{
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapBase;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.unit.Unit;

	import flash.geom.Point;

	public class MineFinder
	{
		public function MineFinder( constructionSites:Vector.<ConstructionSite>, mines:Vector.<Mine>, map:MapBase )
		{

			// TODO: Create a item that holds the mine, the direction to walk in, and the number of steps to get there
			// add the item to each buildingPositionId
			// when a mine is out remove the first item (the closest) so we can return the next closest 
		}


		public function getDirectionToClosestMine( building:Building ):MapMovingDirection
		{
			//TODO: Implement mine direction
			return null;
		}


		public function handleClosedMine( mine:Mine ):void
		{
			//TODO: implement report closed mine
		}
	}
}
