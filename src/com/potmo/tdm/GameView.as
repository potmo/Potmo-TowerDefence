package com.potmo.tdm
{
	import com.potmo.p2d.renderer.P2DCamera;
	import com.potmo.p2d.renderer.Renderable;
	import com.potmo.p2d.renderer.Renderer;
	import com.potmo.tdm.display.ZSortableRenderContainer;
	import com.potmo.tdm.player.OrderManager;
	import com.potmo.tdm.visuals.ScreenSize;
	import com.potmo.tdm.visuals.building.BuildingBase;
	import com.potmo.tdm.visuals.hud.HudBase;
	import com.potmo.tdm.visuals.map.MapBase;
	import com.potmo.tdm.visuals.map.MapItem;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.tdm.visuals.unit.projectile.Projectile;
	import com.potmo.util.input.MouseManager;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	import flash.geom.Point;

	/**
	 * This is the gameview that will contain the map and all the units and so on
	 * It can be slided left and right (panning)
	 */
	public final class GameView implements Renderable
	{

		private static const CAMERA_MOVE_FRICTION:Number = 0.99;
		private static const CAMERA_MOVE_FRICTION_COIFFICIENT:Number = 0.05;

		private static const CLICK_MAX_FRAMES:uint = 6;
		private static const CLICK_MAX_MOVE:uint = 20;

		private var _cameraVelocity:Number = 0;
		private var _isCameraSliding:Boolean = false;

		private var _isDragging:Boolean = false;
		private var _dragStartMouse:Number = 0;
		private var _dragStartCamera:Number = 0;
		private var _startDragFrame:uint = 0;

		private var _currentFrame:uint = 0;
		private var _map:MapBase;

		private var _inbetweenItems:ZSortableRenderContainer;

		private var _gameLogics:GameLogics;
		private var _orderManager:OrderManager;

		private var _hud:HudBase;

		private var _ignoreMapInteraction:Boolean = false;
		private var _camera:P2DCamera;


		public function GameView( camera:P2DCamera )
		{
			_inbetweenItems = new ZSortableRenderContainer();
			_camera = camera;
		}


		public function setGameLogics( gameLogics:GameLogics ):void
		{
			this._gameLogics = gameLogics;
		}


		public function setOrderManager( orderManager:OrderManager ):void
		{
			this._orderManager = orderManager;
		}


		public function setHud( hud:HudBase ):void
		{
			if ( _hud )
			{
				removeHud();
			}

			_hud = hud;
		}


		public function removeHud():void
		{
			if ( _hud )
			{
				_hud = null;
			}
		}


		public function addMap( map:MapBase ):void
		{
			this._map = map;

		}


		public function addUnit( unit:Unit ):void
		{
			_inbetweenItems.addChild( unit );

		}


		public function removeUnit( unit:Unit ):void
		{
			_inbetweenItems.removeChild( unit );

		}


		public function addBuilding( building:BuildingBase ):void
		{
			_inbetweenItems.addChild( building );

		}


		public function removeBuilding( building:BuildingBase ):void
		{
			_inbetweenItems.removeChild( building );

		}


		public function addProjectile( projectile:Projectile ):void
		{
			_inbetweenItems.addChild( projectile );
		}


		public function removeProjectile( projectile:Projectile ):void
		{
			_inbetweenItems.removeChild( projectile );
		}


		public function addMapItem( mapItem:MapItem ):void
		{
			_inbetweenItems.addChild( mapItem );

		}


		public function removeMapItem( mapItem:MapItem ):void
		{
			_inbetweenItems.removeChild( mapItem );

		}


		public function update():void
		{

			_currentFrame++;

			if ( MouseManager.isDown && !_isDragging )
			{
				Logger.log( "StartDrag" );
				_isDragging = true;
				_dragStartMouse = MouseManager.pos.x;
				_dragStartCamera = _camera.getCameraX();
				_startDragFrame = _currentFrame;

			}

			if ( MouseManager.isDown && _isDragging && !_ignoreMapInteraction )
			{
				var diff:Number = MouseManager.pos.x - _dragStartMouse;
				slideCameraToPosition( _dragStartCamera - diff );
					//Logger.log( "Move camera: " + diff );
			}
			else if ( !MouseManager.isDown && _isDragging )
			{
				_isDragging = false;

				var moveDiff:Number = Math.abs( MouseManager.pos.x - _dragStartMouse );
				var downTime:int = _currentFrame - _startDragFrame;

				// check if it was a click or if it was a swipe
				if ( downTime < CLICK_MAX_FRAMES && moveDiff < CLICK_MAX_MOVE )
				{
					var hudTakenClick:Boolean = false;

					// if the hud is clicked then the order manager should handle the later events
					if ( _hud )
					{
						Logger.log( "hud was clicked" );
						hudTakenClick = _hud.handleClick( MouseManager.pos.x + _camera.getCameraX(), MouseManager.pos.y, _orderManager, _gameLogics );

					}

					// if the map is clicked its ok for the gameLogics to handle the click. This can not have any effect on the game outcome
					if ( !hudTakenClick && !_ignoreMapInteraction )
					{
						Logger.log( "map was clicked" );
						_gameLogics.onMapClicked( MouseManager.pos.x + _camera.getCameraX(), MouseManager.pos.y );
					}
				}
				else if ( !_ignoreMapInteraction )
				{
					Logger.log( "Stop drag start slide" );
					slideCameraWithVelocity();
				}
			}

			if ( _isCameraSliding && !_isDragging )
			{
				slideCamera();
			}

			//_map.setX( -StrictMath.round( camera ) );

			// z sort units and buildings

			_inbetweenItems.sortDepth();

		}


		public function render( renderer:Renderer ):void
		{
			if ( _map )
			{
				_map.render( renderer );
			}
			_inbetweenItems.render( renderer );

			if ( _hud )
			{
				_hud.render( renderer );
			}
		}


		private final function slideCamera():void
		{
			// normalize to get velocity
			var cameraDir:int = _cameraVelocity / Math.abs( _cameraVelocity );

			// both scale the velocity down but also add a coifficient
			_cameraVelocity = ( _cameraVelocity * CAMERA_MOVE_FRICTION ) - CAMERA_MOVE_FRICTION_COIFFICIENT * _cameraVelocity;

			_camera.setCameraX( _camera.getCameraX() + _cameraVelocity );

			// check if it hit any border
			if ( restrictCameraPositon() )
			{
				_cameraVelocity = 0;
				_isCameraSliding = false;
			}

			// check if its moving to slow and should stop
			if ( Math.abs( _cameraVelocity ) <= 1 )
			{
				_cameraVelocity = 0;
				_isCameraSliding = false;
			}
		}


		/**
		 * Restrict the camerapositon so that it will not be outside the view
		 * @returns true if it was restricted
		 */
		private final function restrictCameraPositon():Boolean
		{
			if ( _camera.getCameraX() < 0 )
			{
				_camera.setCameraX( 0 );
				return true;
			}

			if ( _camera.getCameraX() > _map.getMapWidth() - ScreenSize.WIDTH )
			{
				_camera.setCameraX( _map.getMapWidth() - ScreenSize.WIDTH );
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
			_cameraVelocity = pos - _camera.getCameraX();
			_camera.setCameraX( pos );

			restrictCameraPositon();
		}


		/**
		 * Sliding to a position will immidietly set the position of the camera to the given relative position
		 * It will also keep in menory the length of the slide so that we can store the valocity
		 * If you call slideCameraWithVelocity() that valocity will be used and slide the camera
		 */
		public function slideCameraToRelativePosition( pos:Number ):void
		{
			_cameraVelocity = pos;
			_camera.setCameraX( _camera.getCameraX() + pos );

			restrictCameraPositon();
		}


		public function slideCameraWithVelocity():void
		{
			_isCameraSliding = true;
		}


		public function convertScreenPositionToMapPosition( mousePos:Point ):Point
		{
			return new Point( mousePos.x + _camera.getCameraX(), mousePos.y );
		}


		public function startIgnoreMapInteraction():void
		{
			_ignoreMapInteraction = true;
		}


		public function stopIgnoreMapInteraction():void
		{
			_ignoreMapInteraction = false;
		}


		public function getCameraPosition():Number
		{
			return _camera.getCameraX();
		}

	}
}
