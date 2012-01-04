package com.potmo.tdm.visuals.map.forcemap
{

	public class MapTileType
	{
		public static const DEFAULT_WALKABLE_TILE:MapTileType = new MapTileType( "DEFAULT_WALKABLE_TILE", 0 );
		public static const DEFAULT_UNWALKABLE_TILE:MapTileType = new MapTileType( "DEFAULT_UNWALKABLE_TILE", 1 );

		private var name:String;
		private var id:int;


		public function MapTileType( name:String, id:int )
		{
			this.name = name;
			this.id = id;
		}


		public function toString():String
		{
			return "MapTileType[" + name + "(" + id + ")" + "]";
		}
	}
}
