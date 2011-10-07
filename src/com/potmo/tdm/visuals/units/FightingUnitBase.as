package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.maps.PathCheckpoint;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	public class FightingUnitBase extends UnitBase
	{
		//TODO: Make all the protected fields be getter functions to be implemeted by UnitImlementation
		protected var targetedUnit:UnitBase = null;
		protected var targetingRange:int = 200; // the distance at witch the unit will start changing against the enemy
		protected var attackingRange:int = 10; // the distance at witch the unit can attack an enemy
		protected var hitDelay:int = 10;
		protected var hitDamage:int = 1;

		private var _framesToNextHit:int = hitDelay;


		public function FightingUnitBase( graphics:TextureAnimationCacheObject )
		{
			super( graphics );
		}


		override public function reset():void
		{
			super.reset();
			targetedUnit = null
		}


		override public function update( gameLogics:GameLogics ):void
		{
			switch ( state )
			{
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
						else if ( isTargetedUnitCloseEnoughtToTarget() )
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
					if ( isTargeting() && isTargetInsideDefenceRange() )
					{
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
						stopTargetUnit();
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
							if ( isTargetedUnitCloseEnoughtToTarget() )
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
						if ( isTargetEnemyCloseEnoughToHit() )
						{
							hitTargetUnit( gameLogics );
						}
						else
						{
							changeState( UnitState.ENGAGING_DEFEND );
						}
					}
					else
					{
						calculateAndSetVelocityTowardsDeployArea();
						changeState( UnitState.DEPLOYING );
					}
					break;
				}
			}

			super.update( gameLogics );
		}


		protected function hitTargetUnit( gameLogics:GameLogics ):void
		{
			_framesToNextHit--;

			if ( _framesToNextHit <= 0 )
			{
				targetedUnit.hurt( hitDamage, gameLogics );
				_framesToNextHit = hitDelay;
			}

		}


		/**
		 * Check if the target is to far away from the deploy flag
		 */
		protected function isTargetInsideDefenceRange():Boolean
		{
			return StrictMath.isCloseEnough( this.deployFlagX, this.deployFlagY, targetedUnit.x, targetedUnit.y, this.getRadius() + targetedUnit.getRadius() + targetingRange );
		}


		/**
		 * Check if a unit is close enough to engage in a fight with it
		 */
		protected function isTargetEnemyCloseEnoughToHit():Boolean
		{
			if ( isTargeting() )
			{
				return StrictMath.isCloseEnough( this.x, this.y, targetedUnit.x, targetedUnit.y, this.getRadius() + targetedUnit.getRadius() + attackingRange );
			}

			return false;
		}


		protected function isTargetedUnitCloseEnoughtToTarget():Boolean
		{
			if ( isTargeting() )
			{
				return StrictMath.isCloseEnough( this.x, this.y, targetedUnit.x, targetedUnit.y, this.getRadius() + targetedUnit.getRadius() + targetingRange );
			}

			return true;
		}


		/**
		 * Calculate if the targeted unit is behind this unit on the path
		 */
		protected function isUnitBehindOnPath( other:UnitBase ):Boolean
		{
			if ( !currentCheckpoint )
			{
				return false;
			}

			var toCheckX:Number = currentCheckpoint.x - this.x;
			var toCheckY:Number = currentCheckpoint.y - this.y;

			var toOtherX:Number = other.x - this.x;
			var toOtherY:Number = other.y - this.y;

			var dot:Number = StrictMath.dotProduct2D( toCheckX, toCheckY, toOtherX, toOtherY );

			Logger.log( "dot is: " + dot + " on " + toCheckX + "," + toCheckY + " and " + toOtherX + "," + toOtherY );

			if ( dot < 0 )
			{
				return true;
			}
			else
			{
				return false;
			}
		}


		/**
		 * Search for enemy units that are close and target them if they are close enough
		 */
		protected function searchForNearbyEnemiesAndTargetIfPossible( gameLogics:GameLogics ):void
		{

			var targetUnit:UnitBase = gameLogics.getEnemyUnitCloseEnough( this, targetingRange );

			if ( targetUnit )
			{
				if ( !isUnitBehindOnPath( targetUnit ) )
				{
					this.startTargetUnit( targetUnit );
				}

			}
		}


		protected function calculateAndSetVelocityTowardsTargetedUnit():void
		{

			// get the koifficient squared 
			var dirx:Number = targetedUnit.x - this.x;
			var diry:Number = targetedUnit.y - this.y;

			// get the distance 
			var dist:Number = StrictMath.sqrt( StrictMath.sqr( dirx ) + StrictMath.sqr( diry ) );

			// normalize the direction and multiply by speed 
			velx = ( dirx / dist ) * walkingSpeed;
			vely = ( diry / dist ) * walkingSpeed;
		}


		override public function die( gameLogics:GameLogics ):void
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

			super.die( gameLogics );
		}


		/**
		 * Checks if this unit is targeting another unit
		 */
		public function isTargeting():Boolean
		{
			return targetedUnit != null;
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
			targetedUnit.startBeingTargetedByUnit( this );

			// if we are idle (i.e. standing outside the building)
			// we should defend
			// if we are walking (i.e. walking towards the enemy)
			// we should attack

			if ( state == UnitState.GUARDING || state == UnitState.DEPLOYING )
			{
				changeState( UnitState.ENGAGING_DEFEND );
			}
			else if ( state == UnitState.CHARGING )
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

			targetedUnit.stopBeingTargetedByUnit( this );
			targetedUnit = null;
		}

	}
}
