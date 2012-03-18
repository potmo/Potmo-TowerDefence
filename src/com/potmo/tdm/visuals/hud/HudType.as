package com.potmo.tdm.visuals.hud
{
	import com.potmo.tdm.visuals.hud.variant.CampHud;
	import com.potmo.tdm.visuals.hud.variant.ConstructionSiteHud;
	import com.potmo.tdm.visuals.hud.variant.DeployFlagHud;

	public class HudType
	{

		public static const CAMP:HudType = new HudType( "CAMP", CampHud );
		public static const CONSTRUCTION_SITE:HudType = new HudType( "CONSTRUCTION_SITE", ConstructionSiteHud );
		public static const DEPLOY_FLAG:HudType = new HudType( "DEPLOY_FLAG", DeployFlagHud );
		private var clazz:Class;
		private var name:String;


		public function HudType( name:String, clazz:Class )
		{
			this.name = name;
			this.clazz = clazz;
		}


		public function toString():String
		{
			return "HudType[" + name + "]"
		}
	}
}
