package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.state.IUnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;

	public class NoneState extends UnitStateBase implements IUnitState
	{
		private var _unit:INoneingUnit;


		public function NoneState():void
		{
			super( UnitStateEnum.NONE );
		}


		public function visit( gameLogics:GameLogics ):void
		{
			// do nothing
		}


		public function enter( unit:INoneingUnit, gameLogics:GameLogics ):void
		{
			// just save the unit for later use
			_unit = unit;
		}


		public function exit( gameLogics:GameLogics ):void
		{
			// nada
		}


		public function clear():void
		{
			// clear everything saved
			_unit = null;
		}

	}
}
