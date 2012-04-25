package com.potmo.tdm.visuals.unit
{
	import com.potmo.tdm.visuals.unit.variant.Knight;
	import com.potmo.tdm.visuals.unit.variant.Miner;

	public class UnitType
	{

		public static const KNIGHT:UnitType = new UnitType( "KNIGHT", Knight );
		//public static const ARCHER:UnitType = new UnitType( "ARCHER", Archer );

		public static const MINER:UnitType = new UnitType( "MINER", Miner );

		private var name:String;
		private var clazz:Class;


		public function UnitType( name:String, clazz:Class )
		{
			this.name = name;
			this.clazz = clazz;
		}


		public function getClass():Class
		{
			return clazz;
		}


		public function toString():String
		{
			return "UnitType[" + name + "]"
		}

	}
}
