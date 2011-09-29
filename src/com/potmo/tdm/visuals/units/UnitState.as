package com.potmo.tdm.visuals.units
{

	public class UnitState
	{

		public static const NONE:UnitState = new UnitState( "NONE" ); // New born have no target

		public static const DEPLOYING:UnitState = new UnitState( "DEPLOYING" ); // Moving from the building to the start position

		public static const GUARDING:UnitState = new UnitState( "GUARDING" ); // Guarding outside the building
		public static const CHARGING:UnitState = new UnitState( "CHARGING" ); // Charging towards the enemies side

		public static const ENGAGING_ATTACK:UnitState = new UnitState( "ENGAGING_ATTACK" ); // engaging fight with other unit after charging
		public static const ENGAGING_DEFEND:UnitState = new UnitState( "ENGAGING_DEFEND" ); // engaging fight with other unit after guarding

		public static const ATTACKING:UnitState = new UnitState( "ATTACKING" ); // fighting other unit after charging
		public static const DEFENDING:UnitState = new UnitState( "DEFENDING" ); // fighting other unit after guarding

		private var name:String;


		public function UnitState( name:String )
		{
			this.name = name;
		}


		public function toString():String
		{
			return "UnitState[" + name + "]"
		}

	}
}
