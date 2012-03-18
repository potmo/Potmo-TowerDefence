package com.potmo.tdm.visuals.building.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.hud.variant.ConstructionSiteHud;
	import com.potmo.util.logger.Logger;

	/**
	 * The construction site can be built into any other building
	 * This will be built on on places it is possible to build as a placeholder
	 */
	public class ConstructionSite extends BuildingBase
	{

		private static const SEQUENCE_NAME:String = "constructionsite";


		public function ConstructionSite( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas.getSequenceByName( SEQUENCE_NAME ) );

		}


		public override function handleClick( x:int, y:int, gameLogics:GameLogics ):void
		{
			Logger.log( "construction site was clicked" );
			gameLogics.getHudManager().showConstructionSiteHud( this );

		}


		public override function handleClickOutside( x:int, y:int, logics:GameLogics ):void
		{

		}

	}
}
