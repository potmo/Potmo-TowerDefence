package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.Unit;

	public interface NoneingUnit extends Unit
	{
		function handleNoneStateFinished( state:NoneState, gameLogics:GameLogics ):void;
	}
}
