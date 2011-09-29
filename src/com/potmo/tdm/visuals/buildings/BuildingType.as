package com.potmo.tdm.visuals.buildings
{

	public class BuildingType
	{

		public static const CONSTRUCTION_SITE:BuildingType = new BuildingType( "CONSTRUCTION_SITE" );

		// buildings making fotmen with sword and alike
		public static const CAMP:BuildingType = new BuildingType( "CAMP" );
		public static const KEEP:BuildingType = new BuildingType( "KEEP" );
		public static const FORTRESS:BuildingType = new BuildingType( "FORTRESS" );
		public static const CASTLE:BuildingType = new BuildingType( "CASTLE" );
		public static const CITADELL:BuildingType = new BuildingType( "CITADELL" );

		// Builings making archers with arrows and alike
		public static const ARCHERY:BuildingType = new BuildingType( "ARCHERY" );

		private var name:String;


		public function BuildingType( name:String )
		{
			this.name = name;
		}


		public static function getUpgrade( type:BuildingType ):BuildingType
		{
			switch ( type )
			{
				case CAMP:
					return KEEP;
				case KEEP:
					return FORTRESS;
				case FORTRESS:
					return CASTLE;
				case CASTLE:
					return CITADELL;

				default:
					throw new Error( "There are no upgrade for building type: " + type );
			}
		}


		public function toString():String
		{
			return "BuildingType[" + name + "]"
		}
	}
}