package com.potmo.tdm.visuals.unit.variant.settings
{
	import com.potmo.tdm.visuals.unit.UnitType;

	public interface UnitSettings
	{
		function getUnitType():UnitType;

		/** @returns The range from deployflag in witch a unit can target another unit */
		function getTargetingRange():int;

		/** @returns The range from unit in witch the unit can hurt another unit */
		function getAttackingRange():int;

		/** @returns The delay witch the unit must wait before engaging again */
		function getHitDelay():int;

		/** @returns The damage the unit can deal to another unit */
		function getHitDamage():int;

		/** The speed at witch the unit can move in */
		function getMovingSpeed():int;

		/** The radius the unit has **/
		function getRadius():int;

		/** The maximum health the unit has */
		function getMaxHealth():int;

		/**  The delay witch the unit must wait before given more health*/
		function getHealDelay():int;

		function getSequenceName():String;
	}
}
