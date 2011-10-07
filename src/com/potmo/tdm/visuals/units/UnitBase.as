package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.buildings.BuildingBase;
	import com.potmo.tdm.visuals.maps.PathCheckpoint;
	import com.potmo.tdm.visuals.starling.TextureAnimation;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.util.math.StrictMath;

	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;

	public class UnitBase extends DisplayObjectContainer
	{

		private var _type:UnitType;

		private var _owningPlayer:Player;
		private var _state:UnitState = UnitState.NONE;

		protected var targetedByUnits:Vector.<FightingUnitBase> = new Vector.<FightingUnitBase>();

		//TODO: Make all the protected fields be getter functions to be implemeted by UnitImlementation
		protected var walkingSpeed:Number = 3; // set to other in subclass if you like
		protected var radius:Number = 10;
		protected var maxHealth:int = 15;

		protected var healDelay:int = 15;

		private var _currentCheckpoint:PathCheckpoint = null; // when null it will look for the closest checkpoint on walk()

		private var _health:int = maxHealth;

		private var _framesToNextHeal:int = healDelay;

		private var _x:Number = 0;
		private var _y:Number = 0;

		private var _velx:Number;
		private var _vely:Number;

		private var _deployFlagX:int;
		private var _deployFlagY:int;

		private var _pathOffsetX:int;
		private var _pathOffsetY:int;

		private var _mainGraphics:TextureAnimation;
		private var _healthBarBackground:Quad;
		private var _healthBar:Quad;

		private var _homeBuilding:BuildingBase;

		private static const HEALTH_BAR_HEIGHT:int = 6;
		private static const HEALTH_BAR_WIDTH:int = 20;


		public function UnitBase( graphics:TextureAnimationCacheObject )
		{
			_mainGraphics = new TextureAnimation( graphics );
			this.addChild( _mainGraphics );

			_healthBarBackground = new Quad( HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT, 0xFFCCCCCC );
			_healthBarBackground.x = -_healthBarBackground.width / 2;
			_healthBarBackground.y = -_mainGraphics.height - _healthBarBackground.height;
			this.addChild( _healthBarBackground );

			_healthBar = new Quad( HEALTH_BAR_WIDTH - 2, HEALTH_BAR_HEIGHT - 2, 0xFF00CC00 );
			_healthBar.x = _healthBarBackground.x + 1;
			_healthBar.y = _healthBarBackground.y + 1;
			this.addChild( _healthBar );
		}


		public function reset():void
		{
			changeState( UnitState.NONE );

			targetedByUnits.splice( 0, targetedByUnits.length );

			_owningPlayer = null;
			_currentCheckpoint = null;
			_velx = 0;
			_vely = 0;
			_deployFlagX = 0;
			_deployFlagY = 0;
			_x = 0;
			_y = 0;
			_pathOffsetX = 0;
			_pathOffsetY = 0;
			setHealth( maxHealth );
			_homeBuilding = null;
		}


		public function setOwningPlayer( owningPlayer:Player ):void
		{
			this._owningPlayer = owningPlayer;

			if ( owningPlayer.isMe() )
			{
				this._mainGraphics.color = 0xFFFF0000;
			}
			else
			{
				this._mainGraphics.color = 0xFF0000FF;
			}

		}


		public function getOwningPlayer():Player
		{
			return _owningPlayer;
		}


		/**
		 * Return the current checkpoint that the unit is aiming for.
		 * @return null if current checkpoint is not known else the checkpoint
		 */
		public function getCurrentCheckpoint():PathCheckpoint
		{
			return _currentCheckpoint;
		}


		public function update( gameLogics:GameLogics ):void
		{
			// switch state for units
			switch ( _state )
			{
				case ( UnitState.NONE ):
				{
					calculateAndSetVelocityTowardsDeployArea();
					changeState( UnitState.DEPLOYING );
					break;
				}

			}

			_mainGraphics.nextFrame();
		}


		protected function onIdleUnit():void
		{
			_framesToNextHeal--;

			if ( _framesToNextHeal <= 0 )
			{
				this.heal();
				_framesToNextHeal = healDelay;
			}
		}


		/**
		 * Walk towards the next checkpoint.
		 * If there are no checkpoint this function will get one
		 */
		protected function walkToNextCheckpoint( gameLogics:GameLogics ):void
		{

			if ( !_currentCheckpoint )
			{
				updateCheckpoint( gameLogics );
			}

			walk();

			if ( StrictMath.isCloseEnough( this.x, this.y, _currentCheckpoint.x + _pathOffsetX, _currentCheckpoint.y + _pathOffsetY, walkingSpeed ) )
			{
				updateCheckpoint( gameLogics );
			}
		}


		/**
		 * Move the unit along its velocity
		 */
		protected function walk():void
		{
			// move
			this.x += _velx;
			this.y += _vely;
		}


		/**
		 * Calculate the velocity to be used to move to the next checkpoint
		 */
		protected function calculateAndSetVelocityTowardsCurrentCheckpoint():void
		{
			// get the koifficient squared 
			var dirx:Number = ( _currentCheckpoint.x + _pathOffsetX ) - this.x;
			var diry:Number = ( _currentCheckpoint.y + _pathOffsetY ) - this.y;

			// get the distance 
			var dist:Number = StrictMath.sqrt( StrictMath.sqr( dirx ) + StrictMath.sqr( diry ) );

			// normalize the direction and multiply by speed 
			_velx = ( dirx / dist ) * walkingSpeed;
			_vely = ( diry / dist ) * walkingSpeed;
		}


		protected function forceFindNewCheckpoint( gameLogics:GameLogics ):void
		{
			_currentCheckpoint = null;
			updateCheckpoint( gameLogics );
		}


		/**
		 * Update and get the next checkpoint
		 */
		protected function updateCheckpoint( gameLogics:GameLogics ):void
		{
			var newCheckpoint:PathCheckpoint = gameLogics.getNextCheckpointForUnit( this );

			if ( _currentCheckpoint && newCheckpoint.id == _currentCheckpoint.id )
			{
				// okay we have reached goal. Do not move any more
				//TODO: Take life from other player when units reach goal
				_velx = 0;
				_vely = 0;
			}
			else
			{
				_currentCheckpoint = newCheckpoint;
				calculateAndSetVelocityTowardsCurrentCheckpoint();
			}
		}


		public function setDeployFlag( x:int, y:int ):void
		{
			this._deployFlagX = x;
			this._deployFlagY = y;

			if ( _state == UnitState.DEPLOYING || _state == UnitState.GUARDING || _state == UnitState.NONE )
			{
				calculateAndSetVelocityTowardsDeployArea();
				changeState( UnitState.DEPLOYING );
			}
		}


		protected function walkToDeployArea():void
		{
			// move
			this.x += _velx;
			this.y += _vely;

			if ( StrictMath.isCloseEnough( this.x, this.y, _deployFlagX, _deployFlagY, 5 ) )
			{
				changeState( UnitState.GUARDING );
			}
		}


		protected function changeState( state:UnitState ):void
		{
			_state = state;
		}


		protected function getState():UnitState
		{
			return _state;
		}


		protected function setHealth( value:int ):void
		{
			var newHealth:int = StrictMath.clamp( value, 0, maxHealth );

			if ( newHealth != _health )
			{
				_health = newHealth;
				_healthBar.width = ( _health / maxHealth ) * ( HEALTH_BAR_WIDTH - 2 );
			}
		}


		protected function getHealth():int
		{
			return _health;
		}


		/**
		 * Give the unit damage
		 */
		public function hurt( amount:int, gameLogics:GameLogics ):void
		{
			setHealth( getHealth() - amount );

			if ( getHealth() <= 0 )
			{
				die( gameLogics );
			}
		}


		public function heal():void
		{
			if ( _health != maxHealth )
			{
				setHealth( getHealth() + 1 );
			}
		}


		public function die( gameLogics:GameLogics ):void
		{

			if ( _homeBuilding )
			{
				_homeBuilding.onUnitDied( this );
			}

			gameLogics.removeUnit( this );
		}


		protected function calculateAndSetVelocityTowardsDeployArea():void
		{
			// get the koifficient
			var dirx:Number = _deployFlagX - this.x;
			var diry:Number = _deployFlagY - this.y;

			// get the real distance distance
			var dist:Number = StrictMath.sqrt( StrictMath.sqr( dirx ) + StrictMath.sqr( diry ) );

			// normalize the direction and multiply by speed
			_velx = ( dirx / dist ) * walkingSpeed;
			_vely = ( diry / dist ) * walkingSpeed;
		}


		public function chargeTowardsEnemy():void
		{
			//TODO: Charge towards enemy should be called something like walk on path to other side
			if ( state == UnitState.GUARDING || state == UnitState.DEPLOYING )
			{
				changeState( UnitState.CHARGING );
			}
		}


		/**
		 * Checks if this unit is already targeted by a unit
		 */
		public function isTargetedByAnyUnit():Boolean
		{
			return targetedByUnits.length > 0;
		}


		/**
		 *Tell this unit that it is targeted by another unit
		 */
		public function startBeingTargetedByUnit( unit:UnitBase ):void
		{
			var index:int = targetedByUnits.indexOf( unit );

			if ( index == -1 )
			{
				targetedByUnits.push( unit );
			}
		}


		/**
		 * Tell this unit that another unit stopped targeting it
		 */
		public function stopBeingTargetedByUnit( unit:UnitBase ):void
		{
			var index:int = targetedByUnits.indexOf( unit );

			if ( index != -1 )
			{
				targetedByUnits.splice( index, 1 );
			}
		}


		protected function setFrameFromName( name:String ):void
		{
			_mainGraphics.setFrameFromName( name );

		}


		protected function nextFrame():void
		{
			_mainGraphics.nextFrame();
		}


		public function getType():UnitType
		{
			return _type;
		}


		public function setType( type:UnitType ):void
		{
			this._type = type;
		}


		override public function set x( value:Number ):void
		{
			this._x = value;
			super.x = int( value );
		}


		override public function get x():Number
		{
			return _x;
		}


		override public function set y( value:Number ):void
		{
			this._y = value;
			super.y = int( value );
		}


		override public function get y():Number
		{
			return _y;
		}


		protected function set velx( value:Number ):void
		{
			_velx = value;
		}


		protected function get velx():Number
		{
			return _velx;
		}


		protected function set vely( value:Number ):void
		{
			_vely = value;
		}


		protected function get vely():Number
		{
			return _vely;
		}


		protected function get deployFlagX():Number
		{
			return _deployFlagX;
		}


		protected function get deployFlagY():Number
		{
			return _deployFlagY;
		}


		protected function get currentCheckpoint():PathCheckpoint
		{
			return _currentCheckpoint;
		}


		protected function get state():UnitState
		{
			return _state;
		}


		public function getRadius():Number
		{
			return radius;
		}


		public function setPathOffset( x:int, y:int ):void
		{
			return;
			_pathOffsetX = x;
			_pathOffsetY = y;
		}


		public function setHomeBuilding( building:BuildingBase ):void
		{
			this._homeBuilding = building;

		}
	}
}
