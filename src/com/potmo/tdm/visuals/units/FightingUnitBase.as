package com.potmo.tdm.visuals.units
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.starling.TextureAnimationCacheObject;
	import com.potmo.tdm.visuals.units.settings.IUnitSetting;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	public class FightingUnitBase extends UnitBase
	{
		//TODO: Make all the protected fields be getter functions to be implemeted by UnitImlementation
		protected var targetedUnit:UnitBase = null;

		private var _framesToNextHit:int;


		public function FightingUnitBase( graphics:TextureAnimationCacheObject, settings:IUnitSetting )
		{
			super( graphics, settings );
			_framesToNextHit = settings.hitDelay;
		}


		override public function reset( gameLogics:GameLogics ):void
		{
			super.reset( gameLogics );
			targetedUnit = null
		}


		override public function update( gameLogics:GameLogics ):void
		{
			//TODO: This great switch case should be broken out
			switch ( state )
			{
				case ( UnitState.DEPLOYING ):
				case ( UnitState.CHARGING ):
				{

					move( gameLogics );

					if ( !isTargetingUnit() )
					{
						tagetAnyNearbyTargetableUnit( gameLogics );
					}

					break;
				}
				case ( UnitState.GUARDING ):
				{
					handleIdlingUnit( gameLogics );

					// if this unit is not targeting a unit the search for a unit to target
					if ( !isTargetingUnit() )
					{
						tagetAnyNearbyTargetableUnit( gameLogics );
					}
					break;
				}
				case ( UnitState.APPROACH_ATTACK ):
				{
					if ( isTargetingUnit() )
					{
						if ( isTargetetUnitCloseEnoughToEngage() )
						{
							setState( UnitState.ATTACKING, gameLogics );
						}
						else if ( isTargetedUnitStillWithinTargetRange() )
						{
							stopTargetingUnit();
							forgetCurrentCheckpoint( gameLogics );
							moveToNextCheckpoint( gameLogics );
						}
						else
						{
							setVelocityTowardsTargetedUnit();
							move( gameLogics );
						}
					}
					else
					{
						forgetCurrentCheckpoint( gameLogics );
						moveToNextCheckpoint( gameLogics );
					}

					break;
				}
				case ( UnitState.APPROACH_DEFEND ):
				{
					if ( isTargetingUnit() && isTargetedUnitStillWithinTargetRange() )
					{
						if ( isTargetetUnitCloseEnoughToEngage() )
						{
							setState( UnitState.DEFENDING, gameLogics );
						}
						else
						{
							setVelocityTowardsTargetedUnit();
							move( gameLogics );
						}
					}
					else
					{
						stopTargetingUnit();
						moveToDeployArea( gameLogics );
					}

					break;
				}

				case ( UnitState.ATTACKING ):
				{
					if ( isTargetingUnit() )
					{
						if ( isTargetetUnitCloseEnoughToEngage() )
						{
							beginEngageTargetUnit( gameLogics );
						}
						else
						{
							if ( isTargetedUnitStillWithinTargetRange() )
							{
								stopTargetingUnit();
								forgetCurrentCheckpoint( gameLogics );
								moveToNextCheckpoint( gameLogics );
							}
							else
							{
								setState( UnitState.APPROACH_ATTACK, gameLogics );
							}
						}

					}
					else
					{
						forgetCurrentCheckpoint( gameLogics );
						moveToNextCheckpoint( gameLogics );
					}
					break;
				}
				case ( UnitState.DEFENDING ):
				{
					if ( isTargetingUnit() )
					{
						if ( isTargetetUnitCloseEnoughToEngage() )
						{
							beginEngageTargetUnit( gameLogics );
						}
						else
						{
							setState( UnitState.APPROACH_DEFEND, gameLogics );
						}
					}
					else
					{
						moveToDeployArea( gameLogics );
					}
					break;
				}
			}

			super.update( gameLogics );
		}


		final private function beginEngageTargetUnit( gameLogics:GameLogics ):void
		{
			_framesToNextHit--;

			if ( _framesToNextHit <= 0 )
			{
				onEngageTargetUnit( gameLogics );
				_framesToNextHit = settings.hitDelay;
			}
		}


		final protected function hurtTargetedUnit( gameLogics:GameLogics ):void
		{
			if ( isTargetingUnit() )
			{
				//TODO: There should be a chance of missing a hit
				targetedUnit.hurt( settings.hitDamage, gameLogics );
			}
		}


		/**
		 * Check if a unit is close enough to engage in a fight with it
		 */
		final protected function isTargetetUnitCloseEnoughToEngage():Boolean
		{
			if ( isTargetingUnit() )
			{
				return StrictMath.isCloseEnough( this.x, this.y, targetedUnit.x, targetedUnit.y, this.getRadius() + targetedUnit.getRadius() + settings.attackingRange );
			}

			return false;
		}


		final protected function isTargetedUnitStillWithinTargetRange():Boolean
		{
			if ( isTargetingUnit() )
			{
				return StrictMath.isCloseEnough( this.deployFlagX, this.deployFlagY, targetedUnit.x, targetedUnit.y, this.getRadius() + targetedUnit.getRadius() + settings.targetingRange );
			}

			return false;
		}


		/**
		 * Calculate if the targeted unit is behind this unit on the path
		 */
		final protected function isUnitBehindOnPath( other:UnitBase ):Boolean
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
		final protected function tagetAnyNearbyTargetableUnit( gameLogics:GameLogics ):void
		{

			var targetUnit:UnitBase = gameLogics.getEnemyUnitCloseEnough( this, settings.targetingRange );

			if ( targetUnit )
			{
				if ( !isUnitBehindOnPath( targetUnit ) )
				{
					this.startTargetUnit( targetUnit, gameLogics );
				}

			}
		}


		final protected function setVelocityTowardsTargetedUnit():void
		{

			// get the koifficient squared 
			var dirx:Number = targetedUnit.x - this.x;
			var diry:Number = targetedUnit.y - this.y;

			// get the distance 
			var dist:Number = StrictMath.sqrt( StrictMath.sqr( dirx ) + StrictMath.sqr( diry ) );

			// normalize the direction and multiply by speed 
			velx = ( dirx / dist ) * settings.movingSpeed;
			vely = ( diry / dist ) * settings.movingSpeed;
		}


		final override protected function die( gameLogics:GameLogics ):void
		{
			if ( targetedUnit )
			{
				this.stopTargetingUnit();
			}

			for ( var i:int = targetedByUnits.length - 1; i >= 0; i-- )
			{
				targetedByUnits[ i ].stopTargetingUnit();
			}

			super.die( gameLogics );
		}


		/**
		 * Checks if this unit is targeting another unit
		 */
		final public function isTargetingUnit():Boolean
		{
			return targetedUnit != null;
		}


		/**
		 * Make this unit target another unit. If this unit is already targeting another unit it will stop with that first
		 */
		final public function startTargetUnit( unit:UnitBase, gameLogics:GameLogics ):void
		{
			if ( targetedUnit )
			{
				stopTargetingUnit();
			}

			targetedUnit = unit;
			targetedUnit.startBeingTargetedByUnit( this );

			// if we are idle (i.e. standing outside the building)
			// we should defend
			// if we are walking (i.e. walking towards the enemy)
			// we should attack

			if ( state == UnitState.GUARDING || state == UnitState.DEPLOYING )
			{
				setState( UnitState.APPROACH_DEFEND, gameLogics );
			}
			else if ( state == UnitState.CHARGING )
			{
				setState( UnitState.APPROACH_ATTACK, gameLogics );
			}

		}


		/**
		 * Make this unit stop targeting its taget unit.
		 * If it's not targeting any unit this function has no effect.
		 */
		final public function stopTargetingUnit():void
		{
			if ( !targetedUnit )
			{
				return;
			}

			targetedUnit.stopBeingTargetedByUnit( this );
			targetedUnit = null;
		}


		////// TRIGGERS TO UNIT IMPLEMENTATION ///////
		protected function onEngageTargetUnit( gameLogics:GameLogics ):void
		{
			// override
		}

	}
}
