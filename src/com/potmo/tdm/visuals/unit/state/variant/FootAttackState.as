package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	public class FootAttackState extends UnitStateBase implements UnitState
	{
		private var _enemy:IUnit;
		private var _unit:FootAttackingUnit;

		private var _hitDelay:int = 0;


		final public function FootAttackState()
		{
			super( UnitStateEnum.FOOTATTACKING );
		}


		public function enter( unit:FootAttackingUnit, enemy:IUnit, gameLogics:GameLogics ):void
		{
			this._unit = unit;
			this._enemy = enemy;

			//_enemy.startBeingTargetedByUnit( _unit );

			_hitDelay = unit.getSettings().hitDelay;
		}


		public function exit( gameLogics:GameLogics ):void
		{
			//_enemy.stopBeingTargetedByUnit( _unit );
		}


		public function visit( gameLogics:GameLogics ):void
		{

			if ( isEnemyTooFarAwayToAttack() )
			{
				//TODO: Animate when moving
				//TODO: Units should keep on the road
				moveCloserToEnemy( gameLogics );

			}
			else
			{
				//TODO: Units should keep on the road
				//TODO: Units should bounce on enemies
				//TODO: Animate when damaging
				tryDamageEnemy( gameLogics );

			}

			_unit.setVelX( _unit.getVelX() * 0.4 );
			_unit.setVelY( _unit.getVelY() * 0.4 );

			_unit.setX( _unit.getX() + _unit.getVelX() );
			_unit.setY( _unit.getY() + _unit.getVelY() );

			if ( isEnemyTooFarAwayToTarget() || isEnemyDead() )
			{
				Logger.log( "Stop attacking unit" );
				stopAttack( gameLogics );
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
			toEnemyForce.normalize();
			toEnemyForce.scale( 0.1 );

			var unwalkableAreaForce:Force;
			unwalkableAreaForce = gameLogics.getMap().getMapUnwalkableAreaForce( gameLogics, _unit, _unit.getOwningPlayer().getDefaultMovingDirection() );
			toEnemyForce.add( unwalkableAreaForce );

			// calculate forces from other units that pushes the unit
			var unitCollisionForce:Force;
			unitCollisionForce = gameLogics.getMap().getUnitCollisionForce( gameLogics, _unit );
			toEnemyForce.add( unitCollisionForce );

			//scale so we do not walk faster than we can
			var movingSpeed:Number = _unit.getSettings().movingSpeed;
			toEnemyForce.normalize();
			toEnemyForce.scale( movingSpeed );

			_unit.setVelX( _unit.getVelX() * 0.8 + toEnemyForce.x );
			_unit.setVelY( _unit.getVelY() * 0.8 + toEnemyForce.y );

		}


		/**
		 * Check if the unit can attack the target and hurt him
		 */
		private function isEnemyTooFarAwayToAttack():Boolean
		{
			var attackingRange:int = _unit.getSettings().attackingRange;

			return !StrictMath.isCloseEnough( _unit.getX(), _unit.getY(), _enemy.getX(), _enemy.getY(), attackingRange, true );
		}


		/**
		 * Check if the unit have escaped and can not be hunted down
		 */
		private function isEnemyTooFarAwayToTarget():Boolean
		{
			var targetRange:int = _unit.getSettings().targetingRange;

			return !StrictMath.isCloseEnough( _unit.getX(), _unit.getY(), _enemy.getX(), _enemy.getY(), targetRange, true );

		}


		private function damageEnemy( gameLogics:GameLogics ):void
		{

			// damage
			var damage:int = _unit.getSettings().hitDamage;
			_enemy.damage( damage, gameLogics );

			// reset hit delay
			_hitDelay = _unit.getSettings().hitDelay;

		}


		private function isEnemyDead():Boolean
		{
			return _enemy.isDead();
		}


		private function stopAttack( gameLogics:GameLogics ):void
		{
			_unit.handleFootAttackStateFinished( this, gameLogics );
		}


		public function clear():void
		{
			_unit = null;
			_enemy = null;
			_hitDelay = 0;
		}

	}
}
