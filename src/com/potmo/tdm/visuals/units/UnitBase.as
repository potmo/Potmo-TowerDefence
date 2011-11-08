package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.buildings.BuildingBase;
	import com.potmo.tdm.visuals.maps.PathCheckpoint;
	import com.potmo.tdm.visuals.starling.TextureAnimation;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.units.settings.IUnitSetting;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;

	public class UnitBase extends DisplayObjectContainer
	{

		private var _type:UnitType;

		private var _owningPlayer:Player;
		private var _state:UnitState = UnitState.NONE;

		protected var targetedByUnits:Vector.<FightingUnitBase> = new Vector.<FightingUnitBase>();

		protected var settings:IUnitSetting;

		private var _currentCheckpoint:PathCheckpoint = null; // when null it will look for the closest checkpoint on walk()

		private var _x:Number = 0;
		private var _y:Number = 0;

		private var _velx:Number = 0;
		private var _vely:Number = 0;

		private var _deployFlagX:int;
		private var _deployFlagY:int;

		private var _pathOffsetX:int;
		private var _pathOffsetY:int;

		private var _mainGraphics:TextureAnimation;
		private var _healthBarBackground:Quad;
		private var _healthBar:Quad;
		private var _health:int;
		private var _framesToNextHeal:int;

		private var _homeBuilding:BuildingBase;

		private static const HEALTH_BAR_HEIGHT:int = 6;
		private static const HEALTH_BAR_WIDTH:int = 20;


		public function UnitBase( graphics:TextureAnimationCacheObject, type:UnitType, settings:IUnitSetting )
		{
			this.settings = settings;
			this._type = type;

			_health = settings.maxHealth;
			_framesToNextHeal = settings.healDelay;

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


		public function reset( gameLogics:GameLogics ):void
		{
			setState( UnitState.NONE, gameLogics );

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
			setHealth( settings.maxHealth );
			_homeBuilding = null;
		}


		final public function setOwningPlayer( owningPlayer:Player ):void
		{
			this._owningPlayer = owningPlayer;

			if ( owningPlayer.isMe() )
			{
				this._mainGraphics.color = 0xFFFF0000;
			}
			else
			{
				this._mainGraphics.color = 0xFF00FF00;
			}

		}


		final public function getOwningPlayer():Player
		{
			return _owningPlayer;
		}


		/**
		 * Return the current checkpoint that the unit is aiming for.
		 * @return null if current checkpoint is not known else the checkpoint
		 */
		final public function getCurrentCheckpoint():PathCheckpoint
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
					moveToDeployArea( gameLogics );
					break;
				}

			}

			var frameName:String = _mainGraphics.nextFrame();

			if ( frameName )
			{
				onEnterNamedFrame( frameName, gameLogics );
			}
		}


		final protected function handleIdlingUnit( gameLogics:GameLogics ):void
		{
			_framesToNextHeal--;

			if ( _framesToNextHeal <= 0 )
			{
				aid( 1, gameLogics );
				_framesToNextHeal = settings.healDelay;
			}
		}


		/**
		 * Walk towards the next checkpoint.
		 * If there are no checkpoint this function will get one
		 */
		final protected function moveToNextCheckpoint( gameLogics:GameLogics ):void
		{

			setState( UnitState.CHARGING, gameLogics );

			if ( !_currentCheckpoint )
			{
				updateCheckpoint( gameLogics );
			}

		}


		final protected function moveToDeployArea( gameLogics:GameLogics ):void
		{

			setState( UnitState.DEPLOYING, gameLogics );

			// get the koifficient
			var dirx:Number = _deployFlagX - this.x;
			var diry:Number = _deployFlagY - this.y;

			// get the real distance distance
			var dist:Number = StrictMath.sqrt( StrictMath.sqr( dirx ) + StrictMath.sqr( diry ) );

			// normalize the direction and multiply by speed
			_velx = ( dirx / dist ) * settings.movingSpeed;
			_vely = ( diry / dist ) * settings.movingSpeed;

		}


		/**
		 * Move the unit along its velocity
		 */
		final protected function move( gameLogics:GameLogics ):void
		{
			//TODO: Units should try to keep away from eachother so they don't overlap
			// move
			this.x += _velx;
			this.y += _vely;

			switch ( state )
			{
				case ( UnitState.CHARGING ):
				{
					checkIfUnitReachedAndShouldUpdateCheckpoint( gameLogics );
					break;
				}
				case ( UnitState.DEPLOYING ):
				{
					checkIfUnitReachedDeployArea( gameLogics );
					break;
				}
			}
		}


		final private function checkIfUnitReachedDeployArea( gameLogics:GameLogics ):void
		{
			if ( StrictMath.isCloseEnough( this.x, this.y, _deployFlagX, _deployFlagY, 5 ) )
			{
				_velx = 0;
				_vely = 0;
				setState( UnitState.GUARDING, gameLogics );

			}
		}


		final private function checkIfUnitReachedAndShouldUpdateCheckpoint( gameLogics:GameLogics ):void
		{
			if ( StrictMath.isCloseEnough( this.x, this.y, _currentCheckpoint.x + _pathOffsetX, _currentCheckpoint.y + _pathOffsetY, settings.movingSpeed ) )
			{
				updateCheckpoint( gameLogics );
			}
		}


		/**
		 * Calculate the velocity to be used to move to the next checkpoint
		 */
		final private function setVelocityTowardsCurrentCheckpoint():void
		{
			if ( !currentCheckpoint )
			{
				return;
			}

			// get the koifficient squared 
			var dirx:Number = ( _currentCheckpoint.x + _pathOffsetX ) - this.x;
			var diry:Number = ( _currentCheckpoint.y + _pathOffsetY ) - this.y;

			// get the distance 
			var dist:Number = StrictMath.sqrt( StrictMath.sqr( dirx ) + StrictMath.sqr( diry ) );

			// normalize the direction and multiply by speed 
			_velx = ( dirx / dist ) * settings.movingSpeed;
			_vely = ( diry / dist ) * settings.movingSpeed;
		}


		final protected function forgetCurrentCheckpoint( gameLogics:GameLogics ):void
		{
			_currentCheckpoint = null;
		}


		/**
		 * Update and get the next checkpoint
		 */
		final protected function updateCheckpoint( gameLogics:GameLogics ):void
		{
			Logger.log( "Unit " + this + " updating checkpoint" );
			var newCheckpoint:PathCheckpoint = gameLogics.getNextCheckpointForUnit( this );

			if ( _currentCheckpoint && newCheckpoint.id == _currentCheckpoint.id )
			{
				// okay we have reached goal. Do not move any more

				_velx = 0;
				_vely = 0;

				//TODO: Take life from other player when units reach goal instead of killing the unit
				this.kill( gameLogics );
			}
			else
			{
				_currentCheckpoint = newCheckpoint;
				setVelocityTowardsCurrentCheckpoint();
			}
		}


		final public function setDeployFlag( x:int, y:int, gameLogics:GameLogics ):void
		{
			this._deployFlagX = x;
			this._deployFlagY = y;

			if ( _state == UnitState.DEPLOYING || _state == UnitState.GUARDING || _state == UnitState.NONE )
			{
				moveToDeployArea( gameLogics );
			}
		}


		final protected function setState( state:UnitState, gameLogics:GameLogics ):void
		{
			if ( _state != state )
			{
				_state = state;
				onStateSet( state, gameLogics );

				Logger.log( "Unit " + this + " changing state to: " + state );
			}
		}


		final protected function getState():UnitState
		{
			return _state;
		}


		final protected function setHealth( value:int ):void
		{
			var newHealth:int = StrictMath.clamp( value, 0, settings.maxHealth );

			if ( newHealth != _health )
			{
				_health = newHealth;
				_healthBar.width = ( _health / settings.maxHealth ) * ( HEALTH_BAR_WIDTH - 2 );
			}
		}


		final protected function getHealth():int
		{
			return _health;
		}


		public function damage( amount:int, gameLogics:GameLogics ):void
		{

			if ( getHealth() <= 0 )
			{
				return;
			}

			setHealth( getHealth() - amount );

			if ( getHealth() <= 0 )
			{
				kill( gameLogics );
			}
		}


		/**
		 * Give the unit damage
		 */
		final protected function hurt( amount:int, gameLogics:GameLogics ):void
		{
			onHurt( amount, gameLogics );
		}


		public final function aid( maxAmount:int, gameLogics:GameLogics ):void
		{
			onHeal( maxAmount, gameLogics )
		}


		/**
		 * Really damage a unit
		 */
		final protected function heal( maxAmount:int, gameLogics:GameLogics ):void
		{
			if ( _health != settings.maxHealth )
			{
				setHealth( getHealth() + maxAmount );
			}
		}


		/**
		 * Call this to kill a unit
		 */
		public function kill( gameLogics:GameLogics ):void
		{
			setState( UnitState.WALKING_DEAD, gameLogics );
			onDie( gameLogics );
		}


		/**
		 * This is the internal call to really kill the unit when its all over
		 */
		protected function die( gameLogics:GameLogics ):void
		{

			if ( _homeBuilding )
			{
				_homeBuilding.onUnitDied( this );
			}

			gameLogics.removeUnit( this );
		}


		final public function startWalkPath( gameLogics:GameLogics ):void
		{
			//TODO: Charge towards enemy should be called something like walk on path to other side
			if ( state == UnitState.GUARDING || state == UnitState.DEPLOYING )
			{
				moveToNextCheckpoint( gameLogics );
			}
		}


		/**
		 * Checks if this unit is already targeted by a unit
		 */
		final public function isTargetedByAnyUnit():Boolean
		{
			return targetedByUnits.length > 0;
		}


		/**
		 *Tell this unit that it is targeted by another unit
		 */
		final public function startBeingTargetedByUnit( unit:UnitBase ):void
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
		final public function stopBeingTargetedByUnit( unit:UnitBase ):void
		{
			var index:int = targetedByUnits.indexOf( unit );

			if ( index != -1 )
			{
				targetedByUnits.splice( index, 1 );
			}
		}


		final protected function setFrameFromName( name:String ):void
		{

			_mainGraphics.setFrameFromName( name );

		}


		final protected function nextFrame():void
		{
			_mainGraphics.nextFrame();
		}


		final protected function setVelx( value:Number ):void
		{
			_velx = value;
		}


		final public function getVelx():Number
		{
			return _velx;
		}


		final protected function setVely( value:Number ):void
		{
			_vely = value;
		}


		final public function getVely():Number
		{
			return _vely;
		}


		final protected function get deployFlagX():Number
		{
			return _deployFlagX;
		}


		final protected function get deployFlagY():Number
		{
			return _deployFlagY;
		}


		final protected function get currentCheckpoint():PathCheckpoint
		{
			return _currentCheckpoint;
		}


		final protected function get state():UnitState
		{
			return _state;
		}


		final public function getRadius():Number
		{
			return settings.radius;
		}


		final public function setPathOffset( x:int, y:int ):void
		{
			return;
			_pathOffsetX = x;
			_pathOffsetY = y;
		}


		final public function setHomeBuilding( building:BuildingBase ):void
		{
			this._homeBuilding = building;

		}


		final public function getType():UnitType
		{
			return _type;
		}


		/////// TRIGGERS TO UNIT IMPLEMENTATION //////////
		protected function onEnterNamedFrame( frameName:String, gameLogics:GameLogics ):void
		{
			// override
		}


		protected function onHeal( maxAmount:int, gameLogics:GameLogics ):void
		{
			heal( maxAmount, gameLogics );
		}


		protected function onStateSet( state:UnitState, gameLogics:GameLogics ):void
		{
			// override
		}


		protected function onDie( gameLogics:GameLogics ):void
		{
			die( gameLogics );
		}


		protected function onHurt( hitDamage:int, gameLogics:GameLogics ):void
		{
			hurt( hitDamage, gameLogics );
		}


		public function toString():String
		{
			return "UnitBase[" + _type + "]"
		}

	}
}
