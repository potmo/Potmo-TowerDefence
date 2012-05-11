package com.potmo.tdm.visuals.unit.state
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.tdm.visuals.unit.state.variant.ChargeState;
	import com.potmo.tdm.visuals.unit.state.variant.ChargingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.DeployState;
	import com.potmo.tdm.visuals.unit.state.variant.DeployingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.FootAttackState;
	import com.potmo.tdm.visuals.unit.state.variant.FootAttackingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.FootDefendState;
	import com.potmo.tdm.visuals.unit.state.variant.FootDefendingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.GuardState;
	import com.potmo.tdm.visuals.unit.state.variant.GuardingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.MovingToMineState;
	import com.potmo.tdm.visuals.unit.state.variant.MovingToMineUnit;
	import com.potmo.tdm.visuals.unit.state.variant.MovingToPositionState;
	import com.potmo.tdm.visuals.unit.state.variant.MovingToPositionUnit;
	import com.potmo.tdm.visuals.unit.state.variant.NoneState;
	import com.potmo.tdm.visuals.unit.state.variant.NoneingUnit;

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


		public function getMoveToPositionState( oldState:UnitState, unit:MovingToPositionUnit, posX:int, posY:int, gameLogics:GameLogics ):MovingToPositionState
		{

			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:MovingToPositionState = new MovingToPositionState();
			newState.enter( unit, posX, posY, gameLogics );
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


		public function getFootAttackState( oldState:UnitState, unit:FootAttackingUnit, enemy:Unit, gameLogics:GameLogics ):FootAttackState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:FootAttackState = new FootAttackState();
			newState.enter( unit, enemy, gameLogics );
			return newState;
		}


		public function getFootDefendState( oldState:UnitState, unit:FootDefendingUnit, enemy:Unit, gameLogics:GameLogics ):FootDefendState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:FootDefendState = new FootDefendState();
			newState.enter( unit, enemy, gameLogics );
			return newState;
		}


		public function getFindClosestMineState( oldState:UnitState, unit:MovingToMineUnit, gameLogics:GameLogics ):UnitState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:MovingToMineState = new MovingToMineState();
			newState.enter( unit, gameLogics );
			return newState;
		}
	}
}
