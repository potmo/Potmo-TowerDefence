package com.potmo.tdm.visuals.units
{

	public class UnitType
	{

		public static const KNIGHT:UnitType = new UnitType( "KNIGHT" );
		public static const ARCHER:UnitType = new UnitType( "ARCHER" );
		private var name:String;


		public function UnitType( name:String )
		{
			this.name = name;
		}


		public function toString():String
		{
			return "UnitType[" + name + "]"
		}

	}
}