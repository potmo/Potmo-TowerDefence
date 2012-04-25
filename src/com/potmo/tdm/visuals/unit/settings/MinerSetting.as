package com.potmo.tdm.visuals.unit.settings
{

	public class MinerSetting implements UnitSetting
	{
		public function MinerSetting()
		{
		}


		public function get targetingRange():int
		{
			return 0;
		}


		public function get attackingRange():int
		{
			return 0;
		}


		public function get hitDelay():int
		{
			return 0;
		}


		public function get hitDamage():int
		{
			return 0;
		}


		public function get movingSpeed():int
		{
			return 2;
		}


		public function get radius():int
		{
			return 10;
		}


		public function get maxHealth():int
		{
			return 20;
		}


		public function get healDelay():int
		{
			return 50;
		}
	}
}
