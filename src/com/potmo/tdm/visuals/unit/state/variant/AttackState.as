package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.state.IUnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;

	public class AttackState extends UnitStateBase implements IUnitState
	{
		private var _enemy:IUnit;
		private var _unit:IAttackingUnit;

		private var _hitDelay:int = 0;


		final public function AttackState()
		{
			super( UnitStateEnum.ATTACKING );
		}


		public function init( unit:IAttackingUnit, enemy:IUnit, gameLogics:GameLogics ):void
		{
			this._unit = unit;
			this._enemy = enemy;

			_enemy.startBeingTargetedByUnit( _unit );

			_hitDelay = unit.getSettings().hitDelay;
		}


		public function visit( gameLogics:GameLogics ):void
		{
			_hitDelay--;

			if ( _hitDelay <= 0 )
			{
				damageEnemy( gameLogics );
			}

			//TODO: Check if unit is dead then stop
			//TODO: Check if unit is too far away then stop

		}


		private function damageEnemy( gameLogics:GameLogics ):void
		{

			// damage
			var damage:int = _unit.getSettings().hitDamage;
			_enemy.damage( damage, gameLogics );

			// reset hit delay
			_hitDelay = _unit.getSettings().hitDelay;
		}


		public function clear():void
		{
			_unit = null;
			_enemy = null;
			_hitDelay = 0;
		}

	}
}
