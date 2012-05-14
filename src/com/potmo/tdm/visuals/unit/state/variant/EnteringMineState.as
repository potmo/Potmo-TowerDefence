package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;

	public class EnteringMineState extends UnitStateBase implements UnitState
	{
		private var _unit:EnteringMineUnit;
		private var _trailX:Number;
		private var _trailY:Number;
		private var _direction:MapMovingDirection;
		private var _mine:Mine;


		final public function EnteringMineState()
		{
			super( UnitStateEnum.ENTERING_MINE );
		}


		public function enter( unit:EnteringMineUnit, trailX:Number, trailY:Number, direction:MapMovingDirection, mine:Mine, gameLogics:GameLogics ):void
		{
			_unit = unit;
			_trailX = trailX;
			_trailY = trailY;
			_direction = direction;
			_mine = mine;
		}


		public function visit( gameLogics:GameLogics ):void
		{
		}


		public function exit( gameLogics:GameLogics ):void
		{
		}


		public function clear():void
		{
			_unit = null;
			_trailX = 0;
			_trailY = 0;
			_direction = null;
			_mine = null;
		}
	}
}
