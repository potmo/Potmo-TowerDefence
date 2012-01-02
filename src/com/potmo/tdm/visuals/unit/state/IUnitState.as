package com.potmo.tdm.visuals.unit.state
{
	import com.potmo.tdm.GameLogics;
	import com.potmo.tdm.visuals.unit.UnitBase;

	public interface IUnitState
	{
		/**
		 * This is called by the unit on a update
		 */
		function visit( gameLogics:GameLogics ):void;

		/**
		 * Get the type of the state
		 */
		function getType():UnitStateEnum;

		/**
		 * Initialize the state
		 */
		//function init( unit:UnitBase, gameLogics:GameLogics ):void;

		/**
		 * Clear the state as if it where new
		 */
		function clear():void;
	}
}
