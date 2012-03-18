package com.potmo.tdm.visuals.unit.settings
{

	public class KnightSetting implements UnitSetting
	{
		public function KnightSetting()
		{
		}


		public function get targetingRange():int
		{
			return 60;
		}


		public function get attackingRange():int
		{
			return 30;
		}


		public function get hitDelay():int
		{
			return 20;
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
