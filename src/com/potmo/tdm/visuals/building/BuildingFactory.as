package com.potmo.tdm.visuals.building
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.variant.Archery;
	import com.potmo.tdm.visuals.building.variant.Camp;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.building.variant.MinersHut;

	public final class BuildingFactory
	{
		private var _spriteAtlas:SpriteAtlas;


		public function BuildingFactory( spriteAtlas:SpriteAtlas )
		{
			this._spriteAtlas = spriteAtlas;
		}


		public function getConstructionSite( player:Player, startX:Number, startY:Number, positionId:ConstructionSiteId, gameLogics:GameLogics ):ConstructionSite
		{
			var building:ConstructionSite = new ConstructionSite( _spriteAtlas );
			initializeBuilding( building, player, startX, startY, positionId, gameLogics );
			return building;
		}


		public function getMine( player:Player, startX:Number, startY:Number, positionId:ConstructionSiteId, gameLogics:GameLogics ):Mine
		{
			var building:Mine = new Mine( _spriteAtlas );
			initializeBuilding( building, player, startX, startY, positionId, gameLogics );
			return building;
		}


		public function getCamp( player:Player, startX:Number, startY:Number, positionId:ConstructionSiteId, gameLogics:GameLogics ):Camp
		{
			var building:Camp = new Camp( _spriteAtlas );
			initializeBuilding( building, player, startX, startY, positionId, gameLogics );
			return building;
		}


		public function getMinersHut( player:Player, startX:Number, startY:Number, positionId:ConstructionSiteId, gameLogics:GameLogics ):MinersHut
		{
			var building:MinersHut = new MinersHut( _spriteAtlas );
			initializeBuilding( building, player, startX, startY, positionId, gameLogics );
			return building;
		}


		public function getArchery( player:Player, startX:Number, startY:Number, positionId:ConstructionSiteId, gameLogics:GameLogics ):Archery
		{
			var building:Archery = new Archery( _spriteAtlas );
			initializeBuilding( building, player, startX, startY, positionId, gameLogics );
			return building;
		}


		private function initializeBuilding( building:Building, player:Player, startX:Number, startY:Number, positionId:ConstructionSiteId, gameLogics:GameLogics ):void
		{
			building.setOwningPlayer( player );
			building.setConstructionSiteId( positionId );
			building.setX( startX );
			building.setY( startY );
			building.init( gameLogics );

		}


		public function returnBuilding( building:Building, gameLogics:GameLogics ):void
		{
			//TODO: Implement a factory with buffers for buildings
			building.reset( gameLogics );
		}
	}
}

