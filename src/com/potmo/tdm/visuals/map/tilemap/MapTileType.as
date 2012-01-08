package com.potmo.tdm.visuals.map.tilemap
{

	public class MapTileType
	{
		public static const DEFAULT_WALKABLE_TILE:MapTileType = new MapTileType( "DEFAULT_WALKABLE_TILE", 0, true, 0 );
		public static const DEFAULT_UNWALKABLE_TILE:MapTileType = new MapTileType( "DEFAULT_UNWALKABLE_TILE", 1, false, 1 );

		private var name:String;
		private var id:int;
		private var walkable:Boolean;
		private var walkCost:Number;


		public function MapTileType( name:String, id:int, walkable:Boolean, walkCost:Number )
		{
			this.name = name;
			this.id = id;
			this.walkable = walkable;
			this.walkCost = walkCost;
		}


		public function isWalkable():Boolean
		{
			return walkable;
		}


		public function getWalkCost():Number
		{
			return walkCost;
		}


		public function toString():String
		{
			return "MapTileType[" + name + "(" + id + ")" + "]";
		}
	}
}
