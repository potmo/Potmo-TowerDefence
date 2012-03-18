
package com.potmo.tdm.visuals.building
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.variant.Archery;
	import com.potmo.tdm.visuals.building.variant.Camp;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;

	public final class BuildingFactory
	{
		private static var buildingId:uint = 0;
		private var _spriteAtlas:SpriteAtlas;


		public function BuildingFactory( spriteAtlas:SpriteAtlas )
		{
			this._spriteAtlas = spriteAtlas;
		}


		public function getBuilding( type:BuildingType, player:Player ):BuildingBase
		{
			var building:BuildingBase;

			//TODO: There should be some pools here
			switch ( type )
			{
				case BuildingType.CONSTRUCTION_SITE:
					building = new ConstructionSite( _spriteAtlas );
					break;
				case BuildingType.CAMP:
					building = new Camp( _spriteAtlas );
					break;
				case BuildingType.ARCHERY:
					building = new Archery( _spriteAtlas );
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

