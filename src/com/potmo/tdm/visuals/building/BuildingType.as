package com.potmo.tdm.visuals.building
{
	import com.potmo.tdm.visuals.building.variant.Archery;
	import com.potmo.tdm.visuals.building.variant.Camp;
	import com.potmo.tdm.visuals.building.variant.ConstructionSite;
	import com.potmo.tdm.visuals.building.variant.Mine;
	import com.potmo.tdm.visuals.building.variant.MinersHut;

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

		// Building that collect money
		public static const MINERS_HUT:BuildingType = new BuildingType( "MINERS_HUT", MinersHut );

		// building where money can be collected
		public static var MINE:BuildingType = new BuildingType( "MINE", Mine );

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


		public function toString():String
		{
			return "BuildingType[" + name + "]"
		}
	}
}
