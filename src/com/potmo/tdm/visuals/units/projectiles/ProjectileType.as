package com.potmo.tdm.visuals.units.projectiles
{

	public class ProjectileType
	{
		public static var ARROW:ProjectileType = new ProjectileType( "ARROW", Arrow );
		private var name:String;
		private var clazz:Class;


		public function ProjectileType( name:String, clazz:Class )
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
			return "ProjectileType[" + name + "]"
		}

	}
}
