package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.IUnit;

	public interface GuardingUnit extends IUnit
	{
		function handleGuardStateFinished( state:GuardState, gameLogics:GameLogics ):void;
		function setFrameFromName( name:String ):void;
		function getVelX():Number;
		function getVelY():Number;
		function setVelX( value:Number ):void;
		function setVelY( value:Number ):void;
		function setX( value:Number ):void;
		function setY( value:Number ):void;
	}
}
