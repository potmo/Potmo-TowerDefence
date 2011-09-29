package com.potmo.tdm.visuals.buildings
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.asset.building.ConstructionSite_Asset;
	import com.potmo.tdm.visuals.hud.ConstructionSiteHud;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.util.logger.Logger;

	/**
	 * The construction site can be built into any other building
	 * This will be built on on places it is possible to build as a placeholder
	 */
	public class ConstructionSite extends BuildingBase
	{

		private static const graphics:TextureAnimationCacheObject = new TextureAnimationCacheObject( new ConstructionSite_Asset() );


		public function ConstructionSite()
		{
			super( graphics );
		}


		public override function handleClick( x:int, y:int, logics:GameLogics ):void
		{
			Logger.log( "construction site was clicked" );
			logics.setHud( new ConstructionSiteHud( this ) );

		}


		public override function handleClickOutside( x:int, y:int, logics:GameLogics ):void
		{

		}

	}
}
