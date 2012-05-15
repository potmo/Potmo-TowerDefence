package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.unit.state.UnitState;
	import com.potmo.tdm.visuals.unit.state.UnitStateBase;
	import com.potmo.tdm.visuals.unit.state.UnitStateEnum;

	public class MiningState extends UnitStateBase implements UnitState
	{
		private var _unit:MiningUnit;
		private var _trailX:Number;
		private var _trailY:Number;
		private var _direction:MapMovingDirection;
		private var _mine:Mine;
		private var _carrying:int;
		private var _maxToCarry:int;
		private var _extractionRate:int;


		final public function MiningState()
		{
			super( UnitStateEnum.MINING );
		}


		public function enter( unit:MiningUnit, trailX:Number, trailY:Number, direction:MapMovingDirection, mine:Mine, gameLogics:GameLogics ):void
		{
			_unit = unit;
			_trailX = trailX;
			_trailY = trailY;
			_direction = direction;
			_mine = mine;

			//TODO: Time to mine should come from the unit settings not hardcoded
			_carrying = 0;
			_maxToCarry = 150; // TODO: Max possible for miner to carry should come from unit settings not hardcoded
			_extractionRate = 2; // TODO: pickuprate for miner should come from unit settings not hardcoded

			_unit.setAlpha( 0 );

		}


		public function visit( gameLogics:GameLogics ):void
		{
			var extracted:Number = _mine.extract( _extractionRate, gameLogics );

			if ( extracted == 0 )
			{
				leaveMine( gameLogics );
				return;
			}

			_carrying += extracted;

			if ( _carrying == _maxToCarry )
			{
				leaveMine( gameLogics );
				return;
			}
		}


		private function leaveMine( gameLogics:GameLogics ):void
		{
			_unit.handleMiningStateFinished( _carrying, _trailX, _trailY, _direction, gameLogics );
		}


		public function exit( gameLogics:GameLogics ):void
		{
			_unit.setAlpha( 1 );
		}


		public function clear():void
		{
			_unit = null;
			_trailX = 0;
			_trailY = 0;
			_direction = null;
			_mine = null;
			_carrying = 0;
			_maxToCarry = 0;
			_extractionRate = 0;
		}
	}
}
