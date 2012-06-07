package com.potmo.tdm.player
{
	import com.potmo.tdm.visuals.map.MapMovingDirection;

	public class Player
	{
		private var color:PlayerColor;
		private var id:uint;
		private var name:String;
		private var isDevicePlayer:Boolean;
		private var balance:int;


		public function Player( id:uint, name:String, color:PlayerColor, isDevicePlayer:Boolean )
		{
			this.id = id;
			this.name = name;
			this.color = color;
			this.isDevicePlayer = isDevicePlayer;
			this.balance = 400;
		}


		public function canAffordTransaction( amount:int ):Boolean
		{
			// balance must always be above 0. Adding money will make it always
			return balance >= amount;
		}


		public function makeTransaction( amount:int ):Boolean
		{
			// negative amounts must be checked
			if ( amount <= 0 && !canAffordTransaction( amount ) )
			{
				return false;
			}

			balance += amount;
			//TODO: Notify gui somehow about balance change

			return true;

		}


		public function isMe():Boolean
		{
			return isDevicePlayer;
		}


		public function getName():String
		{
			return name;
		}


		public function getId():uint
		{
			return id;
		}


		public function getColor():PlayerColor
		{
			return color;
		}


		public function toString():String
		{
			return "Player[" + name + "(" + id + ")]"
		}


		public function getDefaultMovingDirection():MapMovingDirection
		{
			if ( getColor() == PlayerColor.RED )
			{
				return MapMovingDirection.RIGHT;
			}
			else
			{
				return MapMovingDirection.LEFT;
			}

		}
	}
}

