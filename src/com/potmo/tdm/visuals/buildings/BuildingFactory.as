
package com.potmo.tdm.visuals.buildings
{
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.buildings.BuildingBase;

	public final class BuildingFactory
	{
		private static var buildingId:uint = 0;


		public function getBuilding( type:BuildingType, player:Player ):BuildingBase
		{
			var building:BuildingBase;

			switch ( type )
			{
				case BuildingType.CONSTRUCTION_SITE:
					building = new ConstructionSite();
					break;
				case BuildingType.CAMP:
					building = new Camp();
					break;
				case BuildingType.ARCHERY:
					building = new Archery();
					break;
				default:
					throw new Error( "Not possible to create building of type: " + type );
			}

			building.setType( type );
			building.setOwningPlayer( player );
			building.setUniqueId( buildingId );

			buildingId++;

			return building;
		}


		public function returnBuilding( building:BuildingBase ):void
		{
			//TODO: Implement a factory with buffers for buildings

		}
	}
}

