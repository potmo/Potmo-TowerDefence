package com.potmo.tdm.visuals.unit.state
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.IUnit;
	import com.potmo.tdm.visuals.unit.settings.UnitSetting;
	import com.potmo.tdm.visuals.unit.state.variant.FootAttackState;
	import com.potmo.tdm.visuals.unit.state.variant.ChargeState;
	import com.potmo.tdm.visuals.unit.state.variant.DeployState;
	import com.potmo.tdm.visuals.unit.state.variant.GuardState;
	import com.potmo.tdm.visuals.unit.state.variant.FootAttackingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.ChargingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.DeployingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.GuardingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.NoneingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.NoneState;

	public class UnitStateFactory
	{
		private var none:UnitState;


		public function UnitStateFactory()
		{
			// TODO: Populate arrays of states	
		}


		public function returnState( state:UnitState ):void
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
		public function getNoneState( oldState:UnitState, unit:NoneingUnit, gameLogics:GameLogics ):NoneState
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


		public function getDeployState( oldState:UnitState, unit:DeployingUnit, deployX:int, deployY:int, gameLogics:GameLogics ):DeployState
		{

			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:DeployState = new DeployState();
			newState.enter( unit, deployX, deployY, gameLogics );
			return newState;
		}


		public function getGuardState( oldState:UnitState, unit:GuardingUnit, gameLogics:GameLogics ):GuardState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:GuardState = new GuardState();
			newState.enter( unit, gameLogics );
			return newState;
		}


		public function getChargeState( oldState:UnitState, unit:ChargingUnit, gameLogics:GameLogics ):ChargeState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:ChargeState = new ChargeState();
			newState.enter( unit, gameLogics );
			return newState;

		}


		public function getFootAttackState( oldState:UnitState, unit:FootAttackingUnit, enemy:IUnit, gameLogics:GameLogics ):FootAttackState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:FootAttackState = new FootAttackState();
			newState.enter( unit, enemy, gameLogics );
			return newState;
		}
	}
}
