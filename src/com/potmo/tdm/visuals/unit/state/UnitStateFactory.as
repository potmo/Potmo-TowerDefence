package com.potmo.tdm.visuals.unit.state
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.settings.IUnitSetting;
	import com.potmo.tdm.visuals.unit.state.variant.FootAttackState;
	import com.potmo.tdm.visuals.unit.state.variant.ChargeState;
	import com.potmo.tdm.visuals.unit.state.variant.DeployState;
	import com.potmo.tdm.visuals.unit.state.variant.GuardState;
	import com.potmo.tdm.visuals.unit.state.variant.IFootAttackingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.IChargingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.IDeployingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.IGuardingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.INoneingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.NoneState;

	public class UnitStateFactory
	{
		private var none:IUnitState;


		public function UnitStateFactory()
		{
			// TODO: Populate arrays of states	
		}


		public function returnState( state:IUnitState ):void
		{
			if ( !state )
			{
				return;
			}
			//TODO: repopulate the list of states. Remember that its possible to find the correct state bucket from state.getType()
			state.clear();
		}


		/**
		 * Get none state.
		 * @param oldState can be null
		 * @param unit
		 * @param gameLogics
		 * @returns a NoneState
		 */
		public function getNoneState( oldState:IUnitState, unit:INoneingUnit, gameLogics:GameLogics ):NoneState
		{

			if ( oldState )
			{
				oldState.exit( gameLogics );
				returnState( oldState );
			}

			var newState:NoneState = new NoneState();
			newState.enter( unit, gameLogics );
			return newState;

		}


		public function getDeployState( oldState:IUnitState, unit:IDeployingUnit, deployX:int, deployY:int, gameLogics:GameLogics ):DeployState
		{

			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:DeployState = new DeployState();
			newState.enter( unit, deployX, deployY, gameLogics );
			return newState;
		}


		public function getGuardState( oldState:IUnitState, unit:IGuardingUnit, gameLogics:GameLogics ):GuardState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:GuardState = new GuardState();
			newState.enter( unit, gameLogics );
			return newState;
		}


		public function getChargeState( oldState:IUnitState, unit:IChargingUnit, gameLogics:GameLogics ):ChargeState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:ChargeState = new ChargeState();
			newState.enter( unit, gameLogics );
			return newState;

		}


		public function getAttackState( oldState:IUnitState, unit:IFootAttackingUnit, enemy:IUnit, gameLogics:GameLogics ):FootAttackState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:FootAttackState = new FootAttackState();
			newState.enter( unit, enemy, gameLogics );
			return newState;
		}
	}
}
