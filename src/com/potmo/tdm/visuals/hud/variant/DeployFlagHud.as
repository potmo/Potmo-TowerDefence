package com.potmo.tdm.visuals.hud.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.GameView;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.hud.HudBase;
	import com.potmo.tdm.visuals.map.DeployFlag;
	import com.potmo.util.input.MouseManager;
	import com.potmo.util.logger.Logger;

	import flash.geom.Point;

	public class DeployFlagHud extends HudBase
	{
		private var _flag:DeployFlag;
		private var _building:BuildingBase;

		private var _affirmButton:BasicRenderItem;
		private var _cancelButton:BasicRenderItem;
		private static const AFFIRM_BUTTON_SEQUENCE:String = "affirmbutton";
		private static const CENCEL_BUTTON_SEQUENCE:String = "cancelbutton";


		public function DeployFlagHud( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas );

			setupGui( spriteAtlas );
		}


		private function setupGui( spriteAtlas:SpriteAtlas ):void
		{
			_affirmButton = new BasicRenderItem( spriteAtlas.getSequenceByName( AFFIRM_BUTTON_SEQUENCE ) );
			_cancelButton = new BasicRenderItem( spriteAtlas.getSequenceByName( CENCEL_BUTTON_SEQUENCE ) );

			addButtonFirst( _affirmButton );
			addButtonFirst( _cancelButton, false );

			// add it later to gameview
			_flag = new DeployFlag( spriteAtlas );
		}


		override public function update( gameLogics:GameLogics ):void
		{
			Logger.log( "updating" );

			//TODO: Make the flag restrict to not be too far from building
			if ( MouseManager.isDown )
			{
				if ( _affirmButton.containsPoint( MouseManager.pos.x, MouseManager.pos.y ) )
				{
					return;
				}

				if ( _cancelButton.containsPoint( MouseManager.pos.x, MouseManager.pos.y ) )
				{
					return;
				}

				var mapPoint:Point = gameLogics.getGameView().convertScreenPositionToMapPosition( MouseManager.pos );
				this._flag.setX( mapPoint.x );
				this._flag.setY( mapPoint.y );
			}
		}


		override public function handleClick( x:int, y:int, orderManager:OrderManager, gameLogics:GameLogics ):Boolean
		{

			if ( _affirmButton.containsPoint( x, y ) )
			{
				//send new positions
				orderManager.requestSetDeployFlag( _flag.getX(), _flag.getY(), _building );

				gameLogics.getHudManager().hideHud();

				// make the map take clicks again
				cleanUp( gameLogics );
			}

			if ( _cancelButton.containsPoint( x, y ) )
			{
				gameLogics.getHudManager().hideHud();

				// make the map take clicks again
				cleanUp( gameLogics );
			}

			return true;
		}


		public function setup( building:BuildingBase, gameView:GameView ):void
		{
			_building = building;

			gameView.startIgnoreMapInteraction();
			gameView.addMapItem( _flag );

			_flag.setX( _building.getDeployFlagX() );
			_flag.setY( _building.getDeployFlagY() );

		}


		private function cleanUp( gameLogics:GameLogics ):void
		{

			gameLogics.getGameView().stopIgnoreMapInteraction();
			gameLogics.getGameView().removeMapItem( _flag );
		}


		override public function clear():void
		{
			super.clear();

			_building = null;
		}

	}
}
