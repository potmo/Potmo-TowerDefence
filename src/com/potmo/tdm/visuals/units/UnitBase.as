package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.player.Player;
	import com.potmo.tdm.visuals.maps.PathCheckpoint;
	import com.potmo.tdm.visuals.starling.TextureAnimation;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.util.math.StrictMath;

	public class UnitBase extends TextureAnimation
	{

		private var type:UnitType;

		protected var owningPlayer:Player;
		protected var _state:UnitState;

		protected var targetedUnit:UnitBase = null;
		protected var targetedByUnits:Vector.<UnitBase> = new Vector.<UnitBase>();

		protected var walkingSpeed:Number = 1; // set to other in subclass if you like
		protected var targetingRange:int = 200; // the distance at witch the unit will start changing against the enemy
		protected var attackingRange:int = 10; // the distance at witch the unit can attack an enemy

		protected var currentCheckpoint:PathCheckpoint = null; // when null it will look for the closest checkpoint on walk()

		private var _x:Number = 0;
		private var _y:Number = 0;

		private var _velx:Number;
		private var _vely:Number;

		private var _deployFlagX:int;
		private var _deployFlagY:int;

		private var _pathOffsetX:int;
		private var _pathOffsetY:int;


		public function UnitBase( graphics:TextureAnimationCacheObject )
		{
			super( graphics );

		}


		public function reset():void
		{
			changeState( UnitState.NONE );
			targetedUnit = null
			targetedByUnits = new Vector.<UnitBase>();
			currentCheckpoint = null;
			_velx = 0;
			_vely = 0;
			_deployFlagX = 0;
			_deployFlagY = 0;
			_x = 0;
			_y = 0;
			_pathOffsetX = 0;
			_pathOffsetY = 0;
		}


		public function setOwningPlayer( owningPlayer:Player ):void
		{
			this.owningPlayer = owningPlayer;
		}


		public function getOwningPlayer():Player
		{
			return owningPlayer;
		}


		/**
		 * Return the current checkpoint that the unit is aiming for.
		 * @return null if current checkpoint is not known else the checkpoint
		 */
		public function getCurrentCheckpoint():PathCheckpoint
		{
			return currentCheckpoint;
		}


		public function update( gameLogics:GameLogics ):void
		{
			// switch state for units
			switch ( _state )
			{
				case ( UnitState.NONE ):
				{
					calculateVelocityToDeployArea();
					changeState( UnitState.DEPLOYING );
					break;
				}
				case ( UnitState.DEPLOYING ):
				{
					walkToDeployArea();
					break;
				}
				case ( UnitState.CHARGING ):
				{
					walkToNextCheckpoint( gameLogics );

					// if this unit is not targeting a unit the search for a unit to target
					if ( !isTargeting() )
					{
						searchForNearbyEnemies( gameLogics );
					}
					break;
				}
				case ( UnitState.GUARDING ):
				{
					// if this unit is not targeting a unit the search for a unit to target
					if ( !isTargeting() )
					{
						searchForNearbyEnemies( gameLogics );

					}
					break;
				}
				case ( UnitState.ENGAGING_ATTACK ):
				{
					if ( isTargetEnemyCloseEnoughToHit() )
					{
						changeState( UnitState.ATTACKING );
					}
					else
					{
						calculateVelocityTowardsTargetedUnit();
						walk();
					}

					break;
				}
				case ( UnitState.ENGAGING_DEFEND ):
				{
					if ( isTargetEnemyCloseEnoughToHit() )
					{
						changeState( UnitState.DEFENDING );
					}
					else
					{
						calculateVelocityTowardsTargetedUnit();
						walk();
					}

					break;
				}

			}

			nextFrame();
		}


		/**
		 * Check if a unit is close enough to engage in a fight with it
		 */
		protected function isTargetEnemyCloseEnoughToHit():Boolean
		{
			if ( isTargeting() )
			{
				return StrictMath.isCloseEnough( this.x, this.y, targetedUnit.x, targetedUnit.y, attackingRange );
			}

			return false;
		}


		/**
		 * Search for enemy units that are close and target them if they are close enough
		 */
		protected function searchForNearbyEnemies( gameLogics:GameLogics ):void
		{
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

			if ( !currentCheckpoint )
			{
				updateCheckpoint( gameLogics );
			}

			walk();

			if ( StrictMath.isCloseEnough( this.x, this.y, currentCheckpoint.x + _pathOffsetX, currentCheckpoint.y + _pathOffsetY, walkingSpeed ) )
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


		private function calculateVelocityTowardsTargetedUnit():void
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
		protected function calculateVelocityToCurrentCheckpoint():void
		{
			// get the koifficient squared 
			var dirx:Number = ( currentCheckpoint.x + _pathOffsetX ) - this.x;
			var diry:Number = ( currentCheckpoint.y + _pathOffsetY ) - this.y;

			// get the distance 
			var dist:Number = StrictMath.sqrt( StrictMath.sqr( dirx ) + StrictMath.sqr( diry ) );

			// normalize the direction and multiply by speed 
			_velx = ( dirx / dist ) * walkingSpeed;
			_vely = ( diry / dist ) * walkingSpeed;
		}


		/**
		 * Update and get the next checkpoint
		 */
		protected function updateCheckpoint( gameLogics:GameLogics ):void
		{
			var newCheckpoint:PathCheckpoint = gameLogics.getNextCheckpointForUnit( this );

			if ( currentCheckpoint && newCheckpoint.id == currentCheckpoint.id )
			{
				// okay we have reached goal. Do not move any more
				//TODO: Take life from other player when units reach goal
				_velx = 0;
				_vely = 0;
			}
			else
			{
				currentCheckpoint = newCheckpoint;
				calculateVelocityToCurrentCheckpoint();
			}
		}


		public function setDeployFlag( x:int, y:int ):void
		{
			this._deployFlagX = x;
			this._deployFlagY = y;

			if ( _state == UnitState.DEPLOYING || _state == UnitState.GUARDING || _state == UnitState.NONE )
			{
				calculateVelocityToDeployArea();
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


		protected function calculateVelocityToDeployArea():void
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
			changeState( UnitState.CHARGING );
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

			if ( _state == UnitState.GUARDING )
			{
				changeState( UnitState.ENGAGING_DEFEND );
			}
			else if ( _state == UnitState.CHARGING )
			{
				changeState( UnitState.ENGAGING_ATTACK );
			}

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
			return type;
		}


		public function setType( type:UnitType ):void
		{
			this.type = type;
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


		public function setPathOffset( x:int, y:int ):void
		{
			_pathOffsetX = x;
			_pathOffsetY = y;
		}
	}
}
