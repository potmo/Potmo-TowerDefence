package com.potmo.tdm.visuals.hud
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.asset.button.ArcheryButton_Asset;
	import com.potmo.tdm.asset.button.CampButton_Asset;
	import com.potmo.tdm.visuals.building.BuildingType;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.starling.TextureAnimation;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;

	public class ConstructionSiteHud extends HudBase
	{

		private static const campButtonGraphics:TextureAnimationCacheObject = new TextureAnimationCacheObject( new CampButton_Asset() );
		private static const archeryButtonGraphics:TextureAnimationCacheObject = new TextureAnimationCacheObject( new ArcheryButton_Asset() );

		private var constructionSite:ConstructionSite;

		private var campButton:TextureAnimation;
		private var archeryButton:TextureAnimation;


		public function ConstructionSiteHud( constructionSite:ConstructionSite )
		{
			super();

			this.constructionSite = constructionSite;
			this.setupGui();
		}


		private function setupGui():void
		{
			campButton = new TextureAnimation( campButtonGraphics );
			archeryButton = new TextureAnimation( archeryButtonGraphics );

			addButtonLast( campButton );
			addButtonLast( archeryButton );
		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			// check if it was a click on the castle button
			if ( campButton.getBounds( this ).contains( x, y ) )
			{
				orderManager.requestConstructBuilding( constructionSite, BuildingType.CAMP );
				return true;
			}

			if ( archeryButton.getBounds( this ).contains( x, y ) )
			{
				orderManager.requestConstructBuilding( constructionSite, BuildingType.ARCHERY );
				return true;
			}
			return false;
		}

	}
}
