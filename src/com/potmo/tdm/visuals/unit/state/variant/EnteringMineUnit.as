package com.potmo.tdm.visuals.unit.state.variant
{
	import com.potmo.tdm.visuals.unit.Unit;

	public interface EnteringMineUnit extends Unit
	{
		function getVelX():Number;
		function getVelY():Number;
		function setVelX( value:Number ):void;
		function setVelY( value:Number ):void;
		function setX( value:Number ):void;
		function setY( value:Number ):void;
		function setFrameFromName( name:String ):void;
	}
}
