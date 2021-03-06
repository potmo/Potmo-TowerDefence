package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	public class FootDefendState extends UnitStateBase implements UnitState
	{
		private var _enemy:Unit;
		private var _unit:FootDefendingUnit;

		private var _hitDelay:int = 0;


		final public function FootDefendState()
		{
			super( UnitStateEnum.FOOTDEFENDING );
		}


		public function enter( unit:FootDefendingUnit, enemy:Unit, gameLogics:GameLogics ):void
		{
			this._unit = unit;
			this._enemy = enemy;

			_enemy.targetedByEnemy();

			_hitDelay = unit.getSettings().getHitDelay();
		}


		public function exit( gameLogics:GameLogics ):void
		{
			_enemy.untargetedByEnemy();
		}


		public function visit( gameLogics:GameLogics ):void
		{

			if ( isEnemyTooFarAwayToAttack() )
			{
				//TODO: Animate when moving
				moveCloserToEnemy( gameLogics );

			}
			else
			{
				//TODO: Animate when damaging
				tryDamageEnemy( gameLogics );

			}

			avoidCollisions( gameLogics );

			_unit.setVelX( _unit.getVelX() * 0.4 );
			_unit.setVelY( _unit.getVelY() * 0.4 );

			_unit.setX( _unit.getX() + _unit.getVelX() );
			_unit.setY( _unit.getY() + _unit.getVelY() );

			if ( isEnemyTooFarAwayToTarget() || isEnemyDead() )
			{

				var newEnemy:Unit = gameLogics.getUnitManager().getClosestEnemyUnitPossibleToAttack( _unit );

				if ( newEnemy )
				{
					Logger.log( "Start attacking new unit" );
					this.exit( gameLogics );
					this.enter( _unit, newEnemy, gameLogics );
				}
				else
				{
					Logger.log( "Stop attacking unit" );
					stopDefend( gameLogics );
				}

			}

		}


		private function tryDamageEnemy( gameLogics:GameLogics ):void
		{

			if ( isEnemyDead() )
			{
				return;
			}

			_hitDelay--;

			if ( _hitDelay <= 0 )
			{
				damageEnemy( gameLogics );

				_unit.setFrameFromName( "DAMAGE" );
			}

		}


		private function moveCloserToEnemy( gameLogics:GameLogics ):void
		{

			// calculate force towards enemy
			var dirX:Number = _enemy.getX() - _unit.getX();
			var dirY:Number = _enemy.getY() - _unit.getY();

			//continue calculate force towards flag
			var toEnemyForce:Force = new Force( dirX, dirY );

			//scale so we do not walk faster than we can
			var movingSpeed:Number = _unit.getSettings().getMovingSpeed();
			toEnemyForce.normalize();
			toEnemyForce.scale( movingSpeed );

			_unit.setVelX( _unit.getVelX() * 0.9 + toEnemyForce.x );
			_unit.setVelY( _unit.getVelY() * 0.9 + toEnemyForce.y );

		}


		private function avoidCollisions( gameLogics:GameLogics ):void
		{
			var unwalkableAreaForce:Force;
			unwalkableAreaForce = gameLogics.getMap().getMapUnwalkableAreaForce( _unit.getX(), _unit.getY(), _unit.getOwningPlayer().getDefaultMovingDirection() );
			unwalkableAreaForce.scale( 5.0 );

			// calculate forces from other units that pushes the unit
			var unitCollisionForce:Force;
			unitCollisionForce = gameLogics.getMap().getUnitCollisionForce( gameLogics, _unit );
			unitCollisionForce.scale( 2.0 );
			unwalkableAreaForce.add( unitCollisionForce );

			//scale so we do not walk faster than we can
			var movingSpeed:Number = _unit.getSettings().getMovingSpeed();
			unwalkableAreaForce.normalize();
			unwalkableAreaForce.scale( movingSpeed );

			_unit.setVelX( _unit.getVelX() * 0.8 + unwalkableAreaForce.x );
			_unit.setVelY( _unit.getVelY() * 0.8 + unwalkableAreaForce.y );
		}


		/**
		 * Check if the unit can attack the target and hurt him
		 */
		private function isEnemyTooFarAwayToAttack():Boolean
		{
			var attackingRange:int = _unit.getSettings().getAttackingRange();

			return !StrictMath.isCloseEnough( _unit.getX(), _unit.getY(), _enemy.getX(), _enemy.getY(), attackingRange, true );
		}


		/**
		 * Check if the unit have escaped and can not be hunted down
		 */
		private function isEnemyTooFarAwayToTarget():Boolean
		{
			var targetRange:int = _unit.getSettings().getTargetingRange();

			return !StrictMath.isCloseEnough( _unit.getX(), _unit.getY(), _enemy.getX(), _enemy.getY(), targetRange, true );

		}


		private function damageEnemy( gameLogics:GameLogics ):void
		{

			// damage
			var damage:int = _unit.getSettings().getHitDamage();
			_enemy.damage( damage, gameLogics );

			// reset hit delay
			_hitDelay = _unit.getSettings().getHitDelay();

		}


		private function isEnemyDead():Boolean
		{
			return _enemy.isDead();
		}


		private function stopDefend( gameLogics:GameLogics ):void
		{
			_unit.handleFootDefendStateFinished( gameLogics );
		}


		public function clear():void
		{
			_unit = null;
			_enemy = null;
			_hitDelay = 0;
		}

	}
}
