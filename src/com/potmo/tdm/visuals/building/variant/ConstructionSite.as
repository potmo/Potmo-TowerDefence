package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.building.BuildingFactory;
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.util.logger.Logger;

	/**
	 * The construction site can be built into any other building
	 * This will be built on on places it is possible to build as a placeholder
	 */
	public class ConstructionSite extends BuildingBase implements Building
	{

		private static const SEQUENCE_NAME:String = "constructionsite";


		public function ConstructionSite( spriteAtlas:SpriteAtlas )
		{
			super( BuildingType.CONSTRUCTION_SITE, spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );

		}


		public function getUpgrade( buildingFactory:BuildingFactory ):Building
		{
			return null;
		}


		public function handleClick( x:int, y:int, gameLogics:GameLogics ):void
		{
			Logger.log( "construction site was clicked" );
			gameLogics.getHudManager().showConstructionSiteHud( this );

		}


		public function handleClickOutside( x:int, y:int, logics:GameLogics ):void
		{

		}


		public function reset( gameLogics:GameLogics ):void
		{
		}


		public function init( gameLogics:GameLogics ):void
		{
		}


		public function update( gameLogics:GameLogics ):void
		{
		}


		public function buildBuildingOfType( type:BuildingType, buildingFactory:BuildingFactory, gameLogics:GameLogics ):Building
		{
			switch ( type )
			{
				case BuildingType.CAMP:
					return buildingFactory.getCamp( getOwningPlayer(), getX(), getY(), getConstructionSiteId(), gameLogics );
				case BuildingType.ARCHERY:
					return buildingFactory.getArchery( getOwningPlayer(), getX(), getY(), getConstructionSiteId(), gameLogics );
				case BuildingType.MINERS_HUT:
					return buildingFactory.getMinersHut( getOwningPlayer(), getX(), getY(), getConstructionSiteId(), gameLogics );

			}

			throw new Error( "Can not build building of type: " + type );
		}
	}
}
