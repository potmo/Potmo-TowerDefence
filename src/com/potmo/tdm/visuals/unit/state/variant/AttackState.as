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


		final public function AttackState()
		{
			super( UnitStateEnum.ATTACKING );
		}


		public function init( unit:IAttackingUnit, enemy:IUnit, gameLogics:GameLogics ):void
		{
			this._unit = unit;
			this._enemy = enemy;
		}


		public function visit( gameLogics:GameLogics ):void
		{
			//TODO: implement attack functions
		}


		public function clear():void
		{
			_unit = null;
			_enemy = null;
		}

	}
}
