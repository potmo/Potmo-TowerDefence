package com.potmo.tdm.visuals.hud
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.OrderManager;
	import com.potmo.tdm.asset.button.KeepButton_Asset;
	import com.potmo.tdm.visuals.ScreenSize;
	import com.potmo.tdm.visuals.buildings.Camp;
	import com.potmo.util.image.BitmapAnimation;
	import com.potmo.util.image.BitmapAnimationCacheObject;

	public class CampHud extends BuildingBaseHud
	{

		private static const keepButtonGraphics:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new KeepButton_Asset() );
		private var keepButton:BitmapAnimation;
		private var camp:Camp;


		public function CampHud( camp:Camp )
		{
			super( camp );
			this.camp = camp;
			setupGui();
		}


		override protected function setupGui():void
		{
			super.setupGui();
			keepButton = new BitmapAnimation( keepButtonGraphics );

			addButtonLast( keepButton );
		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{

			if ( keepButton.getRect( this ).contains( x, y ) )
			{
				orderManager.requestUpgradeBuilding( camp );
				return true;
			}
			return super.handleClick( x, y, orderManager, gameLogics );
		}

	}
}