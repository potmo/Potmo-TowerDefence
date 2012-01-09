package com.potmo.tdm.visuals.unit.state
{

	public class UnitStateEnum
	{

		public static const NONE:UnitStateEnum = new UnitStateEnum( "NONE" ); // New born have no target

		public static const DEPLOYING:UnitStateEnum = new UnitStateEnum( "DEPLOYING" ); // Moving from the building to the start position

		public static const GUARDING:UnitStateEnum = new UnitStateEnum( "GUARDING" ); // Guarding outside the building
		public static const CHARGING:UnitStateEnum = new UnitStateEnum( "CHARGING" ); // Charging towards the enemies side

		public static const APPROACH_ATTACK:UnitStateEnum = new UnitStateEnum( "APPROACH_ATTACK" ); // engaging fight with other unit after charging
		public static const APPROACH_DEFEND:UnitStateEnum = new UnitStateEnum( "APPROACH_DEFEND" ); // engaging fight with other unit after guarding

		public static const ATTACKING:UnitStateEnum = new UnitStateEnum( "ATTACKING" ); // fighting other unit after charging
		public static const DEFENDING:UnitStateEnum = new UnitStateEnum( "DEFENDING" ); // fighting other unit after guarding

		public static var WALKING_DEAD:UnitStateEnum = new UnitStateEnum( "WALKING_DEAD" ); // When a unit is dead but animating to the end

		private var name:String;


		public function UnitStateEnum( name:String )
		{
			this.name = name;
		}


		public function toString():String
		{
			return "UnitState[" + name + "]"
		}

	}
}