package com.potmo.tdm.visuals.unit.settings
{

	public interface UnitSetting
	{
		/** @returns The range from deployflag in witch a unit can target another unit */
		function get targetingRange():int;

		/** @returns The range from unit in witch the unit can hurt another unit */
		function get attackingRange():int;

		/** @returns The delay witch the unit must wait before engaging again */
		function get hitDelay():int;

		/** @returns The damage the unit can deal to another unit */
		function get hitDamage():int;

		/** The speed at witch the unit can move in */
		function get movingSpeed():int;

		/** The radius the unit has **/
		function get radius():int;

		/** The maximum health the unit has */
		function get maxHealth():int;

		/**  The delay witch the unit must wait before given more health*/
		function get healDelay():int;
	}
}
