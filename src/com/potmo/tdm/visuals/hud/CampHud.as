package com.potmo.tdm.visuals.hud
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.OrderManager;
	import com.potmo.tdm.asset.button.KeepButton_Asset;
	import com.potmo.tdm.visuals.buildings.Camp;
	import com.potmo.tdm.visuals.starling.TextureAnimation;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;

	public class CampHud extends BuildingBaseHud
	{

		private static const keepButtonGraphics:TextureAnimationCacheObject = new TextureAnimationCacheObject( new KeepButton_Asset() );
		private var keepButton:TextureAnimation;
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
			keepButton = new TextureAnimation( keepButtonGraphics );

			addButtonLast( keepButton );
		}


		public override function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{

			if ( keepButton.getBounds( this ).contains( x, y ) )
			{
				orderManager.requestUpgradeBuilding( camp );
				return true;
			}
			return super.handleClick( x, y, orderManager, gameLogics );
		}

	}
}
