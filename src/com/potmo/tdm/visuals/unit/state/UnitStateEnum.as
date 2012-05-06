package com.potmo.tdm.visuals.unit.state
{

	public class UnitStateEnum
	{

		public static const NONE:UnitStateEnum = new UnitStateEnum( "NONE" ); // New born have no target

		public static const DEPLOYING:UnitStateEnum = new UnitStateEnum( "DEPLOYING" ); // Setting the start position
		public static const MOVING_TO_POSITION:UnitStateEnum = new UnitStateEnum( "MOVING_TO_POSITION" ); // Moving to a position with a straight line

		public static const GUARDING:UnitStateEnum = new UnitStateEnum( "GUARDING" ); // Guarding outside the building
		public static const CHARGING:UnitStateEnum = new UnitStateEnum( "CHARGING" ); // Charging towards the enemies side

		public static const FOOTATTACKING:UnitStateEnum = new UnitStateEnum( "FOOTATTACKING" ); // fighting other unit after charging
		public static const FOOTDEFENDING:UnitStateEnum = new UnitStateEnum( "FOOTDEFENDING" ); // fighting other unit after guarding

		public static var DYING:UnitStateEnum = new UnitStateEnum( "DYING" ); // When a unit is dead but animating to the end

		public static const MOVING_TO_MINE:UnitStateEnum = new UnitStateEnum( "MOVING_TO_MINE" ); // Moving to the closest mine

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
