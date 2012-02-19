package com.potmo.tdm.visuals.map
{

	public class MapMovingDirection
	{
		public static const RIGHT:MapMovingDirection = new MapMovingDirection( "right" );
		public static const LEFT:MapMovingDirection = new MapMovingDirection( "left" );

		private var _name:String;


		public function MapMovingDirection( name:String )
		{
			this._name = name;
		}


		public function toString():String
		{
			return "MapMovingDirection[" + _name + "]";
		}

	}
}
