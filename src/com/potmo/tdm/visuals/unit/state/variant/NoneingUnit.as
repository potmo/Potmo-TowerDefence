package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.IUnit;

	public interface NoneingUnit extends IUnit
	{
		function handleNoneStateFinished( state:NoneState, gameLogics:GameLogics ):void;
	}
}
