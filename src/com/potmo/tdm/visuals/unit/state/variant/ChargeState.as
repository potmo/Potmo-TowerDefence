package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;

	public class ChargeState extends UnitStateBase implements UnitState
	{
		private var _unit:ChargingUnit;


		final public function ChargeState()
		{
			super( UnitStateEnum.CHARGING );
		}


		public function enter( unit:ChargingUnit, gameLogics:GameLogics ):void
		{
			_unit = unit;
			_unit.setFrameFromName( "WALK" );
		}


		public function visit( gameLogics:GameLogics ):void
		{

			var mapForce:Force = gameLogics.getMap().getMapPathForce( _unit.getX(), _unit.getY(), _unit.getOwningPlayer().getDefaultMovingDirection() );

			// calculate forces from other units that pushes the unit
			var unitCollisionForce:Force;
			unitCollisionForce = gameLogics.getMap().getUnitCollisionForce( gameLogics, _unit );
			unitCollisionForce.scale( 3.0 );
			mapForce.add( unitCollisionForce );

			mapForce.normalize();
			mapForce.scale( _unit.getSettings().movingSpeed );

			// add force from map and unit collistion force
			_unit.setVelX( _unit.getVelX() * 0.2 + mapForce.x );
			_unit.setVelY( _unit.getVelY() * 0.2 + mapForce.y );

			_unit.setX( _unit.getX() + _unit.getVelX() );
			_unit.setY( _unit.getY() + _unit.getVelY() );

			// search for nearby enemy units
			searchForEnemies( gameLogics );

			//TODO: Unit collision forces should apply when charging in a better way. Scaled and weighted
			//TODO: Units should check if they have reached the goal
			//TODO: Units should try to group when charging so they dont spread out too much
		}


		private function searchForEnemies( gameLogics:GameLogics ):void
		{
			var enemy:Unit = gameLogics.getUnitManager().getClosestEnemyUnitPossibleToAttack( _unit );

			if ( enemy )
			{
				_unit.handleChargeStateFinished( enemy, gameLogics );
			}
		}


		public function exit( gameLogics:GameLogics ):void
		{
			//nada
		}


		public function clear():void
		{
			_unit = null;
		}

	}
}
