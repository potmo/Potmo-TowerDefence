package com.potmo.tdm.visuals.units.settings
{

	public class ArcherSetting implements IUnitSetting
	{
		public function ArcherSetting()
		{

		}


		public function get targetingRange():int
		{
			return 400;
		}


		public function get attackingRange():int
		{
			return this.targetingRange;
		}


		public function get hitDelay():int
		{
			return 10;
		}


		public function get hitDamage():int
		{
			return 1;
		}


		public function get movingSpeed():int
		{
			return 3;
		}


		public function get radius():int
		{
			return 10;
		}


		public function get maxHealth():int
		{
			return 15;
		}


		public function get healDelay():int
		{
			return 15;
		}
	}
}
