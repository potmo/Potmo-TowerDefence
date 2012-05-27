package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.unit.Unit;

	public interface MiningUnit extends Unit
	{
		function handleMiningStateFinished( pickedUp:int, trailX:Number, trailY:Number, direction:MapMovingDirection, gameLogics:GameLogics ):void;
		function handleMovingToMineStateFinished( pointOnTrailX:Number, pointOnTrailY:Number, movingDirection:MapMovingDirection, mine:Mine, gameLogics:GameLogics ):void;
		function handleMovingToMineStateFinishedSinceThereIsNotMines( gameLogics:GameLogics ):void;
		function handleEnteringMineStateFinished( trailX:Number, trailY:Number, direction:MapMovingDirection, mine:Mine, gameLogics:GameLogics ):void;

		function handleLeavingMineStateFinished( direction:MapMovingDirection, pickedUp:int, gameLogics:GameLogics ):void;

		function handleMovingBackFromHomeStateFinished( pickedUp:int, gameLogics:GameLogics ):void;

		function handleEnteringHomeStateFinished( gameLogics:GameLogics ):void;

		function setAlpha( value:Number ):void;

		function getVelX():Number;
		function getVelY():Number;
		function setVelX( value:Number ):void;
		function setVelY( value:Number ):void;
		function setX( value:Number ):void;
		function setY( value:Number ):void;
		function setFrameFromName( name:String ):void;

	}
}
