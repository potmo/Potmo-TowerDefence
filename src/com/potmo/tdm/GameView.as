package com.potmo.tdm
{
	import com.potmo.tdm.visuals.buildings.BuildingBase;
	import com.potmo.tdm.visuals.hud.HudBase;
	import com.potmo.tdm.visuals.maps.MapBase;
	import com.potmo.tdm.visuals.maps.MapItem;
	import com.potmo.tdm.visuals.maps.MapZero;
	import com.potmo.tdm.visuals.units.UnitBase;
	import com.potmo.util.input.MouseManager;
	import com.potmo.util.logger.Logger;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * This is the gameview that will contain the map and all the units and so on
	 * It can be slided left and right (panning)
	 */
	public final class GameView extends Sprite
	{

		private static const CAMERA_MOVE_FRICTION:Number = 0.99;
		private static const CAMERA_MOVE_FRICTION_COIFFICIENT:Number = 0.05;

		private static const CLICK_MAX_FRAMES:uint = 6;
		private static const CLICK_MAX_MOVE:uint = 20;

		private var cameraPosition:Number = 0;
		private var cameraVelocity:Number = 0;
		private var isCameraSliding:Boolean = false;

		private var isDragging:Boolean = false;
		private var dragStartMouse:Number = 0;
		private var dragStartCamera:Number = 0;
		private var startDragFrame:uint = 0;

		private var screenSize:Number;

		private var currentFrame:uint = 0;
		private var map:MapBase;

		private var mapCanvas:Sprite;

		private var gameLogics:GameLogics;
		private var orderManager:OrderManager;

		private var hud:HudBase;

		private var ignoreMapInteraction:Boolean = false;

		private var objectsToSort:Vector.<DisplayObject> = new Vector.<DisplayObject>();


		public function GameView( screenSize:uint )
		{
			super();
			this.screenSize = screenSize;
			mapCanvas = new Sprite();
			addChild( mapCanvas );

		}


		public function setGameLogics( gameLogics:GameLogics ):void
		{
			this.gameLogics = gameLogics;
		}


		public function setOrderManager( orderManager:OrderManager ):void
		{
			this.orderManager = orderManager;
		}


		public function setHud( hud:HudBase ):void
		{
			if ( hud )
			{
				removeHud();
			}

			this.hud = hud;
			this.addChild( hud );
		}


		public function removeHud():void
		{
			if ( hud )
			{
				this.removeChild( hud );
				hud = null;
			}
		}


		public function addMap( map:MapBase ):void
		{
			this.map = map;
			mapCanvas.addChild( map );
		}


		public function addUnit( unit:UnitBase ):void
		{
			mapCanvas.addChild( unit );
			objectsToSort.push( unit );
		}


		public function addBuilding( building:BuildingBase ):void
		{
			mapCanvas.addChild( building );
			objectsToSort.push( building );
		}


		public function removeBuilding( building:BuildingBase ):void
		{
			mapCanvas.removeChild( building );
			var index:int = objectsToSort.indexOf( building );
			objectsToSort.splice( index, 1 );
		}


		public function removeUnit( unit:UnitBase ):void
		{
			mapCanvas.removeChild( unit );
			var index:int = objectsToSort.indexOf( unit );
			objectsToSort.splice( index, 1 );
		}


		public function addMapItem( mapItem:MapItem ):void
		{
			mapCanvas.addChild( mapItem );
			objectsToSort.push( mapItem );
		}


		public function removeMapItem( mapItem:MapItem ):void
		{
			mapCanvas.removeChild( mapItem );
			var index:int = objectsToSort.indexOf( mapItem );
			objectsToSort.splice( index, 1 );
		}


		public function update():void
		{

			currentFrame++;

			if ( hud )
			{
				hud.update();
			}

			if ( MouseManager.isDown && !isDragging )
			{
				Logger.log( "StartDrag" );
				isDragging = true;
				dragStartMouse = MouseManager.pos.x;
				dragStartCamera = cameraPosition;
				startDragFrame = currentFrame;

			}

			if ( MouseManager.isDown && isDragging && !ignoreMapInteraction )
			{
				var diff:Number = MouseManager.pos.x - dragStartMouse;
				slideCameraToPosition( dragStartCamera - diff );
				Logger.log( "Move camera: " + diff );
			}
			else if ( !MouseManager.isDown && isDragging )
			{
				isDragging = false;

				var moveDiff:Number = Math.abs( MouseManager.pos.x - dragStartMouse );
				var downTime:int = currentFrame - startDragFrame;

				// check if it was a click or if it was a swipe
				if ( downTime < CLICK_MAX_FRAMES && moveDiff < CLICK_MAX_MOVE )
				{
					var hudTakenClick:Boolean = false;

					// if the hud is clicked then the order manager should handle the later events
					if ( hud )
					{
						Logger.log( "hud was clicked" );
						hudTakenClick = hud.handleClick( MouseManager.pos.x, MouseManager.pos.y, orderManager, gameLogics );
					}

					// if the map is clicked its ok for the gameLogics to handle the click. This can not have any effect on the game outcome
					if ( !hudTakenClick && !ignoreMapInteraction )
					{
						Logger.log( "map was clicked" );
						gameLogics.onMapClicked( cameraPosition + MouseManager.pos.x, MouseManager.pos.y );
					}
				}
				else if ( !ignoreMapInteraction )
				{
					Logger.log( "Stop drag start slide" );
					slideCameraWithVelocity();
				}
			}

			if ( isCameraSliding && !isDragging )
			{
				slideCamera();
			}

			mapCanvas.x = -Math.round( cameraPosition );

			// z sort units and buildings

			zSortObjects();

		}


		private final function zSortObjects():void
		{
			objectsToSort.sort( zSortCompareFunction );

			var e:int = mapCanvas.numChildren - objectsToSort.length;
			var r:int;

			for ( var i:int = objectsToSort.length - 1; i > 0; i-- )
			{
				r = e + i;

				// if the index is wrong then set it right
				if ( objectsToSort[ i ] != mapCanvas.getChildAt( r ) )
				{
					mapCanvas.setChildIndex( objectsToSort[ i ], r );
				}
			}
		}


		private final function zSortCompareFunction( a:DisplayObject, b:DisplayObject ):int
		{
			return ( a.y - b.y );
		}


		private final function slideCamera():void
		{
			// normalize to get velocity
			var cameraDir:int = cameraVelocity / Math.abs( cameraVelocity );

			// both scale the velocity down but also add a coifficient
			cameraVelocity = ( cameraVelocity * CAMERA_MOVE_FRICTION ) - CAMERA_MOVE_FRICTION_COIFFICIENT * cameraVelocity;

			cameraPosition += cameraVelocity;

			// check if it hit any border
			if ( restrictCameraPositon() )
			{
				cameraVelocity = 0;
				isCameraSliding = false;
			}

			// check if its moving to slow and should stop
			if ( Math.abs( cameraVelocity ) <= 1 )
			{
				cameraVelocity = 0;
				isCameraSliding = false;
			}
		}


		/**
		 * Restrict the camerapositon so that it will not be outside the view
		 * @returns true if it was restricted
		 */
		private final function restrictCameraPositon():Boolean
		{
			if ( cameraPosition < 0 )
			{
				cameraPosition = 0;
				return true;
			}

			if ( cameraPosition > map.getMapSize() - screenSize )
			{
				cameraPosition = map.getMapSize() - screenSize;
				return true;
			}

			return false;

		}


		/**
		 * Sliding to a position will immidietly set the position of the camera to the given position
		 * It will also keep in menory the length of the slide so that we can store the valocity
		 * If you call slideCameraWithVelocity() that valocity will be used and slide the camera
		 */
		public function slideCameraToPosition( pos:Number ):void
		{
			Logger.log( "Move camera to: " + pos );
			cameraVelocity = pos - cameraPosition;
			cameraPosition = pos;

			restrictCameraPositon();
		}


		/**
		 * Sliding to a position will immidietly set the position of the camera to the given relative position
		 * It will also keep in menory the length of the slide so that we can store the valocity
		 * If you call slideCameraWithVelocity() that valocity will be used and slide the camera
		 */
		public function slideCameraToRelativePosition( pos:Number ):void
		{
			cameraVelocity = pos;
			cameraPosition = cameraPosition + pos;

			restrictCameraPositon();
		}


		public function slideCameraWithVelocity():void
		{
			isCameraSliding = true;
		}


		public function convertScreenPositionToMapPosition( mousePos:Point ):Point
		{
			return new Point( mousePos.x + cameraPosition, mousePos.y );
		}


		public function startIgnoreMapInteraction():void
		{
			ignoreMapInteraction = true;
		}


		public function stopIgnoreMapInteraction():void
		{
			ignoreMapInteraction = false;
		}

	}
}