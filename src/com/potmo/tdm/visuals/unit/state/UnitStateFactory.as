package com.potmo.tdm.visuals.unit.state
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.state.variant.ChargeState;
	import com.potmo.tdm.visuals.unit.state.variant.DeployState;
	import com.potmo.tdm.visuals.unit.state.variant.GuardState;
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


		public function getNoneState():NoneState
		{
			return new NoneState();
		}


		public function getDeployState():DeployState
		{
			return new DeployState();
		}


		public function getGuardState():GuardState
		{
			return new GuardState();
		}


		public function getChargeState():ChargeState
		{
			return new ChargeState();
		}
	}
}
