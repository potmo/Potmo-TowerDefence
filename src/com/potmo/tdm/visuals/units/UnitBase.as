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

		protected var targetedUnit:UnitBase = null;
		protected var targetedByUnits:Vector.<UnitBase> = new Vector.<UnitBase>();

		protected var walkingSpeed:Number = 3; // set to other in subclass if you like
		protected var targetingRange:int = 200; // the distance at witch the unit will start changing against the enemy
		protected var attackingRange:int = 10; // the distance at witch the unit can attack an enemy
		protected var radius:Number = 10;
		protected var maxHealth:int = 15;
		protected var hitDelay:int = 10;
		protected var hitDamage:int = 1;
		protected var healDelay:int = 15;

		private var _currentCheckpoint:PathCheckpoint = null; // when null it will look for the closest checkpoint on walk()

		private var _health:int = maxHealth;

		private var _framesToNextHit:int = hitDelay;
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
			targetedUnit = null

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
				case ( UnitState.DEPLOYING ):
				{

					walkToDeployArea();

					if ( !isTargeting() )
					{
						searchForNearbyEnemiesAndTargetIfPossible( gameLogics );
					}

					break;
				}
				case ( UnitState.CHARGING ):
				{
					walkToNextCheckpoint( gameLogics );

					// if this unit is not targeting a unit the search for a unit to target
					if ( !isTargeting() )
					{
						searchForNearbyEnemiesAndTargetIfPossible( gameLogics );
					}
					break;
				}
				case ( UnitState.GUARDING ):
				{
					onIdleUnit();

					// if this unit is not targeting a unit the search for a unit to target
					if ( !isTargeting() )
					{
						searchForNearbyEnemiesAndTargetIfPossible( gameLogics );
					}
					break;
				}
				case ( UnitState.ENGAGING_ATTACK ):
				{
					if ( isTargeting() )
					{
						if ( isTargetEnemyCloseEnoughToHit() )
						{
							changeState( UnitState.ATTACKING );
						}
						else if ( isTargetedUnitTooFarToTarget() )
						{
							stopTargetUnit();
							forceFindNewCheckpoint( gameLogics );
							changeState( UnitState.CHARGING );
						}
						else
						{
							calculateAndSetVelocityTowardsTargetedUnit();
							walk();
						}
					}
					else
					{
						forceFindNewCheckpoint( gameLogics );
						changeState( UnitState.CHARGING );
					}

					break;
				}
				case ( UnitState.ENGAGING_DEFEND ):
				{
					if ( isTargeting() )
					{
						//TODO: Check if unit is defending to far away from the deploy flag. Then return to deploy flag
						if ( isTargetEnemyCloseEnoughToHit() )
						{
							changeState( UnitState.DEFENDING );
						}
						else
						{
							calculateAndSetVelocityTowardsTargetedUnit();
							walk();
						}
					}
					else
					{
						calculateAndSetVelocityTowardsDeployArea();
						changeState( UnitState.DEPLOYING );
					}

					break;
				}

				case ( UnitState.ATTACKING ):
				{
					if ( isTargeting() )
					{
						if ( isTargetEnemyCloseEnoughToHit() )
						{
							hitTargetUnit( gameLogics );
						}
						else
						{
							if ( isTargetedUnitTooFarToTarget() )
							{
								stopTargetUnit();
								forceFindNewCheckpoint( gameLogics );
								changeState( UnitState.CHARGING );
							}
							else
							{
								changeState( UnitState.ENGAGING_ATTACK );
							}
						}

					}
					else
					{
						forceFindNewCheckpoint( gameLogics );
						changeState( UnitState.CHARGING );
					}
					break;
				}
				case ( UnitState.DEFENDING ):
				{
					if ( isTargeting() )
					{
						hitTargetUnit( gameLogics );
					}
					else
					{
						calculateAndSetVelocityTowardsDeployArea();
						changeState( UnitState.DEPLOYING );
					}
					break;
				}

			}

			_mainGraphics.nextFrame();
		}


		private function hitTargetUnit( gameLogics:GameLogics ):void
		{
			_framesToNextHit--;

			if ( _framesToNextHit <= 0 )
			{
				targetedUnit.hurt( hitDamage, gameLogics );
				_framesToNextHit = hitDelay;
			}

		}


		private function onIdleUnit():void
		{
			_framesToNextHeal--;

			if ( _framesToNextHeal <= 0 )
			{
				this.heal();
				_framesToNextHeal = healDelay;
			}
		}


		/**
		 * Check if a unit is close enough to engage in a fight with it
		 */
		protected function isTargetEnemyCloseEnoughToHit():Boolean
		{
			if ( isTargeting() )
			{
				return StrictMath.isCloseEnough( this.x, this.y, targetedUnit.x, targetedUnit.y, this.radius + targetedUnit.radius + attackingRange );
			}

			return false;
		}


		protected function isTargetedUnitTooFarToTarget():Boolean
		{
			if ( isTargeting() )
			{
				return !StrictMath.isCloseEnough( this.x, this.y, targetedUnit.x, targetedUnit.y, targetingRange );
			}

			return true;
		}


		/**
		 * Search for enemy units that are close and target them if they are close enough
		 */
		protected function searchForNearbyEnemiesAndTargetIfPossible( gameLogics:GameLogics ):void
		{
			//TODO: When changing we should not look back for units. If we passed them we sprint away
			var targetUnit:UnitBase = gameLogics.getEnemyUnitCloseEnough( this, targetingRange );

			if ( targetUnit )
			{
				this.startTargetUnit( targetUnit );
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


		protected function calculateAndSetVelocityTowardsTargetedUnit():void
		{

			// get the koifficient squared 
			var dirx:Number = targetedUnit.x - this.x;
			var diry:Number = targetedUnit.y - this.y;

			// get the distance 
			var dist:Number = StrictMath.sqrt( StrictMath.sqr( dirx ) + StrictMath.sqr( diry ) );

			// normalize the direction and multiply by speed 
			_velx = ( dirx / dist ) * walkingSpeed;
			_vely = ( diry / dist ) * walkingSpeed;
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
			//TODO: I guess we need a little animation when the unit dies
			if ( targetedUnit )
			{
				this.stopTargetUnit();
			}

			for ( var i:int = targetedByUnits.length - 1; i >= 0; i-- )
			{
				targetedByUnits[ i ].stopTargetUnit();
			}

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
			if ( _state == UnitState.GUARDING || _state == UnitState.DEPLOYING )
			{
				changeState( UnitState.CHARGING );
			}
		}


		/**
		 * Checks if this unit is already targeted by a unit
		 */
		public function isAlreadyTargeted():Boolean
		{
			return targetedByUnits.length > 0;
		}


		/**
		 * Checks if this unit is targeting another unit
		 */
		public function isTargeting():Boolean
		{
			return targetedUnit != null;
		}


		/**
		 *Tell this unit that it is targeted by another unit
		 */
		public function startTargetByUnit( unit:UnitBase ):void
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
		public function stopTargetByUnit( unit:UnitBase ):void
		{
			var index:int = targetedByUnits.indexOf( unit );

			if ( index != -1 )
			{
				targetedByUnits.splice( index, 1 );
			}
		}


		/**
		 * Make this unit target another unit. If this unit is already targeting another unit it will stop with that first
		 */
		public function startTargetUnit( unit:UnitBase ):void
		{
			if ( targetedUnit )
			{
				stopTargetUnit();
			}

			targetedUnit = unit;
			targetedUnit.startTargetByUnit( this );

			// if we are idle (i.e. standing outside the building)
			// we should defend
			// if we are walking (i.e. walking towards the enemy)
			// we should attack

			if ( _state == UnitState.GUARDING || _state == UnitState.DEPLOYING )
			{
				changeState( UnitState.ENGAGING_DEFEND );
			}
			else if ( _state == UnitState.CHARGING )
			{
				changeState( UnitState.ENGAGING_ATTACK );
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


		/**
		 * Make this unit stop targeting its taget unit.
		 * If it's not targeting any unit this function has no effect.
		 */
		public function stopTargetUnit():void
		{
			if ( !targetedUnit )
			{
				return;
			}

			targetedUnit.stopTargetByUnit( this );
			targetedUnit = null;
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


		public function getRadius():Number
		{
			return radius;
		}


		public function setPathOffset( x:int, y:int ):void
		{
			_pathOffsetX = x;
			_pathOffsetY = y;
		}


		public function setHomeBuilding( building:BuildingBase ):void
		{
			this._homeBuilding = building;

		}
	}
}
