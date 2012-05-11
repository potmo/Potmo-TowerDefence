package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;
	import com.potmo.tdm.visuals.unit.Unit;

	public class GuardState extends UnitStateBase implements UnitState
	{
		private var _unit:GuardingUnit;


		final public function GuardState()
		{
			super( UnitStateEnum.GUARDING );
		}


		public function enter( unit:GuardingUnit, gameLogics:GameLogics ):void
		{
			// just save the unit for later use
			_unit = unit;
			_unit.setFrameFromName( "LOOP_WAIT" );
		}


		public function visit( gameLogics:GameLogics ):void
		{
			// calculate forces from other units that pushes the unit
			avoidCollisions( gameLogics );

			_unit.setX( _unit.getX() + _unit.getVelX() );
			_unit.setY( _unit.getY() + _unit.getVelY() );

			var enemy:Unit = gameLogics.getUnitManager().getClosestEnemyUnitPossibleToAttack( _unit );

			if ( enemy )
			{
				_unit.handleGuardStateFinished( this, enemy, gameLogics );
			}
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
			var movingSpeed:Number = _unit.getSettings().movingSpeed;
			unwalkableAreaForce.normalize();
			unwalkableAreaForce.scale( movingSpeed * 0.2 );

			_unit.setVelX( _unit.getVelX() * 0.6 + unwalkableAreaForce.x );
			_unit.setVelY( _unit.getVelY() * 0.6 + unwalkableAreaForce.y );
		}


		public function clear():void
		{
			_unit = null;
		}


		public function exit( gameLogics:GameLogics ):void
		{
			// nada
		}
	}
}
