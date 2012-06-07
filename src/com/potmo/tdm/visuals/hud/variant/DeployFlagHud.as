package com.potmo.tdm.visuals.hud.variant
{
	import com.potmo.p2d.atlas.animation.SpriteAtlas;
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.GameView;
	import com.potmo.tdm.display.BasicRenderItem;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.visuals.building.Building;
	import com.potmo.tdm.visuals.hud.HudBase;
	import com.potmo.tdm.visuals.hud.HudButton;
	import com.potmo.tdm.visuals.map.DeployFlag;
	import com.potmo.util.input.MouseManager;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	import flash.geom.Point;

	public class DeployFlagHud extends HudBase
	{
		private static const AFFIRM_BUTTON_SEQUENCE:String = "affirmbutton";
		private static const CENCEL_BUTTON_SEQUENCE:String = "cancelbutton";

		private var _flag:DeployFlag;
		private var _building:Building;

		private var _affirmButton:HudButton;
		private var _cancelButton:HudButton;
		private var _lastOkX:int;
		private var _lastOkY:int;
		private var _maxDistanceFromBuilding:Number;
		private var _dragging:Boolean;


		public function DeployFlagHud( spriteAtlas:SpriteAtlas )
		{
			super( spriteAtlas );

			setupGui( spriteAtlas );
		}


		private function setupGui( spriteAtlas:SpriteAtlas ):void
		{
			_affirmButton = new HudButton( spriteAtlas.getSequenceByName( AFFIRM_BUTTON_SEQUENCE ) );
			_cancelButton = new HudButton( spriteAtlas.getSequenceByName( CENCEL_BUTTON_SEQUENCE ) );

			addButtonFirst( _affirmButton );
			addButtonFirst( _cancelButton, false );

			// add it later to gameview
			_flag = new DeployFlag( spriteAtlas );
		}


		override public function update( gameLogics:GameLogics ):void
		{
			Logger.log( "updating" );
			var okToDrop:Boolean;

			if ( MouseManager.isDown )
			{
				_dragging = true;

				var mapPoint:Point = gameLogics.getGameView().convertScreenPositionToMapPosition( MouseManager.pos );

				if ( _affirmButton.containsPoint( mapPoint.x, mapPoint.y ) )
				{
					return;
				}

				if ( _cancelButton.containsPoint( mapPoint.x, mapPoint.y ) )
				{
					return;
				}

				_flag.setX( mapPoint.x );
				_flag.setY( mapPoint.y );

				restrictFlagPositionToWithingMaxDistanceFromBuilding();

			}
			else if ( !MouseManager.isDown && _dragging )
			{
				// check if it is ok to put it here

				okToDrop = isOkToDropFlagAtPos( _flag.getX(), _flag.getY(), gameLogics );

				if ( okToDrop )
				{
					_lastOkX = _flag.getX();
					_lastOkY = _flag.getY();
				}
				else
				{
					// put back to position
					_flag.setX( _lastOkX );
					_flag.setY( _lastOkY );
				}
			}

			setAlphaOnFlagIfOkToDrop( gameLogics );
		}


		private function restrictFlagPositionToWithingMaxDistanceFromBuilding():void
		{
			// restrict flag to be within max distance
			var buildingPosX:Number = _building.getX();
			var buildingPosY:Number = _building.getY();
			var flagPosX:Number = _flag.getX();
			var flagPosY:Number = _flag.getY();

			var dist:Number = StrictMath.distSquared( buildingPosX, buildingPosY, flagPosX, flagPosY );

			if ( dist > _maxDistanceFromBuilding * _maxDistanceFromBuilding )
			{
				// scale vector to point to be max dist
				var dx:Number = flagPosX - buildingPosX;
				var dy:Number = flagPosY - buildingPosY;

				dist = StrictMath.sqrt( dist );
				// we expect dist to be not zero
				dx /= dist;
				dy /= dist;

				dx *= _maxDistanceFromBuilding;
				dy *= _maxDistanceFromBuilding;

				this._flag.setX( buildingPosX + dx );
				this._flag.setY( buildingPosY + dy );
			}
			else
			{
				// do not have to do anything. Already at a good position
			}

		}


		private function setAlphaOnFlagIfOkToDrop( gameLogics:GameLogics ):void
		{
			var okToDrop:Boolean = isOkToDropFlagAtPos( _flag.getX(), _flag.getY(), gameLogics );

			if ( okToDrop )
			{
				_flag.setAlpha( 1.0 );
			}
			else
			{
				_flag.setAlpha( 0.5 );
			}
		}


		private function isOkToDropFlagAtPos( x:Number, y:Number, gameLogics:GameLogics ):Boolean
		{
			return gameLogics.getMap().isPositionWalkable( x, y, _building.getOwningPlayer().getDefaultMovingDirection() );
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


		public function setup( building:Building, gameView:GameView ):void
		{
			_building = building;

			gameView.startIgnoreMapInteraction();
			gameView.addMapItem( _flag );

			_lastOkX = _building.getDeployFlagX();
			_lastOkY = _building.getDeployFlagY();
			_maxDistanceFromBuilding = _building.getDeployFlagMaxDistanceFromBuilding();

			_flag.setX( _building.getDeployFlagX() );
			_flag.setY( _building.getDeployFlagY() );

			_flag.setAlpha( 1 );

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
			_lastOkX = 0;
			_lastOkY = 0;
			_maxDistanceFromBuilding = 0;
			_dragging = false;
		}

	}
}
