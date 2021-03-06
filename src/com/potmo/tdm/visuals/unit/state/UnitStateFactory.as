package com.potmo.tdm.visuals.unit.state
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.unit.Unit;
	import com.potmo.tdm.visuals.unit.state.variant.ChargeState;
	import com.potmo.tdm.visuals.unit.state.variant.ChargingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.DeployState;
	import com.potmo.tdm.visuals.unit.state.variant.DeployingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.EnteringHomeState;
	import com.potmo.tdm.visuals.unit.state.variant.EnteringMineState;
	import com.potmo.tdm.visuals.unit.state.variant.FootAttackState;
	import com.potmo.tdm.visuals.unit.state.variant.FootAttackingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.FootDefendState;
	import com.potmo.tdm.visuals.unit.state.variant.FootDefendingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.GuardState;
	import com.potmo.tdm.visuals.unit.state.variant.GuardingUnit;
	import com.potmo.tdm.visuals.unit.state.variant.LeavingMineState;
	import com.potmo.tdm.visuals.unit.state.variant.MiningState;
	import com.potmo.tdm.visuals.unit.state.variant.MiningUnit;
	import com.potmo.tdm.visuals.unit.state.variant.MovingBackFromMineState;
	import com.potmo.tdm.visuals.unit.state.variant.MovingToMineState;
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


		public function getMoveToMineState( oldState:UnitState, unit:MiningUnit, gameLogics:GameLogics ):MovingToMineState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:MovingToMineState = new MovingToMineState();
			newState.enter( unit, gameLogics );
			return newState;
		}


		public function getEnterMineState( oldState:UnitState, unit:MiningUnit, pointOnTrailX:Number, pointOnTrailY:Number, movingDirection:MapMovingDirection, mine:Mine, gameLogics:GameLogics ):EnteringMineState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:EnteringMineState = new EnteringMineState();
			newState.enter( unit, pointOnTrailX, pointOnTrailY, movingDirection, mine, gameLogics );
			return newState;
		}


		public function getMiningState( oldState:UnitState, unit:MiningUnit, trailX:Number, trailY:Number, direction:MapMovingDirection, mine:Mine, gameLogics:GameLogics ):MiningState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:MiningState = new MiningState();
			newState.enter( unit, trailX, trailY, direction, mine, gameLogics );
			return newState;

		}


		public function getLeavingMineState( oldState:UnitState, unit:MiningUnit, trailX:Number, trailY:Number, pickedUp:int, direction:MapMovingDirection, gameLogics:GameLogics ):LeavingMineState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:LeavingMineState = new LeavingMineState();
			newState.enter( unit, trailX, trailY, direction, pickedUp, gameLogics );
			return newState;
		}


		public function getMovingBackFromMineState( oldState:UnitState, unit:MiningUnit, direction:MapMovingDirection, pickedUp:int, gameLogics:GameLogics ):MovingBackFromMineState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:MovingBackFromMineState = new MovingBackFromMineState();
			newState.enter( unit, direction, pickedUp, gameLogics );
			return newState;
		}


		public function getEnteringHomeState( oldState:UnitState, unit:MiningUnit, pickedUp:int, gameLogics:GameLogics ):EnteringHomeState
		{
			oldState.exit( gameLogics );
			returnState( oldState );

			var newState:EnteringHomeState = new EnteringHomeState();
			newState.enter( unit, pickedUp, gameLogics );
			return newState;
		}

	}
}
