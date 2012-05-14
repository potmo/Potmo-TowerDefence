package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.map.MapMovingDirection;
	import com.potmo.tdm.visuals.unit.Unit;

	public interface MovingToMineUnit extends Unit
	{

		function handleMovingToMineStateFinished( pointOnTrailX:Number, pointOnTrailY:Number, movingDirection:MapMovingDirection, mine:Mine, gameLogics:GameLogics ):void;
		function handleMovingToMineStateFinishedSinceThereIsNotMines( gameLogics:GameLogics ):void;

		function getVelX():Number;
		function getVelY():Number;
		function setVelX( value:Number ):void;
		function setVelY( value:Number ):void;
		function setX( value:Number ):void;
		function setY( value:Number ):void;
		function setFrameFromName( name:String ):void;
	}
}
