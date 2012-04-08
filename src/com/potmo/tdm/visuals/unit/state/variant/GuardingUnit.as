package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.Unit;

	public interface GuardingUnit extends Unit
	{
		function handleGuardStateFinished( state:GuardState, enemy:Unit, gameLogics:GameLogics ):void;
		function setFrameFromName( name:String ):void;
		function getVelX():Number;
		function getVelY():Number;
		function setVelX( value:Number ):void;
		function setVelY( value:Number ):void;
		function setX( value:Number ):void;
		function setY( value:Number ):void;
	}
}
