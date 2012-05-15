package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.unit.Unit;

	public interface MiningUnit extends Unit
	{
		function handleMiningStateFinished( pickedUp:int, trailX:Number, trailY:Number, direction:MapMovingDirection, gameLogics:GameLogics ):void;
		function setAlpha( value:Number ):void;
	}
}
