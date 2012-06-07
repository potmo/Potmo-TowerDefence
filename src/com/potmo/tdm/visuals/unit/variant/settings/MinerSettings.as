package com.potmo.tdm.visuals.unit.variant.settings
{
	import com.potmo.tdm.visuals.unit.UnitType;

	public class MinerSettings implements UnitSettings
	{
		public function MinerSettings()
		{
		}


		public function getTargetingRange():int
		{
			return 0;
		}


		public function getAttackingRange():int
		{
			return 0;
		}


		public function getHitDelay():int
		{
			return 0;
		}


		public function getHitDamage():int
		{
			return 0;
		}


		public function getMovingSpeed():int
		{
			return 2;
		}


		public function getRadius():int
		{
			return 10;
		}


		public function getMaxHealth():int
		{
			return 20;
		}


		public function getHealDelay():int
		{
			return 50;
		}


		public function getUnitType():UnitType
		{
			return UnitType.MINER;
		}


		public function getSequenceName():String
		{
			//TODO: Miner should have its own graphics
			return "knight";
		}

	}
}
