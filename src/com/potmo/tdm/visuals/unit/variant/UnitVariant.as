package com.potmo.tdm.visuals.unit.variant
{
	import com.potmo.tdm.GameLogics;

	/**
	 * This is a convenience interface for easier implementations of functions in baseclass of unit that should be overridden
	 */
	public interface UnitVariant
	{
		function handleBeingKilled( gameLogics:GameLogics ):void;
		function handleBeingHurt( damage:int, gameLogics:GameLogics ):void;
		function handleBeingHealed( aid:int, gameLogics:GameLogics ):void;
		function handleBeeingCommandedToCharge( gameLogics:GameLogics ):void;
		function handleBeingDeployed( x:int, y:int, gameLogics:GameLogics ):void;
		function handleBeeingCommandedToMoveToPosition( x:int, y:int, gameLogics:GameLogics ):void;
	}
}
