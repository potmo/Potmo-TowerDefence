package com.potmo.tdm.visuals.map.forcemap
{

	public class MapTile implements IMapTile
	{

		protected var _type:MapTileType;
		protected var _x:int;
		protected var _y:int;


		public function MapTile( x:int, y:int, type:MapTileType )
		{
			this._x = x;
			this._y = y;
			this._type = type;
		}


		public function get x():int
		{
			return _x;
		}


		public function get y():int
		{
			return _y;
		}


		public function setType( type:MapTileType ):void
		{
			this._type = type;
		}


		public function getType():MapTileType
		{
			return this._type;
		}


		public function getHash():uint
		{
			// shift x 16 left and or y on
			return _x << 16 | _y;
		}
	}
}
