package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.map.tilemap.forcefieldmap.Force;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.state.IUnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;

	public class ChargeState extends UnitStateBase implements IUnitState
	{
		private var _unit:IChargingUnit;
		private var _enemy:IUnit;


		final public function ChargeState()
		{
			super( UnitStateEnum.CHARGING );
		}


		public function init( unit:IChargingUnit, gameLogics:GameLogics ):void
		{
			_unit = unit;
			_unit.setFrameFromName( "WALK" );
		}


		public function visit( gameLogics:GameLogics ):void
		{

			var mapForce:Force = gameLogics.getMap().getMapPathForce( gameLogics, _unit, _unit.getOwningPlayer().getDefaultMovingDirection() );

			// calculate forces from other units that pushes the unit
			var unitCollisionForce:Force;
			unitCollisionForce = gameLogics.getMap().getUnitCollisionForce( gameLogics, _unit );

			// add force from map and unit collistion force
			_unit.setVelX( _unit.getVelX() + mapForce.x + unitCollisionForce.x );
			_unit.setVelY( _unit.getVelY() + mapForce.y + unitCollisionForce.y );

			// search for nearby enemy units
			searchForEnemies( gameLogics );

			//TODO: Unit collision forces should apply when charging in a better way. Scaled and weighted
			//TODO: Units should check if they have reached the goal
		}


		private function searchForEnemies( gameLogics:GameLogics ):void
		{
			var enemy:IUnit = gameLogics.getUnitManager().getEnemyUnitCloseEnough( _unit, _unit.getSettings().targetingRange );

			if ( enemy )
			{
				_enemy = enemy;
				_unit.handleChargeStateFinished( this, gameLogics );
			}
		}


		/**
		 * If a anemy is found then this isnot null
		 * otherwise it is null
		 */
		public function getEnemy():IUnit
		{
			return _enemy;
		}


		public function clear():void
		{
			_unit = null;
			_enemy = null;
		}
	}
}
