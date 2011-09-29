package com.potmo.tdm.visuals.hud
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.GameView;
	import com.potmo.tdm.OrderManager;
	import com.potmo.tdm.asset.button.AffirmButton_Asset;
	import com.potmo.tdm.asset.button.CancelButton_Asset;
	import com.potmo.tdm.visuals.buildings.BuildingBase;
	import com.potmo.tdm.visuals.maps.DeployFlag;
	import com.potmo.util.image.BitmapAnimation;
	import com.potmo.util.image.BitmapAnimationCacheObject;
	import com.potmo.util.input.MouseManager;

	import flash.geom.Point;

	public class DeployFlagHud extends HudBase
	{
		private var flag:DeployFlag;
		private var building:BuildingBase;
		private var gameView:GameView;

		public static const AFFIRM_BUTTON_GRAPHICS:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new AffirmButton_Asset() );
		public static const CANCEL_BUTTON_GRAPHICS:BitmapAnimationCacheObject = new BitmapAnimationCacheObject( new CancelButton_Asset() );

		private var affirmButton:BitmapAnimation;
		private var cancelButton:BitmapAnimation;


		public function DeployFlagHud( flag:DeployFlag, building:BuildingBase, gameView:GameView )
		{
			super();
			this.flag = flag;
			this.building = building;
			this.gameView = gameView;

			this.flag.x = building.getDeployFlagX();
			this.flag.y = building.getDeployFlagY();

			// stop the map from getting clicks
			gameView.startIgnoreMapInteraction();

			affirmButton = new BitmapAnimation( AFFIRM_BUTTON_GRAPHICS );
			cancelButton = new BitmapAnimation( CANCEL_BUTTON_GRAPHICS );

			addButtonFirst( affirmButton );
			addButtonFirst( cancelButton, false );
		}


		override public function update():void
		{
			if ( MouseManager.isDown )
			{
				if ( affirmButton.getRect( this ).contains( MouseManager.pos.x, MouseManager.pos.y ) )
				{
					return;
				}

				if ( cancelButton.getRect( this ).contains( MouseManager.pos.x, MouseManager.pos.y ) )
				{
					return;
				}
				var mapPoint:Point = gameView.convertScreenPositionToMapPosition( MouseManager.pos );
				this.flag.x = mapPoint.x;
				this.flag.y = mapPoint.y;
			}
		}


		override public function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{
			if ( affirmButton.getRect( this ).contains( x, y ) )
			{
				//send new positions
				orderManager.requestSetDeployFlag( flag.x, flag.y, building );

				gameView.removeMapItem( flag );

				// make the map take clicks again
				gameView.stopIgnoreMapInteraction();
				return true;
			}

			if ( cancelButton.getRect( this ).contains( x, y ) )
			{
				gameView.removeMapItem( flag );
				gameLogics.removeHud();

				// make the map take clicks again
				gameView.stopIgnoreMapInteraction();
				return true;
			}

			return false;
		}

	}
}