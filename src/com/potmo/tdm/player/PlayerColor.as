package com.potmo.tdm.player
{

	public class PlayerColor
	{
		public static const RED:PlayerColor = new PlayerColor( "RED", 0 );
		public static const BLUE:PlayerColor = new PlayerColor( "BLUE", 1 );
		public static const NEUTRAL:PlayerColor = new PlayerColor( "NEUTRAL", 2 );
		private var name:String;
		private var id:uint;


		public function PlayerColor( name:String, id:uint )
		{
			this.name = name;
			this.id = id;
		}


		public function getId():uint
		{
			return id;
		}


		public function toString():String
		{
			return "PlayerColor[" + name + "]";
		}
	}
}
