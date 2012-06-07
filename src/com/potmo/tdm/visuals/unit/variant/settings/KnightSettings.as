package com.potmo.tdm.visuals.unit.variant.settings
{
	import com.potmo.tdm.visuals.unit.UnitType;

	public class KnightSettings implements UnitSettings
	{
		public function KnightSettings()
		{
		}


		public function getTargetingRange():int
		{
			return 60;
		}


		public function getAttackingRange():int
		{
			return 30;
		}


		public function getHitDelay():int
		{
			return 20;
		}


		public function getHitDamage():int
		{
			return 1;
		}


		public function getMovingSpeed():int
		{
			return 3;
		}


		public function getRadius():int
		{
			return 10;
		}


		public function getMaxHealth():int
		{
			return 15;
		}


		public function getHealDelay():int
		{
			return 15;
		}


		public function getUnitType():UnitType
		{
			return UnitType.KNIGHT;
		}


		public function getSequenceName():String
		{
			return "knight";
		}
	}
}
