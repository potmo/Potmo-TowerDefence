package com.potmo.tdm.visuals.map
{

	public class PathCheckpoint
	{

		private var _id:int;
		private var _x:int;
		private var _y:int;


		public function PathCheckpoint( id:int, x:int, y:int )
		{
			this._id = id;
			this._x = x;
			this._y = y;
		}


		public function get id():int
		{
			return _id;
		}


		public function get x():int
		{
			return _x;
		}


		public function get y():int
		{
			return _y;
		}

	}
}