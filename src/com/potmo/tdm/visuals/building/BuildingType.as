package com.potmo.tdm.visuals.building
{
	import com.potmo.tdm.visuals.building.variant.Archery;
	import com.potmo.tdm.visuals.building.variant.Camp;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;

	public class BuildingType
	{

		public static const CONSTRUCTION_SITE:BuildingType = new BuildingType( "CONSTRUCTION_SITE", ConstructionSite );

		// buildings making fotmen with sword and alike
		public static const CAMP:BuildingType = new BuildingType( "CAMP", Camp );
		public static const KEEP:BuildingType = new BuildingType( "KEEP", null );
		public static const FORTRESS:BuildingType = new BuildingType( "FORTRESS", null );
		public static const CASTLE:BuildingType = new BuildingType( "CASTLE", null );
		public static const CITADELL:BuildingType = new BuildingType( "CITADELL", null );

		// Builings making archers with arrows and alike
		public static const ARCHERY:BuildingType = new BuildingType( "ARCHERY", Archery );

		private var name:String;
		private var clazz:Class;


		public function BuildingType( name:String, clazz:Class )
		{
			this.name = name;
			this.clazz = clazz;
		}


		public function getClass():Class
		{
			return clazz;
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