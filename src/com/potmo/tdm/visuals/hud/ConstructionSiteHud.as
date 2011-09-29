package com.potmo.tdm.visuals.hud
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.OrderManager;
	import com.potmo.tdm.asset.button.ArcheryButton_Asset;
	import com.potmo.tdm.asset.button.CampButton_Asset;
	import com.potmo.tdm.visuals.ScreenSize;
	import com.potmo.tdm.visuals.buildings.BuildingBase;
	import com.potmo.tdm.visuals.buildings.BuildingType;
	import com.potmo.tdm.visuals.buildings.ConstructionSite;
	import com.potmo.util.image.BitmapAnimation;
	import com.potmo.util.image.BitmapAnimationCacheObject;
	import com.potmo.util.image.BitmapUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ConstructionSiteHud extends HudBase
	{

		private static const campButtonGraphics:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new CampButton_Asset() );
		private static const archeryButtonGraphics:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new ArcheryButton_Asset() );

		private var constructionSite:ConstructionSite;

		private var campButton:BitmapAnimation;
		private var archeryButton:BitmapAnimation;


		public function ConstructionSiteHud( constructionSite:ConstructionSite )
		{
			super();

			this.constructionSite = constructionSite;
			this.setupGui();
		}


		private function setupGui():void
		{
			campButton = new BitmapAnimation( campButtonGraphics );
			archeryButton = new BitmapAnimation( archeryButtonGraphics );

			addButtonLast( campButton );
			addButtonLast( archeryButton );
		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			// check if it was a click on the castle button
			if ( campButton.getRect( this ).contains( x, y ) )
			{
				orderManager.requestConstructBuilding( constructionSite, BuildingType.CAMP );
				return true;
			}

			if ( archeryButton.getRect( this ).contains( x, y ) )
			{
				orderManager.requestConstructBuilding( constructionSite, BuildingType.ARCHERY );
				return true;
			}
			return false;
		}

	}
}